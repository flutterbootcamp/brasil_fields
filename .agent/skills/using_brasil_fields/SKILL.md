---
name: using_brasil_fields
description: How to use the brasil_fields package to format, validate, and manipulate Brazilian data (CPF, CNPJ, CEP, Phone, Currency, Dates) in Flutter applications.
---

# Using the `brasil_fields` Package

The `brasil_fields` package is the standard way to handle Brazilian formats in Flutter applications. When a user asks you to implement a form, validate data, or display Brazilian-specific information (like currency, documents, or phone numbers), you should use this package.

## 1. Input Formatters (`TextFormField`)

To format user input in real-time, pass the appropriate formatter to the `inputFormatters` list of a `TextFormField` or `TextField`.

**CRITICAL RULE:** For numeric formatters, you **MUST** also include `FilteringTextInputFormatter.digitsOnly` to prevent crashes and ensure only numbers are processed.

### Example: Numeric Formatters (CPF, CEP, Phone, Currency)

```dart
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

TextFormField(
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly, // REQUIRED for numeric formatters
    CpfInputFormatter(), // Or CepInputFormatter(), TelefoneInputFormatter(), RealInputFormatter()
  ],
);
```

### Example: Alphanumeric Formatters (Exceptions)

The `CnpjAlfanumericoInputFormatter` (for the new 2026 CNPJ format) and `PlacaVeiculoInputFormatter` (Vehicle License Plates) are alphanumeric.
**DO NOT use `FilteringTextInputFormatter.digitsOnly` with these.**

```dart
import 'package:brasil_fields/brasil_fields.dart';

TextFormField(
  inputFormatters: [
    // NO FilteringTextInputFormatter.digitsOnly HERE
    PlacaVeiculoInputFormatter(),
  ],
);
```

## 2. Data Operations & Validation (`UtilBrasilFields`)

The `UtilBrasilFields` class provides static methods to generate, format, and validate Brazilian data programmatically.

### Validating Data
Use these methods before submitting forms or saving data:
- `UtilBrasilFields.isCPFValido(String cpf)`: Returns `bool`.
- `UtilBrasilFields.isCNPJValido(String cnpj)`: Returns `bool`.

### Formatting Raw Strings
If you receive raw data from an API and need to display it formatted:
```dart
String formattedCpf = UtilBrasilFields.obterCpf('11122233344'); // Output: 111.222.333-44
String formattedCep = UtilBrasilFields.obterCep('11222333');     // Output: 11.222-333
String formattedMoney = UtilBrasilFields.obterReal(50000.50);    // Output: R$ 50.000,50
```

### Generating Mock Data
Useful for writing tests or Populating mock UIs:
```dart
String randomCpf = UtilBrasilFields.gerarCPF(); // Output: XXX.XXX.XXX-XX
```

## 3. Date Formatting (`UtilData`)

The `UtilData` class is used to format `DateTime` objects into standard Brazilian string formats.

```dart
import 'package:brasil_fields/brasil_fields.dart';

DateTime today = DateTime.now();

// Standard Brazilian format: DD/MM/AAAA
String formattedDate = UtilData.obterDataDDMMAAAA(today); 

// Time format: hh:mm
String formattedTime = UtilData.obterHoraHHMM(today);
```

## 4. Models (States, Regions, Months)

The package includes static lists and maps for dropdowns or selections.
- `Estados.listaEstados`: List of Brazilian states.
- `Meses.listaMeses`: List of months in Portuguese.
- `Regioes.listaRegioes`: List of Brazilian regions.
