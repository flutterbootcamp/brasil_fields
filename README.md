# brasil_fields

O jeito mais fácil de utilizar padrões e formatos brasileiros em seu projeto.

## Apresentação

Este package facilita o desenvolvimento com a linguagem Dart em projetos que
utilizam campos com os padrões e formatos brasileiros.

### Instalação

```
dependencies:
  brasil_fields: ^0.0.5
```

### Formatters

- CPF (999.999.99-99)

![CPF Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/cpf.gif "CPF Formatter")

- CNPJ (99.999.999/9999-99)

![CNPJ Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/cnpj.gif "CNPJ Formatter")

- CEP (99.999-999)

![CEP Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/cep.gif "CEP Formatter")

- Real (R\$) (20.550)

![Real Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/real.gif "Real Formatter")

- Centavos (R\$) (20,90)

![Centavos Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/centavos.gif "Centavos Formatter")

- Telefone ( (99) 9999-9999)

![Telefone Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/telefone.gif "Telefone Formatter")

- Data (01/01/1900)

![Data Formatter](https://github.com/rubensdemelo/brasil_fields/blob/master/img/data.gif "Data Formatter")

### Padrões

- Estados
- Meses
- Regiões
- Semana

### Como utilizar:

Basta incluir o formatter que você quer que o campo tenha, na lista de `inputFormatters` :

**Para garantir que o campo aceite apenas valores numéricos, utilize em conjunto com o formatter `WhitelistingTextInputFormatter.digitsOnly` .**

```
TextFormField(
  inputFormatters: [
    WhitelistingTextInputFormatter.digitsOnly,
    CepInputFormatter(),
  ],
);

```

- `CpfInputFormatter()`
- `CnpjInputFormatter()`
- `CepInputFormatter()`
- `RealInputFormatter()`
- `TelefoneInputFormatter()`
- `DataInputFormatter()`
