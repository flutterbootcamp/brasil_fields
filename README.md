# brasil_fields

![Brasil Fields](./brasil-fields.svg)

O jeito mais fácil de utilizar padrões e formatos brasileiros em seu projeto Dart.

[**Testar agora**](https://flutterbootcamp.github.io/brasil_fields/#/)

[![codecov](https://codecov.io/github/flutterbootcamp/brasil_fields/branch/master/graph/badge.svg?token=5NZXJGPM3K)](https://codecov.io/github/flutterbootcamp/brasil_fields)

## Apresentação

Este package facilita o desenvolvimento de projetos que utilizam campos com os padrões e formatos brasileiros.

### Formatters

- Altura (2,22)
- Cartão bancário (0000 1111 2222 3333 4444)
- Centavos (R\$) (7,19) (até 3 casas decimais: 7,191)
- CEP (99.999-999)
- CPF (999.999.99-99)
- CNPJ (99.999.999/9999-99)
- Cpf ou Cnpj (se adapta conforme os números são inseridos)
- CNS (111 2222 3333 4444)
- CEST (12.345.67)
- Data (01/01/1900)
- Hora (23:59)
- IOF (1,234567)
- KM (999.999)
- NCM (1234.56.78)
- Peso (111,1)
- Placa de veículo (AAA-1234)
- Real (R\$) (20.550)
- Telefone ( (99) 9999-9999)
- Validade de cartão bancário (12/24 ou 12/2024)
- Temperatura (27,1)

### Padrões

- Estados
- Meses
- Regiões
- Semana

### Como utilizar

Basta incluir o formatter que você quer que o campo tenha, na lista de `inputFormatters` :

**Para garantir que o campo aceite apenas valores numéricos, utilize em conjunto com o formatter `FilteringTextInputFormatter.digitsOnly`.**

```dart
TextFormField(
  inputFormatters: [
    // obrigatório
    FilteringTextInputFormatter.digitsOnly,
    CepInputFormatter(),
  ],
);
```

- `AlturaInputFormatter()`
- `CartaoBancarioInputFormatter()`
- `CentavosInputFormatter()`
- `CepInputFormatter()`
- `CpfInputFormatter()`
- `CnpjInputFormatter()`
- `CpfOuCnpjFormatter()`
- `CESTInputFormatter()`
- `CNSInputFormatter()`
- `DataInputFormatter()`
- `HoraInputFormatter()`
- `IOFInputFormatter()`
- `KmInputFormatter()`
- `NCMInputFormatter()`
- `PesoInputFormatter()`
- `PlacaVeiculoInputFormatter()` (**atenção**: nao utilizar `FilteringTextInputFormatter.digitsOnly`)
- `RealInputFormatter()`
- `TelefoneInputFormatter()`
- `ValidadeCartaoInputFormatter()`

Caso precise de um DropdownButton com algumas das classes de padrões:

```dart
DropdownButton<String>(
  hint: Text('Região'),
  onChanged: (regiaoSelecionada) {
    print(regiaoSelecionada);
  },
  items: Regioes.listaRegioes.map((String regiao) {
    return DropdownMenuItem(
      value: regiao,
      child: Text(regiao),
    );
  }).toList(),
)
```

### Métodos úteis

A classe `UtilData` possui métodos que facilitam obter o valor de um objeto `DateTime` em formato `String` (e no padrão brasileiro).

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

A classe `UtilBrasilFields` possui métodos que facilitam obter os valores CEP, KM, CPF e CPNJ já formatados:

- `UtilBrasilFields.obterCpf('11122233344')` (111.222.333-44)
- `UtilBrasilFields.obterCnpj('11222333444455')` (11.222.333/4444-55)
- `UtilBrasilFields.obterCep('11222333')` (11.222-333)
- `UtilBrasilFields.obterCep('11222333', ponto: false)` (11222-333)
- `UtilBrasilFields.obterTelefone('00999998877')` ((00) 99999-8877)
- `UtilBrasilFields.obterTelefone('(00) 99999-8877', mascara: false)` (00999998877)
- `UtilBrasilFields.obterTelefone('999998877', ddd: false)` (99999-8877)
- `UtilBrasilFields.obterTelefone('99999-8877', ddd: false, mascara: false)` (999998877)
- `UtilBrasilFields.obterDDD('00999998877')` (00)
- `UtilBrasilFields.obterReal(85437107.04)` (R$ 85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false)` (85.437.107,04)
- `UtilBrasilFields.obterReal(85437107.04, moeda: false, decimal: 0)` (85.437.107)
- `UtilBrasilFields.removeCaracteres` (remove caracteres especiais)
- `UtilBrasilFields.removerSimboloMoeda` (remove o R$)
- `UtilBrasilFields.converterMoedaParaDouble` (remove o R$ e retorna um double)
- `UtilBrasilFields.obterReal` (R$ 50.000,00 ou 50.000,00)
- `UtilBrasilFields.obterKM(999999)` (999.999)

A classe `UtilBrasilFields` possui métodos para validar CPF e CNPJ: `isCPFValido` e `isCNPJValido`.

Para inicializar um `TextEditingController` com o texto já formatado, basta escolher o método com o formato desejado e setar no atributo `text`:

```dart
  final dataController = TextEditingController(text: UtilData.obterDataDDMMAAAA(DateTime(2020, 12, 31)));
  final cnpjController = TextEditingController(text: UtilBrasilFields.obterCnpj('11222333444455'));
```

---

<a href="https://github.com/flutterbootcamp/brasil_fields/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutterbootcamp/brasil_fields" />
</a>

Made with [contrib.rocks](https://contrib.rocks).