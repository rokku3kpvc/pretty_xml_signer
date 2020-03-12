require 'dry/cli'
require 'fauthentic'
require 'xmldsig'
require 'yaml'

module Texts
  TEXTS_FILE = 'locales.ru.yml'.freeze

  class << self
    def get(category, key)
      load_texts[category.to_s][key.to_s]
    end

    private

    def load_texts
      @texts ||= YAML.load_file(TEXTS_FILE)
    end
  end
end

module CLI
  VERSION = '1.0.0'.freeze

  module Commands
    extend Dry::CLI::Registry

    class Version < Dry::CLI::Command
      desc Texts.get(:desc, :version)

      def call(*)
        puts VERSION
      end
    end

    class Sign < Dry::CLI::Command
      desc Texts.get(:desc, :sign)

      argument :file, type: :string, required: true, desc: Texts.get(:desc, :file)
      option :key_name, default: '', desc: Texts.get(:desc, :key_name)
      option :cert_name, default: '', desc: Texts.get(:desc, :cert_name)

      def call(file:, key_name:, cert_name:, **)
        pre_call_hook(file)
        key_name = nil if key_name.empty?
        cert_name = nil if cert_name.empty?

        Core::Signer.new(file).process(key_name: key_name, cert_name: cert_name)
        puts Texts.get(:info, :success)
      end

      private

      def pre_call_hook(file)
        raise StandardError, Texts.get(:errors, :no_file) unless File.exist?(file)
      end
    end

    class Verify < Dry::CLI::Command
      desc Texts.get(:desc, :verify)

      argument :file, type: :string, required: true, desc: Texts.get(:desc, :file)
      argument :cert, type: :string, required: true, desc: Texts.get(:desc, :cert)

      def call(file:, cert:)
        pre_call_hook(file, cert)
        Core::Verifier.new(file, cert).process
      end

      private

      def pre_call_hook(file, cert)
        raise StandardError, Texts.get(:errors, :no_file) unless File.exist?(file)
        raise StandardError, Texts.get(:errors, :no_cert) unless File.exist?(cert)
      end
    end

    register 'version', Version, aliases: %w[v -v --version]
    register 'sign', Sign, aliases: %w[s -s --sign]
    register 'verify', Verify, aliases: %w[ver -ver --verify]
  end
end

module Core
  class Signer
    def initialize(xml_path)
      @xml_path = xml_path
      @ssl = Fauthentic.generate
      @unsigned_xml = File.read(xml_path)
    end

    def process(key_name:, cert_name:)
      unsigned_document = Xmldsig::SignedDocument.new(@unsigned_xml)
      signed_xml = unsigned_document.sign(@ssl.key)
      write_files(signed_xml, key_name, cert_name)
    end

    private

    def write_files(xml, key_name, cert_name)
      path = File.dirname(@xml_path)
      key_name = key_name ? "#{key_name}.pem" : 'private_key.pem'
      cert_name = cert_name ? "#{cert_name}.cer" : 'certificate.cer'
      xml_path = File.join(path, "signed_#{File.basename(@xml_path)}")

      File.write(xml_path, xml)
      File.write(File.join(path, key_name), @ssl.key.to_pem)
      File.write(File.join(path, cert_name), @ssl.cert.to_s)

      puts Texts.get(:info, :write_files) % { key: key_name, cert: cert_name }
    end
  end

  class Verifier
    def initialize(xml_path, cert_path)
      @xml = File.read(xml_path)
      @certificate = OpenSSL::X509::Certificate.new(File.read(cert_path))
    rescue OpenSSL::X509::CertificateError => e
      puts Texts.get(:errors, :cert_error)
      abort(e.inspect)
    end

    def process
      signed_document = Xmldsig::SignedDocument.new(@xml)
      document_validates = signed_document.validate(@certificate)

      if document_validates
        puts Texts.get(:info, :validation_success)
      else
        puts Texts.get(:info, :validation_failure)
      end
    rescue Nokogiri::XML::SyntaxError => e
      puts Texts.get(:errors, :xml_parse_error)
      abort(e.inspect)
    end
  end
end

Dry::CLI.new(CLI::Commands).call if $PROGRAM_NAME == __FILE__
