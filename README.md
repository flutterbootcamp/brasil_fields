# brasil_fields

![Brasil Fields](./brasil-fields.svg)

O jeito mais fácil de utilizar padrões e formatos brasileiros em seu projeto.

[**Testar agora**](https://flutterbootcamp.github.io/brasil_fields/#/)

[![codecov](https://codecov.io/github/flutterbootcamp/brasil_fields/branch/master/graph/badge.svg?token=5NZXJGPM3K)](https://codecov.io/github/flutterbootcamp/brasil_fields)

## Apresentação

O pacote oferece formatadores de campos, validadores e utilitários para dados brasileiros.

### Como utilizar

Adicione o formatador a `inputFormatters`. Para campos numéricos, filtre a entrada antes de aplicar a máscara:

```dart
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final cepField = TextFormField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    CepInputFormatter(),
  ],
);
```

#### Campos alfanuméricos

`CnpjAlfanumericoInputFormatter`, `CpfOuCnpjAlfanumericoFormatter` e `PlacaVeiculoInputFormatter` aceitam letras. Use um filtro alfanumérico no lugar de `digitsOnly` quando quiser restringir a entrada a letras e números:

```dart
final cnpjField = TextFormField(
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
    CnpjAlfanumericoInputFormatter(),
  ],
);
```

### Formatadores

| Padrão           | Formatador                      | Formato                                      |
|:-----------------|:--------------------------------|:---------------------------------------------|
| Altura           | AlturaInputFormatter()          | 2,22                                         |
| Cartão           | CartaoBancarioInputFormatter()  | 1111 2222 3333 4444                          |
| Centavos         | CentavosInputFormatter()        | 71,94                                        |
| CEP              | CepInputFormatter()             | 99.999-999                                   |
| CPF              | CpfInputFormatter()             | 999.999.999-99                               |
| CNPJ             | CnpjInputFormatter()            | 99.999.999/9999-99                           |
| CNPJ alfanumérico | CnpjAlfanumericoInputFormatter() | 99.999.999/9999-99 ou A1.B2C.3D4/E5F6-99 |
| CPF ou CNPJ      | CpfOuCnpjFormatter()            | Máscara numérica conforme o tamanho          |
| CPF ou CNPJ alfanumérico | CpfOuCnpjAlfanumericoFormatter() | Máscara conforme o tamanho         |
| CEST             | CESTInputFormatter()            | 12.345.67                                    |
| CNS              | CNSInputFormatter()             | 111 2222 3333 4444                           |
| Data             | DataInputFormatter()            | 01/01/1900                                   |
| Hora             | HoraInputFormatter()            | 23:59                                        |
| IOF              | IOFInputFormatter()             | 1,234567                                     |
| KM               | KmInputFormatter()              | 999.999                                      |
| Cert. nascimento | CertNascimentoInputFormatter()  | 000000 11 22 3333 4 55555 666 7777777 88     |
| NCM              | NCMInputFormatter()             | 1234.56.78                                   |
| NUP              | NUPInputFormatter()             | 1234567-89.0123.4.56.7890                    |
| Peso             | PesoInputFormatter()            | 111,1                                        |
| PIS/PASEP (NIS/NIT) | PisPasepInputFormatter()     | 120.12345.67-2                               |
| Placa            | PlacaVeiculoInputFormatter()    | AAA-1234                                     |
| Real             | RealInputFormatter()            | 20.550                                       |
| Telefone         | TelefoneInputFormatter()        | (99) 9999-9999                               |
| Validade cartão  | ValidadeCartaoInputFormatter()  | 12/24 ou 12/2024                             |
| Temperatura      | TemperaturaInputFormatter()     | 27,1                                         |

Os formatadores aplicam máscaras; não validam os documentos. Para verificar CPF, CNPJ, NUP ou PIS/PASEP, use os validadores em `UtilBrasilFields`.

### Modelos

Listas e mapas de estados, meses, regiões e dias da semana:

```text
Estados.listaEstados
Estados.listaEstadosSigla
Meses.listaMeses
Meses.mapaMeses
Regioes.listaRegioes
Semana.listaDiasUteis
Semana.mapaDiasUteis
Semana.listaDiasUteisAbvr
Semana.mapaDiasUteisAbvr
Semana.listaDiasSemana
Semana.listaDiasSemanaAbvr
Semana.listaDiasSemanaOrdenada
Semana.mapaDiasSemanaOrdenada
Semana.mapaDiasSemanaOrdenadaAbvr
```

### UtilData

Formata objetos `DateTime` e interpreta strings de data e hora no padrão brasileiro:

- `UtilData.obterDataDDMMAAAA` (DD/MM/AAAA)
- `UtilData.obterDataMMAAAA` (MM/AAAA)
- `UtilData.obterDataDDMM` (DD/MM)
- `UtilData.obterHoraHHMMSS` (HH:mm:ss)
- `UtilData.obterHoraHHMM` (HH:mm)
- `UtilData.obterMes` e `UtilData.obterDia` extraem mês e dia de `DDMMAAAA` ou `DD/MM/AAAA`.
- `UtilData.obterDateTime` interpreta `DD/MM/AAAA`.
- `UtilData.obterDateTimeHora` interpreta `DD/MM/AAAA HH:mm`.
- `UtilData.obterDateTimeHoraMinuto` interpreta `HH:mm`.

`UtilData.validarData` verifica se a entrada contém oito dígitos; não verifica se a data existe no calendário. `UtilData.removeCaracteres` mantém apenas os dígitos de uma string.

### UtilBrasilFields

Gera, formata e valida identificadores e valores brasileiros:

- `UtilBrasilFields.gerarCPF()` (XXXXXXXXXXX)
- `UtilBrasilFields.gerarCPF(useFormat: true)` (XXX.XXX.XXX-XX)
- `UtilBrasilFields.gerarCNPJ()` (XXXXXXXXXXXXXX)
- `UtilBrasilFields.gerarCNPJ(useFormat: true)` (XX.XXX.XXX/XXXX-XX)
- `UtilBrasilFields.gerarCNPJ(isAlphanumeric: true, useFormat: true)` (CNPJ alfanumérico formatado)
- `UtilBrasilFields.gerarPisPasep()` (XXXXXXXXXXX)
- `UtilBrasilFields.gerarPisPasep(useFormat: true)` (XXX.XXXXX.XX-X)
- `UtilBrasilFields.obterCpf('48620265083')` (486.202.650-83)
- `UtilBrasilFields.obterCnpj('77343168000124')` (77.343.168/0001-24)
- `UtilBrasilFields.obterCnpj('E2X05ZR982XN04')` (E2.X05.ZR9/82XN-04)
- `UtilBrasilFields.obterCnpjInscricao`, `obterCnpjOrdem` e `obterCnpjDiv` extraem as partes de um CNPJ válido.
- `UtilBrasilFields.obterCep('11222333')` (11.222-333)
- `UtilBrasilFields.obterCep('11222333', ponto: false)` (11222-333)
- `UtilBrasilFields.obterNUP('06010642120226000000')` (0601064-21.2022.6.00.0000)
- `UtilBrasilFields.obterPisPasep('12012345672')` (120.12345.67-2)
- `UtilBrasilFields.obterTelefone('00999998877')` ((00) 99999-8877)
- `UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false)` (00999998877)
- `UtilBrasilFields.obterTelefone('999998877', ddd: false)` (99999-8877)
- `UtilBrasilFields.obterTelefone('99999-8877', ddd: false, mascara: false)` (999998877)
- `UtilBrasilFields.obterReal(85437107.04)` (R$ 85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false)` (85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false, decimal: 0)` (85.437.107)
- `UtilBrasilFields.obterDDD('(00) 99999-8877')` (00)
- `UtilBrasilFields.obterKM(999999)` (999.999)
- `UtilBrasilFields.removeCaracteres` mantém apenas letras ASCII e dígitos.
- `UtilBrasilFields.removerSimboloMoeda` remove `R$` e o espaço seguinte, se houver.
- `UtilBrasilFields.converterMoedaParaDouble` converte um valor monetário brasileiro em `double`; retorna `0` se a entrada não vazia não puder ser convertida.
- `UtilBrasilFields.isCPFValido`, `isCNPJValido`, `isNUPValido` e `isPisPasepValido` retornam `bool`. Para CNPJ alfanumérico, passe `isAlphanumeric: true` a `isCNPJValido`.

Os métodos `obterCpf`, `obterCnpj`, `obterNUP` e `obterPisPasep` exigem identificadores válidos e lançam `ArgumentError` para valores inválidos.

### TextEditingController

Inicialize `text` com o valor formatado:

```dart
final dataController = TextEditingController(
  text: UtilData.obterDataDDMMAAAA(DateTime(2024, 12, 31)),
);
final cnpjController = TextEditingController(
  text: UtilBrasilFields.obterCnpj('77343168000124'),
);
```

---

<a href="https://github.com/flutterbootcamp/brasil_fields/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterbootcamp/brasil_fields" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
