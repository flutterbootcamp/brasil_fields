# Package correctness review — 2026-09-21

## Scope and handoff status

- Package: `brasil_fields` 1.18.0.
- Baseline: `4ff33c03978d10208b942f6d114fe29a0a6cf216`.
- Scope: existing implementation, exported APIs, README usage, and tests; this was a whole-package review, not a review of a proposed diff.
- The checkout was clean before review. No implementation or test fixes were made.
- Findings describe the original review baseline and were open when handed off. They are not a statement of current defect status. `P2` means an actionable correctness issue for the implementation backlog, not a release-blocking emergency.
- Companion review: [Test quality](test-quality-review-2026-09-21.md).

Archival note: when these reports were committed, the repository had advanced to version 1.20.0 at `7aa471aa7b8663e95ff56b1f25152445f44071a9`, including subsequent implementation and test changes. This document preserves the original evidence and acceptance criteria; it does not re-audit or certify closure of those changes.

Source line numbers refer to the baseline commit. Paths are repository-relative so this handoff can be used in another checkout.

## PKG-01 — Double-to-centavos conversion truncates valid amounts [P2]

**Location:** `lib/src/util/extensores.dart:5-6`, `BrasilFieldsDouble.obterCentavos`; also affects `obterCentavosSemSimbolo`.

The implementation multiplies a binary floating-point value by 100 and calls `toInt()`. Values slightly below an integer after multiplication lose a cent.

Confirmed results:

| Expression | Actual | Expected |
| --- | --- | --- |
| `(0.29).obterCentavosSemSimbolo` | `"28"` | `"29"` |
| `(0.57).obterCentavosSemSimbolo` | `"56"` | `"57"` |
| `(1.13).obterCentavosSemSimbolo` | `"112"` | `"113"` |
| `(-0.29).obterCentavosSemSimbolo` | `"-28"` | `"-29"` |

**Impact:** ordinary two-decimal monetary amounts are converted incorrectly.

**Acceptance criteria:**

- Correct the confirmed positive and negative two-decimal examples with and without the currency symbol.
- Preserve existing correct cases, including zero and integer amounts.
- Define the intended rounding policy for values with more than two decimal places before changing that behavior; those values were not the basis of this finding.
- Add regression cases that fail against the baseline and pass after the fix. See TEST-05.

## PKG-02 — Currency parser rejects the package's formatted output [P2]

**Location:** `lib/src/util/util_brasil_fields.dart:14-30`, `removerSimboloMoeda` and `converterMoedaParaDouble`; producer at `lib/src/util/extensores.dart:15-17`.

The helpers remove `R$` only when followed by an ordinary space, U+0020. The numeric `obterReal()` extension uses `intl` and emits a nonbreaking space, U+00A0.

Confirmed reproduction:

```dart
final formatted = (1590.9).obterReal(); // "R$\u00A01.590,90"
UtilBrasilFields.converterMoedaParaDouble(formatted); // 0.0; expected 1590.9
UtilBrasilFields.removerSimboloMoeda(formatted); // Still contains R$ and U+00A0
```

The same conversion failure was confirmed for `60.0` and `-1590.9`. Returning zero on parsing failure silently changes the amount.

**Acceptance criteria:**

- Accept the actual currency output of both the numeric extension and `UtilBrasilFields.obterReal`.
- Cover ordinary spaces, U+00A0, negative amounts, and both symbol-removal and numeric parsing.
- Add format-to-parse round trips with values representable to the chosen display precision.
- Preserve existing accepted inputs. Any broader change to invalid-input behavior should be an explicit compatibility decision.

## PKG-03 — Clearing a Centavos field restores its old amount [P2]

**Location:** `lib/src/formatters/centavos_input_formatter.dart:19`.

Empty input and overlength input share a branch returning `oldValue`. Therefore select-all followed by Delete cannot clear a populated field.

Confirmed reproduction through the documented filter chain:

```dart
const oldValue = TextEditingValue(
  text: '125,67',
  selection: TextSelection(baseOffset: 0, extentOffset: 6),
);
const newValue = TextEditingValue(
  text: '',
  selection: TextSelection.collapsed(offset: 0),
);
final filtered = FilteringTextInputFormatter.digitsOnly
    .formatEditUpdate(oldValue, newValue);
final result = CentavosInputFormatter().formatEditUpdate(oldValue, filtered);
// Actual result.text: '125,67'. Expected: ''.
```

Use `package:flutter/services.dart` and `package:brasil_fields/brasil_fields.dart` for this snippet.

**Acceptance criteria:**

- Accept a genuine empty edit while continuing to reject overlength edits without erasing the old amount.
- Exercise select-all deletion through a real `TextField` formatter chain.
- Verify currency on/off, two/three decimal places, and a valid cursor position after clearing.
- Retain existing formatting behavior for nonempty input. See TEST-01 and TEST-07.

## PKG-04 — Raw alphanumeric CNPJ validation accepts punctuation [P2]

**Location:** `lib/src/validators/cnpj_alfanumerico_validator.dart:65-90`, especially lines 85-90.

With `stripBeforeValidation: false`, length and checksum are checked without first enforcing the permitted character classes. The checksum function applies its ASCII conversion to arbitrary characters.

Both expressions were executed and returned `true`:

```dart
CnpjAlfanumericoValidator.isValid(
  '12345678901@83', stripBeforeValidation: false,
);
CnpjAlfanumericoValidator.isValid(
  '!!!!!!!!!!!!14', stripBeforeValidation: false,
);
```

**Acceptance criteria:**

- Require the complete raw shape: 12 uppercase alphanumeric characters followed by two numeric check digits, before checksum calculation.
- Return `false` for the confirmed punctuation examples and other forbidden characters.
- Preserve valid numeric CNPJs and valid alphanumeric CNPJs.
- Keep any changes to default stripping/normalization semantics outside this fix unless explicitly agreed. See TEST-04.

Reference consulted during the review: [Receita Federal CNPJ check-digit manual](https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/publicacoes/documentos-tecnicos/cnpj/manual-dv-cnpj.pdf).

## PKG-05 — Raw numeric validators throw for malformed input [P2]

**Locations:** `lib/src/validators/cpf_validator.dart:25-27,77-79`, `cnpj_validator.dart:24-27,77-79`, and `nup_validator.dart:30-39`.

Inputs of the expected length can reach `int.parse` with forbidden characters. Each confirmed expression below throws `FormatException` instead of returning `false`:

```dart
CPFValidator.isValid('12345678A09', stripBeforeValidation: false);
CNPJValidator.isValid('12345678901A34', stripBeforeValidation: false);
NUPValidator.isValid('0601064212022X000000', stripBeforeValidation: false);
```

**Acceptance criteria:**

- Validate the full raw numeric shape before parsing or checksum calculation.
- Return `false`, without exceptions, for malformed inputs of the correct length.
- Preserve existing valid, invalid-checksum, null, empty, and blocked-value behavior.
- Cover malformed characters in different positions, including check digits. See TEST-04.

This was grouped with PKG-04 in the conversational review; it is separated here because it affects three additional implementations and a different failure mode.

## PKG-06 — README omits the required alphanumeric CNPJ filter [P2]

**Locations:** `README.md:31-33`; `lib/src/formatters/cnpj_alfanumerico_input_formatter.dart:5-14,24-49`.

The README says to omit `digitsOnly` for alphanumeric CNPJ but does not show its replacement. The class documentation already shows the required alphanumeric filter. The widget test helper also supplies it, masking the gap in the README.

Using only `CnpjAlfanumericoInputFormatter`, appending each typed character to the previous formatted result, produces:

| Character typed | Displayed text |
| --- | --- |
| A | A |
| B | AB |
| C | AB.C |
| D | AB..CD |

The last result was confirmed in a Flutter test. It should be `AB.CD` with the supported filter chain.

**Acceptance criteria:**

- Put a complete, copyable alphanumeric CNPJ example in the README:

  ```dart
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]')),
    CnpjAlfanumericoInputFormatter(),
  ]
  ```

- Test sequential edits using exactly the published configuration.
- If standalone formatter support is desired instead, make that an explicit API decision and test it. The confirmed finding does not require redesigning the formatter.
- Do not infer that vehicle plates have the same punctuation-feedback bug; the confirmed reproduction concerns CNPJ.

## PKG-07 — README generator examples contradict the public signatures [P2]

**Locations:** `README.md:102-105`; `lib/src/util/util_brasil_fields.dart:132-150`.

The README describes `UtilBrasilFields.gerarCPF()` and `gerarCNPJ()` as returning formatted identifiers. Both wrappers actually declare the named parameter `useFormat` with default `false`, so zero-argument calls return raw identifiers. The README also shows `gerarCPF(false)` and `gerarCNPJ(false)`, which supply positional arguments to named-only APIs and do not compile.

This finding was supplied by the implementation team's follow-up and confirmed by inspecting the README and public signatures. Existing tests never call the CPF wrapper and always specify `useFormat` when calling the CNPJ wrapper.

**Acceptance criteria:**

- Align documentation with the existing public signatures: zero-argument calls produce raw output; `useFormat: true` requests formatted output; an explicit false call uses `useFormat: false`.
- Compile the published examples and check their stated output shapes through the public package entrypoint.
- Add wrapper tests for omitted defaults and both explicit formatting options. See TEST-08.
- Preserve current defaults and parameter syntax unless a deliberate compatibility change is authorized.

## PKG-08 — Numeric CPF/CNPJ generators exclude body digit 9 [P2]

**Locations:** `lib/src/validators/cpf_validator.dart:88-89` and `lib/src/validators/cnpj_validator.dart:88-89`.

Both generators draw body digits with `Random().nextInt(9)`. Dart's upper bound is exclusive, so the first nine CPF digits and first twelve numeric CNPJ digits can contain only `0` through `8`. Check digits are computed separately and can still contain `9`.

This is a defect in the generated digit domain, not a claim that every generated identifier is invalid. Shape checks and validation by the same checksum implementation will not detect the missing digit.

The implementation team's observation was confirmed by source inspection and the installed Dart SDK's documented `nextInt` range. A random sampling experiment is unnecessary to establish the exclusive-bound behavior.

**Acceptance criteria:**

- Allow the complete numeric body-digit domain `0` through `9` in both generators.
- Use a deterministic test seam to check the requested random bound and exercise boundary digits, including `9`, without relying on chance.
- Include non-repeated bodies containing `9`, with independently checked check digits and both formatting modes.
- Keep checksum, length, and formatting behavior correct. The alphanumeric generator already uses `validDigits.length`; this finding concerns the two numeric generators.
- Extend the test-quality acceptance criteria as specified in TEST-02.

## Verification and practical limits

Review environment: Flutter `3.48.0-1.0.pre-176`, framework `7db2cc827c`, Dart `3.14.0-111.0.dev`. These are the locally installed versions, not a claim about the project's minimum supported versions.

Commands actually run during review:

```sh
flutter --version
flutter pub get --offline
flutter pub get
flutter test --no-pub --reporter expanded
/Users/rubens/git/flutter/bin/cache/dart-sdk/bin/dart analyze
/Users/rubens/git/flutter/bin/cache/dart-sdk/bin/dart format --output=none --set-exit-if-changed lib test example/lib
/Users/rubens/git/flutter/bin/cache/dart-sdk/bin/dart --packages=.dart_tool/package_config.json /tmp/brasil_fields_review_probe.dart
flutter test --no-pub /tmp/brasil_fields_review_formatter_test.dart --reporter expanded
```

- Offline dependency resolution initially failed because `flutter_lints` 5 was not cached. Online resolution succeeded.
- The installed SDK selected compatible dependency versions that differed from the checked-in lockfiles. SDK-generated tracked changes were restored after verification.
- Existing suite: **190 passing tests**. Analysis: **no issues**. Formatting: **65 files checked, zero changes**.
- The standalone Dart probe confirmed PKG-01, PKG-02, PKG-04, and PKG-05. Two temporary Flutter diagnostic tests confirmed PKG-03 and PKG-06.
- Those diagnostic tests asserted the observed broken behavior to establish reproduction. They are not suitable expected results for the permanent regression suite; permanent tests must assert the corrected behavior.
- Temporary probe paths record historical commands, not required handoff artifacts. The inputs and actual/expected results needed to recreate them are preserved above.
- No minimum-SDK matrix, browser/platform matrix, production application, or remote CI run was performed.

PKG-07 and PKG-08 were added after the implementation team's follow-up. They were confirmed by source/signature and SDK documentation inspection, not by the earlier runtime probes. The team separately reported all 190 tests passing with `flutter test --no-pub --reporter compact`; the documentation-only follow-up did not rerun that suite. Existing findings and baseline evidence remain unchanged.

## Suggested implementation sequence

1. Add failing regressions for the eight findings, using the companion test-quality review to avoid repeating weak assertions.
2. Fix monetary conversion and field clearing; then raw validator character handling, generator digit domains, and the README examples.
3. Run focused tests after each change, followed by the complete suite, analysis, and formatting checks once integration is complete.
4. Keep the useful existing examples. Do not loosen expected results merely to preserve a passing test count.
