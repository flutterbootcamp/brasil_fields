# brasil_fields

![Brasil Fields](./brasil-fields.svg)

O jeito mais fácil de utilizar padrões e formatos brasileiros em seu projeto.

[**Testar agora**](https://flutterbootcamp.github.io/brasil_fields/#/)

[![codecov](https://codecov.io/github/flutterbootcamp/brasil_fields/branch/master/graph/badge.svg?token=5NZXJGPM3K)](https://codecov.io/github/flutterbootcamp/brasil_fields)

## Apresentação

Este package facilita o desenvolvimento de projetos que utilizam campos com os padrões e formatos brasileiros.

### Como utilizar

Incluir o formatter no parâmetro `inputFormatters`. 

>É necessário adicionar o `FilteringTextInputFormatter.digitsOnly` para garantir que o campo aceite apenas valores numéricos.

```dart
TextFormField(
  inputFormatters: [
    // obrigatório
    FilteringTextInputFormatter.digitsOnly,
    CepInputFormatter(),
  ],
);
```

#### EXCEÇÃO: CNPJ 2026 E Placa de veículos

`CnpjAlfanumericoInputFormatter` e `PlacaVeiculoInputFormatter` são formatters alfanuméricos, sendo assim, o `FilteringTextInputFormatter.digitsOnly` não deve ser informado.

### Formatters

| Padrão           | Formatter                       | Formato                                      |
|:-----------------|:--------------------------------|:---------------------------------------------|
| Altura           | AlturaInputFormatter()          | 2,22                                         |
| Cartão           | CartaoBancarioInputFormatter()  | 0000 1111 2222 3333 4444                     |
| Centavos         | CentavosInputFormatter()        | 7,194                                        |
| CEP              | CepInputFormatter()             | 99.999-999                                   |
| CPF              | CpfInputFormatter()             | 999.999.99-99                                |
| CNPJ             | CnpjInputFormatter()            | 99.999.999/9999-99                           |
| CNPJ (2026)      | CnpjAlfanumericoInputFormatter()| 99.999.999/9999-99 ou A1.B2C.3D4/E5F6-99 (*) |
| CPF /  CNPJ      | CpfOuCnpjFormatter()            | Se adapta conforme os números são inseridos  |
| CEST             | CESTInputFormatter()            | 12.345.67                                    |
| CNS              | CNSInputFormatter()             | 111 2222 3333 4444                           |
| Data             | DataInputFormatter()            | 01/01/1900                                   |
| Hora             | HoraInputFormatter()            | 23:59                                        |
| IOF              | HoraInputFormatter()            | 1,234567                                     |
| KM               | KmInputFormatter()              | 999.999                                      |
| Cert. nascimento | CertNascimentoInputFormatter()  | 000000 11 22 3333 4 55555 666 7777777 88     |
| NCM              | NCMInputFormatter()             | 1234.56.78                                   |
| NUP              | NUPInputFormatter()             | 1234567-89.0123.4.56.7890                    |
| Peso             | PesoInputFormatter()            | 111,1                                        |
| Placa            | PlacaVeiculoInputFormatter()    | AAA-1234 (*)                                 |
| Real             | RealInputFormatter()            | 20.550                                       |
| Telefone         | TelefoneInputFormatter()        | (99) 9999-9999                               |
| Validade cartão  | ValidadeCartaoInputFormatter()  | 12/24 ou 12/2024                             |
| Temperatura      | TemperaturaInputFormatter()     | 27,1                                         |

**(*)** Não utilizar `FilteringTextInputFormatter.digitsOnly`. Estes formatters são alfanuméricos.

### Modelos

```dart
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
Semana.listaDiasSemanaOrdenada
```

### UtilData

Métodos que facilitam obter o valor de um objeto `DateTime` em formato `String` (e no padrão brasileiro).

- `UtilData.obterDataDDMMAAAA` (DD/MM/AAAA)
- `UtilData.obterDataMMAAAA` (MM/AAAA)
- `UtilData.obterDataDDMM` (DD/MM)
- `UtilData.obterHoraHHMMSS` (hh:mm:ss)
- `UtilData.obterHoraHHMM` (hh:mm)
- `UtilData.obterMes`
- `UtilData.obterDia`
- `UtilData.obterDateTime`
- `UtilData.obterDateTimeHora`
- `UtilData.obterDateTimeHoraMinuto`

### UtilBrasilFields

Métodos que facilitam manipular valores:

- `UtilBrasilFields.gerarCPF()` (XXX.XXX.XXX-XX)
- `UtilBrasilFields.gerarCPF(false)` (XXXXXXXXXXX)
- `UtilBrasilFields.gerarCNPJ()` (XX.YYY.ZZZ/NNNN-SS)
- `UtilBrasilFields.gerarCNPJ(false)` (XXYYYZZZNNNNSS)
- `UtilBrasilFields.obterCpf('11122233344')` (111.222.333-44)
- `UtilBrasilFields.obterCnpj('11222333444455')` (11.222.333/4444-55)
- `UtilBrasilFields.obterCep('11222333')` (11.222-333)
- `UtilBrasilFields.obterCep('11222333', ponto: false)` (11222-333)
- `UtilBrasilFields.obterNUP('06010642120226000000')` (0601064-21.2022.6.00.0000)
- `UtilBrasilFields.obterTelefone('00999998877')` ((00) 99999-8877)
- `UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false)` (00999998877)
- `UtilBrasilFields.obterTelefone('999998877', ddd: false)` (99999-8877)
- `UtilBrasilFields.obterTelefone('99999-8877', ddd: false, mascara: false)` (999998877)
- `UtilBrasilFields.obterReal` (R$ 50.000,00 ou 50.000,00)
- `UtilBrasilFields.obterReal(85437107.04)` (R$ 85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false)` (85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false, decimal: 0)` (85.437.107)
- `UtilBrasilFields.obterDDD('00999998877')` (00)
- `UtilBrasilFields.obterKM(999999)` (999.999)
- `UtilBrasilFields.removeCaracteres` (remove caracteres especiais)
- `UtilBrasilFields.removerSimboloMoeda` (remove o R$)
- `UtilBrasilFields.converterMoedaParaDouble` (remove o R$ e retorna um double)
- `UtilBrasilFields.isCPFValido` (retorna `true` se o CPF for válido, caso contrário, retorna `false`)
- `UtilBrasilFields.isCNPJValido` (retorna `true` se o CNPJ for válido, caso contrário, retorna `false`)
- `UtilBrasilFields.isNUPValido` (retorna `true` se o NUP for válido, caso contrário, retorna `false`)

Para inicializar um `TextEditingController` com o texto já formatado, basta escolher o método com o formato desejado e setar no atributo `text`:


### TextEditingController
```dart
final dataController = TextEditingController(
  text: UtilData.obterDataDDMMAAAA(DateTime(2024, 12, 31)),
);
final cnpjController = TextEditingController(
  text: UtilBrasilFields.obterCnpj('11222333444455'),
);
```

---

<a href="https://github.com/flutterbootcamp/brasil_fields/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterbootcamp/brasil_fields" />
</a>

Made with [contrib.rocks](https://contrib.rocks).