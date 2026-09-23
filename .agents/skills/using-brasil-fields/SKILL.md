---
name: using-brasil-fields
description: Use brasil_fields in a Flutter app when the user requests this package or it is already a dependency. Covers input formatting, validation, and display helpers; do not select the package for unrelated forms.
---

# Using brasil_fields

Check the installed package version and available API in the target app. Import `package:brasil_fields/brasil_fields.dart` for the public API.

## Input fields

Put a filter before a numeric formatter so it receives only digits:

```dart
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final cpfField = TextFormField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    CpfInputFormatter(),
  ],
);
```

Common numeric formatters include `CpfInputFormatter`, `CnpjInputFormatter`, `CepInputFormatter`, `TelefoneInputFormatter`, and the money formatters. `CnpjAlfanumericoInputFormatter` and `PlacaVeiculoInputFormatter` accept letters: do not pair them with `digitsOnly`. Use `FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'))` before an alphanumeric formatter when the field should accept only letters and digits.

Input formatters apply masks; use validators to check identifiers. For example, `UtilBrasilFields.isCPFValido(cpf)` returns a `bool`. Numeric CNPJ validation is the default; pass `isAlphanumeric: true` to `isCNPJValido` for alphanumeric CNPJ.

## Display and generated values

```dart
final cpf = UtilBrasilFields.obterCpf('48620265083'); // 486.202.650-83
final valor = UtilBrasilFields.obterReal(50000.5); // R$ 50.000,50
final cpfSemMascara = UtilBrasilFields.gerarCPF(); // 11 digits
final cpfComMascara = UtilBrasilFields.gerarCPF(useFormat: true);
```

`obterCpf` checks the CPF and throws `ArgumentError` if it is invalid. Other `obter*` methods can also reject invalid input; inspect the method contract before formatting untrusted data. For dates, `UtilData` formats and parses Brazilian date strings. Its `validarData` checks for eight digits after removing non-digits; it does not check whether the calendar date exists. `Estados.listaEstados` includes the Distrito Federal.
