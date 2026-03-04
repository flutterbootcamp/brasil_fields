---
name: contributing_brasil_fields
description: How to maintain, fix bugs, or add new features (e.g. formatters, validators) to the open-source `brasil_fields` package repository.
---

# Contributing to the `brasil_fields` Package

The `brasil_fields` repository is structured to provide Brazilian standard data formats, validators, and generators to the Flutter ecosystem. When you are asked to maintain this package, fix a bug, or add a new format, you should follow these guidelines.

## 1. Repository Structure

Understand where code lives before making modifications:

- **Formatters (`lib/src/formatters/`):** All classes that extend `TextInputFormatter` (to modify user input in real-time) belong here.
- **Validators (`lib/src/validators/`):** Classes that validate data (e.g., verifying CPF checksums). Note: This differs from the static methods in `UtilBrasilFields`.
- **Models (`lib/src/modelos/`):** Static data collections (lists and maps) like States (`Estados`), Months (`Meses`), and Regions (`Regioes`).
- **Utilities (`lib/src/util/`):** Static utility classes like `UtilBrasilFields` (for generating/formatting strings programmatically) and `UtilData` (for dates).
- **Public Export (`lib/brasil_fields.dart`):** This is the entry point of the package. Any new formatter, validator, model, or utility created in `src/` must be exported here.

## 2. Adding a New Formatter

If requested to add a new document or currency formatter:

1. **Create the file:** Add it to `lib/src/formatters/` (e.g. `meu_novo_formatter.dart`).
2. **Implement InputFormatter:** Your class must `extend TextInputFormatter` and override `formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue)`.
3. **Handle Edge Cases:** Consider edge cases like rapid typing, text deletion (`oldValue.text.length > newValue.text.length`), and pasting long strings. 
4. **Alphanumeric vs Numeric:** Is the new format strictly numbers? If so, document that users should apply `FilteringTextInputFormatter.digitsOnly` along with it. If it accepts letters, it is alphanumeric and requires special handling.
5. **Export the class:** Add `export 'src/formatters/meu_novo_formatter.dart';` inside `lib/brasil_fields.dart`.

## 3. Writing and Maintaining Tests

The `brasil_fields` package maintains high test coverage (enforced by Codecov). You must write tests for any new code or bug fixes.

- **Test Structure:** Placed in the `test/` directory, mimicking the structure of `lib/` (e.g. `test/src/formatters/meu_novo_formatter_test.dart`).
- **Formatter Tests:** You must test the `formatEditUpdate` method. Verify both the `newValue.text` string and the `newValue.selection.baseOffset` (cursor position).

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:brasil_fields/brasil_fields.dart';

void main() {
  test('MeuNovoFormatter deve formatar corretamente', () {
    final formatter = MeuNovoFormatter();
    const oldValue = TextEditingValue(text: '');
    const newValue = TextEditingValue(
        text: '12', selection: TextSelection.collapsed(offset: 2));

    final result = formatter.formatEditUpdate(oldValue, newValue);

    expect(result.text, '1.2'); // Ensure custom format logic is applied
    expect(result.selection.baseOffset, 3); // Ensure cursor moved
  });
}
```

## 4. Code Quality Standards

1. You **MUST** ensure all code changes align with the project's `analysis_options.yaml`.
2. Do not introduce warnings. Use the `flutter_lints` rules correctly.
3. Every public class, method, and variable should ideally have documentation comments (`///`) explaining its purpose and return value, specifically if updating `UtilBrasilFields` or adding a new formatter.
4. Keep the code clean and focused; a formatter does formatting, a validator does validation. Separate concerns.
