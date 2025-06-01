## 1.18.0
- Novo formatter: `CnpjAlfanumericoInputFormatter()`, por [victorers1](https://github.com/victorers1).

## 1.17.0
- Novo formatter: `NUPInputFormatter()`, por [lucas-lucamenor](https://github.com/lucamenor).

## 1.16.0
- Atualiza `intl` e `flutter_lints`.

## 1.15.0
- Novo formatter: `CertNascimentoInputFormatter()`, por [lucas-marianno](https://github.com/lucas-marianno).

## 1.14.3
- Melhorias README

## 1.14.2
- intl: `^0.19.0`

## 1.14.1
- Atualiza README com `gerarCPF` e `gerarCNPJ`, por [adilsonjuniordev](https://github.com/adilsonjuniordev).

## 1.14.0
- Novo formatter: `CNSInputFormatter()`

## 1.13.1
- intl: 0.18.0.

## 1.13.0
- sdk: ">=3.0.0" e intl: 0.18.1.

## 1.12.0
- Novos formatters: `CESTInputFormatter()` e `NCMInputFormatter()`, por [juliogyn](https://github.com/juliogyn).

## 1.11.0
- Novo formatter: `IOFInputFormatter()`.

## 1.10.0
- Atualiza `intl`.

## 1.9.1
- Ajustes nos comentários. Remoção de variáveis alocadas desnecessáriamente.

## 1.9.0
- Novos métodos em `UtilData`: obterDateTimeHora e obterDateTimeHoraMinuto.
- Ajustes no worflow.yml

## 1.8.1
- Atualiza README e `pubspec.yaml`.

## 1.8.0
- Cria extension `BrasiLFields` para int e double. Por [jradelmo](https://github.com/jradelmo), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/69).

## 1.7.0
- Adiciona `obterKM` em  `UtilBrasilFields`

## 1.6.0
- Adiciona `TemperaturaInputFormatter`
- Por [ClodoaldoRibeiro](https://github.com/ClodoaldoRibeiro), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/75).

## 1.5.0
- Adiciona `obterDateTime`

## 1.4.5
- Correções ortográticas e atualização README
- Por [jfelipe72](https://github.com/jfelipe72), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/67).

## 1.4.4
- Correção de bug em `CentavosInputFormatter`
- Correção de bug em `CentavosInputFormatter` quando valor negativo. Corrige [issue #65](https://github.com/flutterbootcamp/brasil_fields/issues/65). 
 
## 1.4.3
- Correção de bug em `obterReal`
- Correção de bug em `obterReal` quando valor negativo, por [jfelipe72](https://github.com/jfelipe72), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/64).
 
## 1.4.2
- Correção de bug em `ValidadeCartaoInputFormatter`
- Correção de bug em `ValidadeCartaoInputFormatter` por [jfelipe72](https://github.com/jfelipe72), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/63).
 
## 1.4.1
- Documentação e testes de `obterReal` em  `UtilBrasilFields`
- Documentação e testes de `obterReal` por [gabrielpagotto](https://github.com/gabrielpagotto), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/61).

## 1.4.0
- Adiciciona `obterReal` em  `UtilBrasilFields`
- Funcionalidade adicionada por [gabrielpagotto](https://github.com/gabrielpagotto), via este [PR](https://github.com/flutterbootcamp/brasil_fields/pull/60).
 
## 1.3.1
- Corrige `CentavosInputFormatter()`
- Corrige [input/delete com o numero 9](https://github.com/rubensdemelo/brasil_fields/issues/57)

## 1.3.0
- Novo formatter: `CentavosInputFormatter()`
- Removido `centavos` de `RealInputFormatter`. Utilizar este novo formatter.

## 1.2.0
- Novo formatter: `PlacaVeiculoInputFormatter()`. Inclui [`flutter_lints`](https://pub.dev/packages/flutter_lints).

## 1.1.4
- Expõe `validators.dart`
- Pode-se utilizar a validação de CPF e CNPJ diretamente, utilizando as classes: `CPFValidator` e `CNPJValidator`.

## 1.1.4
- Corrige exemplo `DropdownButton`

## 1.1.2
- Correção em obter Cpf e Cnpj
- Na classe `UtilBrasilFields`, os métodos `obterCpf` e `obterCnpj` foram corrigidos para retornar os valores formatados ( <https://github.com/rubensdemelo/brasil_fields/issues/41> ).
  
## 1.1.1
- Corrige versão README

## 1.1.0
- Validação de CPF e CNPJ
- Na classe `UtilBrasilFields`: `isCPFValido` e `isCNPJValido`. Obrigado [fogaiht](https://github.com/fogaiht).

## 1.0.0
- Publicação final para null safety
- Novos métodos na classe `UtilBrasilFields`: `removerSimboloMoeda` e `converterMoedaParaDouble`.
- Novos métodos na classe `UtilData`: `obterMes` e `obterDia`.

## 1.0.0-nullsafety.0
- Migração para nullsafety

## 0.6.1
- Novo método em UtilBrasilFields
- Correção do método `obterTelefone()` na classe `UtilBrasilFields`;

## 0.6.0
- Novo método em UtilBrasilFields
- Criação do método `obterTelefone()` na classe `UtilBrasilFields`;
- Parâmetro `ponto` em `UtilBrasilFields.obterCep()`.

## 0.5.1
- Nova documentação

## 0.5.0
- Novo aplicativo de exemplo
- Inclui `KmInputFormatter`()`;
- Criação dos métodos`obterCpf()`,`obterCnpj()` e `obterCep()` na classe `UtilBrasilFields`;
- Parâmetro`ponto` no `CepInputFormatter()`.

## 0.4.0
- Inclui package intl
- Novos métodos para obter as datas em formato `String` à partir de um objeto `DateTime`:
  - `UtilData.obterDataDDMMAAAA`
  - `UtilData.obterDataMMAAAA`
  - `UtilData.obterDataDDMM`
  - `UtilData.obterHoraHHMMSS`
  - `UtilData.obterHoraHHMM`

## 0.3.2
- Corrige TextSelection.collapsed

## 0.3.1
- Ajustes para versão 1.20
- Troca `WhitelistingTextInputFormatter.digitsOnly` por `FilteringTextInputFormatter.digitsOnly`

## 0.3.0
- Novos formatters
- CpfOuCnpjFormatter

## 0.2.0
- Novos formatters
- PesoInputFormatter
- AlturaInputFormatter

## 0.1.0
- Adiciona análise estática
- Adiciona análise estática com o package `pedantic`.
- Renomeia CartaoCreditoInputFormatter para CartaoBancarioInputFormatter.

## 0.0.9
- Novos formatters
- CartaoCreditoInputFormatter
- ValidadeCartaoInputFormatter

## 0.0.8+1
- Corrige caminho screenshots

## 0.0.8
- Adiciona HoraInputFormatter

## 0.0.7+2
- Corrige formato data UTC

## 0.0.7+1
- Corrige export data_util

## 0.0.7
- Nova documentação da API

## 0.0.6
- Inclui classe UtilData

## 0.0.5
- Atualiza README
- Melhora descrição e exemplos do arquivo.

## 0.0.4
- Melhora documentação no projeto de exemplo

## 0.0.3
- Inclusão de modelos para:
 - Estados;
 - Meses;
 - Regioes;
 - Dias da Semana;

## 0.0.2
- Inclusão DataFormatter
- Novo formatter para campos do tipo data (01/01/1900) .

## 0.0.1
- Versão inicial
- Formatters para: CEP, CNPJ, CPF, real (moeda), telefone fixo e celular.
- Modelos com listas e mapas: estados, meses, regioes, semana (dias úteis e nã úteis).
