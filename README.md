# PrettyXMLSigner

PrettyXMLSigner является результатом выполнения лабораторной работы по дисциплине "Информационная Безопасность".  
ПО демонстрирует создания подписи XML файла с последующей проверкой на подлинность с помощью [X.509](https://ru.wikipedia.org/wiki/X.509)

## Зависимости

Необходимая версия ЯП Ruby содержится в файле `.ruby-version`.  
В качестве инструкций по установке можно использовать данную [документацию](https://www.ruby-lang.org/ru/documentation/installation/).  
Программа использует [bundler](https://bundler.io/) версии 2.0.2 для управлением зависимостями.  
Установка:
```bash
gem install bundler -v 2.0.2
```
Список зависимостей описан в `Gemfile`  
Для установки всех библиотек необходимо выполнить:
```bash
bundle install
```

## Использование
PrettyXMLSigner предоставляет удобный [CLI](https://ru.wikipedia.org/wiki/CLI)  

Список команд можно посмотреть с помощью флага `--help`
```bash
bundle exec ruby pretty_xml_signer.rb --help
```

Флаг `--help` также можно указать для получение справки по конкретной команде, пример:
```bash
bundle exec ruby pretty_xml_signer.rb version --help
```

#### Создание сертификата и подпись документа
В процессе подписи документа генерируется сертификат в формате `.cer` и приватный RSA ключ формата `.pem`.  
Подпись документа можно осуществить с помощью команды `sign` (также `s -s --sign`).  
В качестве опций можно задать имя ключа и сертификата.
Выходной подписанный XML документ сохраняется с префиксом `signed`.

```bash
$ bundle exec ruby pretty_xml_signer.rb sign --help
Command:
  pretty_xml_signer.rb sign

Usage:
  pretty_xml_signer.rb sign FILE

Description:
  Подписать XML документ

Arguments:
  FILE                  # REQUIRED Путь до XML файла

Options:
  --key-name=VALUE                      # Имя приватного ключа, default: ""
  --cert-name=VALUE                     # Имя сертификата, default: ""
  --help, -h                            # Print this help
```

Сертификат служит для проверки подлинности документа и может быть выложен в открытый доступ:
```text
-----BEGIN CERTIFICATE-----
MIIDzTCCArWgAwIBAgIJVd7kvw6qOCU4MA0GCSqGSIb3DQEBCwUAMEwxCzAJBgNV
BAYTAlVTMRMwEQYDVQQKDApGYXV0aGVudGljMQ0wCwYDVQQLDARUZXN0MRkwFwYD
VQQDDBB0ZXN0LmV4YW1wbGUuY29tMB4XDTIwMDMxMjE3MzMzOFoXDTIwMDQxMTE3
MzMzOFowTDELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkZhdXRoZW50aWMxDTALBgNV
BAsMBFRlc3QxGTAXBgNVBAMMEHRlc3QuZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC84bNv0D2F1+BUDcqWBM4VY2ZZ36oBAx0Ww9av
iuEmUz0YEJ++Mebd+evzGl316ckffixyN6sCDPGNn/GlT/Ig2vxP+xl733xSEK1b
Ws4lqmWIdoRopZvQHJ7k9HUJp+l8omuNKKETZRlLyQalQX9j5jpEdcQZB28prLGX
UcCofFjwItLUca4pzFdifzQNDZQI8QiUTAduILkt5t5eWc1ZeYg3B4tDasdQhyLi
ibJ0JRr1g6c15IjpdxZQrmekHy7MxNdDuE3BCztXQKwnTXsn/mH3PdZZgCI62KeT
ogJgWPobFPM3QitwxIglvaUc7p7VB9VQrRc7RIMLtvpmausHAgMBAAGjgbEwga4w
DwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUPI3PKrLbpw+tMJ/FOCWZG0i8ndYw
fAYDVR0jBHUwc4AUPI3PKrLbpw+tMJ/FOCWZG0i8ndahUKROMEwxCzAJBgNVBAYT
AlVTMRMwEQYDVQQKDApGYXV0aGVudGljMQ0wCwYDVQQLDARUZXN0MRkwFwYDVQQD
DBB0ZXN0LmV4YW1wbGUuY29tgglV3uS/Dqo4JTgwDQYJKoZIhvcNAQELBQADggEB
ALmfQ2JuA/mD5pChAB4cdaLrrYxShHF1UE2ZvvvuUOaQwmS1fmQM9xWobwHPSg1p
C/qcPfyYYG3PuOIHZqOdJbFZbFWBBAs2zCZO6dx8T81Cu5cMPtBBhftOFT23Ar/m
mEgWiWnMbTo30JvBIZk1xjSr49hSXESgh4fiiNrsB5P3SHLe//tgn4qkf/oUdeUC
FKKCOoefU00mu5PLPkFIMDaw5T4ISqvNAGxsUvNpbQC0JUVt1NluGKEEHGme69x/
FuUsLPcXkkTV3mO+o1bQ5YIg/f7c589IDM8EFeREbNE55fOixB624K8ZrwECsZkW
fTLyiEJeIYgfXQrkGmkbjfE=
-----END CERTIFICATE-----
```

Приватный ключ является элементов подписи сертификата и не должен выкладываться в публичный доступ:
```text
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAvOGzb9A9hdfgVA3KlgTOFWNmWd+qAQMdFsPWr4rhJlM9GBCf
vjHm3fnr8xpd9enJH34scjerAgzxjZ/xpU/yINr8T/sZe998UhCtW1rOJapliHaE
aKWb0Bye5PR1CafpfKJrjSihE2UZS8kGpUF/Y+Y6RHXEGQdvKayxl1HAqHxY8CLS
1HGuKcxXYn80DQ2UCPEIlEwHbiC5LebeXlnNWXmINweLQ2rHUIci4omydCUa9YOn
NeSI6XcWUK5npB8uzMTXQ7hNwQs7V0CsJ017J/5h9z3WWYAiOtink6ICYFj6GxTz
N0IrcMSIJb2lHO6e1QfVUK0XO0SDC7b6ZmrrBwIDAQABAoIBAEkxXQtTMsQO54sq
3PpNWl7Haf4hwgsqXbdYpHTZ6G2li+MrbfuR8tjJ5DkMWqTUt29QwYBxOf9NbL1o
4Ych973rniKQN0vdSpuygrsH8SJ/aWD8LEsxAbQfoyMt57yaKMx3VB4bRG/zmV3Y
xI59VxQrPyEQUbExRE5t8VOmBnZDLvao8hJSvj5KlY1dgOTrnM8SiG+WIst1LdUx
wi1lZLOxj+ynUc/j1RjBmDb2c2rUAicg+2b9Qlmcp05wR4pNXad/gq3jhl0wuWVW
OQfdYWxeqKQjm06JGqxPcJ5KPwBBgPqblXobolU3aetN010uSlAM2vsGHpkk/YVH
h1wYQOECgYEA3Qu3VZ25hvr5c6i0lY3b+LwcH5KPFQ0fOkob9BKkyqC/xq6yUxVV
0Z+fUjwhn9f4GFaWg1aH6obVvghMdHVccpkwR+oM7yxitbDcsx0YWW6XD5VyS7GJ
qkIwPDOYk8uF8N7mvlctfHhnOgkjJmUJT5egkMljLqroID+VxiJK2iMCgYEA2r/u
FRyK6CZ4DBZ/69lY3LbsdnkQL7ELPYudMnq53kzshjzmOvhbeMUJ/2rI5oamaGaG
iYXXgSnogLGgGv58qDvVndoSELaJkc5komidoa+5xMki18ToyZuTM3jtMavDGMH1
/2659MH+ZcDBDjtd6mm5ksDGmx01FgsFNviwH80CgYEAnkU+Txow9hoLtKmuK4s4
Xr/p7x1UP8F2g5j+rOMQhVlWF1+MpXqYSRDe1dXiSX4s0NhmysGRbfZ/YqK0g4po
2FEhRcyq2DHSt79cNw91GMvbc7gQ72u+Y18jBGf5LpHCZLZlRxJKql3Xo7FZLquX
YBr0R9c6ofaTYEvG5Og26jsCgYEAkOW/e+Z7MImCzWb99yjyTskwWs2YZi7c5jib
uPtIMTM9HTIrwvYOCTJji/ec+e5JPjBjf6bTeDBdXRnLlvXpdrqjpjrz6nQvLhDL
4jRv7dDruakN1mUNWbYezGKWo2dGBRk9rKQYs0LpE1eZyaaTcBn2HXpqVAcFygMk
wiP67iUCgYEAujMCcnStCfC1EcT9JG0PXJLXJjcW0Vke6NM9PCKVO8/ZBVbF9Ppv
P5CLIzg7Fb+dpCrSvQf6e29wqji5InWs8QAoJHVS0GT7+9u05cePaNH3hou+pQxy
z2ipdGWizDmSizeqWtWvULJ9TIm9UF3KcIqI00HzfVRbrDyL+WgtI3k=
-----END RSA PRIVATE KEY-----
```

Пример XML документа до подписи:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<foo:Foo ID="foo" xmlns:foo="http://example.com/foo#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#">
  <foo:Bar>bar</foo:Bar>
  <foo:Baz>
    <foo:Qux>quuz</foo:Qux>
  </foo:Baz>
  <ds:Signature>
    <ds:SignedInfo>
      <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
      <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
      <ds:Reference URI="#foo">
        <ds:Transforms>
          <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
          <ds:Transform Algorithm="http://www.w3.org/TR/1999/REC-xpath-19991116">
            <ds:XPath>not(ancestor-or-self::foo:Baz)</ds:XPath>
          </ds:Transform>
          <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
            <ec:InclusiveNamespaces PrefixList="foo"/>
          </ds:Transform>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
        <ds:DigestValue></ds:DigestValue>
      </ds:Reference>
    </ds:SignedInfo>
    <ds:SignatureValue></ds:SignatureValue>
  </ds:Signature>
</foo:Foo> 
```

Документ после выполнения программы:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<foo:Foo xmlns:foo="http://example.com/foo#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" ID="foo">
  <foo:Bar>bar</foo:Bar>
  <foo:Baz>
    <foo:Qux>quuz</foo:Qux>
  </foo:Baz>
  <ds:Signature>
    <ds:SignedInfo>
      <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
      <ds:SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
      <ds:Reference URI="#foo">
        <ds:Transforms>
          <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
          <ds:Transform Algorithm="http://www.w3.org/TR/1999/REC-xpath-19991116">
            <ds:XPath>not(ancestor-or-self::foo:Baz)</ds:XPath>
          </ds:Transform>
          <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#">
            <ec:InclusiveNamespaces PrefixList="foo"/>
          </ds:Transform>
        </ds:Transforms>
        <ds:DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
        <ds:DigestValue>0JbPcmLX1+RMSii+Q4SIJWmCDLRHxhR4qXzEgijx5o4=</ds:DigestValue>
      </ds:Reference>
    </ds:SignedInfo>
    <ds:SignatureValue>P5JQAncy7Ka9xVJPVie8/QUDbKt9mU48EDGs1GcbVBj/GI3Wfio6TWYc/KdTSdU3zU190wHXiTYUXBXl6JDdzKNsmIQtHC81OkTZmfv240fzPIcWt8s6zMUDJgyS+7fySVVTxHGWTni9TYieivUYbMfecZq1GHkVafjQ/OnMnjvVJYQ6WItVooQlfXUD0NI1MRyg0qWP7xtlVpbK67uUa5LJVOFk5JRG2Zi9/9PzpopllPj1Bm23syANpSG+gs0JIxCHma4ti9GPIjtQURtMwy+iXzpk9wXbM+JN3dT9Wd1d/eJS1B6b4seyp/xcGcTEFw+dwS2ns5Yd/edwi+VgeQ==</ds:SignatureValue>
  </ds:Signature>
</foo:Foo>
```

#### Проверка подлинности
За проверку подлинности XML документа служит команда `verify` (также `ver -ver --verify`).  
Она требует путь до XML документа и сертификата.

```bash
$ bundle exec ruby pretty_xml_signer.rb verify --help
Command:
  pretty_xml_signer.rb verify

Usage:
  pretty_xml_signer.rb verify FILE CERT

Description:
  Проверить подлинность подписи XML документа

Arguments:
  FILE                  # REQUIRED Путь до XML файла
  CERT                  # REQUIRED Пусть до файла-сертификата

Options:
  --help, -h                            # Print this help
```

В зависимости от результата проверки подписи программа выведет результат в терминал:
```text
Документ успешно прошел проверку подлинности
```
при успешной проверке и
```text
Документ провалил проверку подлинности
```
соответственно, при неудачной проверке.

## TODO
1) Написать системные и юнит тесты.
2) Вынести классы и модули в отдельные файлы, создать единую точку входа с подгрузкой всех зависимостей.
3) Обработать поведение при возникновении дополнительных неожиданных исключений.

## Содействие
Пользование PrettyXMLSigner покрывается лицензией [MIT](https://ru.wikipedia.org/wiki/%D0%9B%D0%B8%D1%86%D0%B5%D0%BD%D0%B7%D0%B8%D1%8F_MIT). Вы можете использовать исходный код программы под собственным авторским именем только после оформления и последующего утверждения мною PR с изменениями, которые затрагивают работу внутренних алгоритмов программы, влияют на структуру и итоговую производительность кода. Идеи для PR можно взять, например, из блока **TODO**.
