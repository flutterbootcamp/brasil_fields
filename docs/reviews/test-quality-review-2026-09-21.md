# Test-quality review — 2026-09-21

## Scope and conclusion

- Baseline: `4ff33c03978d10208b942f6d114fe29a0a6cf216`, package version 1.18.0.
- Scope: existing tests under `test/`, their helpers and assertions, corresponding public APIs, and the CI test command.
- Companion review: [Package correctness](package-review-2026-09-21.md).
- No permanent test or implementation changes were made by this review. Findings describe gaps at the original baseline, when they were handed off to the implementation team; they are not a statement of current test quality.

Archival note: when these reports were committed, the repository had advanced to version 1.20.0 at `7aa471aa7b8663e95ff56b1f25152445f44071a9`, including subsequent implementation and test changes. The measurements and mutation experiment below belong to the original baseline. This document does not re-audit the later suite or certify closure of the findings.

The suite contains useful expected-output examples for masks, punctuation, grouping, case conversion, identifiers, dates, and currencies. Those examples should be retained. Its protection against editing interactions, option routing, malformed input, and interactions between APIs is substantially weaker than the test count and line coverage suggest.

All findings below are priority **P2**. The goal is to repair misleading assertions and fill meaningful behavioral gaps, not discard the suite or increase its count for its own sake.

## Measured evidence

| Measure | Result |
| --- | --- |
| Existing tests | 190 passed |
| Instrumented executable line coverage | 661 / 715 = 92.4%, across 34 files |
| All four validator implementations | 100% line coverage each |
| `extensores.dart` | 100% line coverage |
| `util_data.dart` | 26 / 52 = 50.0% |
| `util_brasil_fields.dart` | 65 / 84 = 77.4% |
| `centavos_input_formatter.dart` | 38 / 43 = 88.4% |

These are execution metrics for instrumented lines, not branch coverage, correctness scores, or a measure of assertion strength. The validator and currency bugs in the companion review occurred despite complete line coverage in the affected validator/extension files.

### Controlled regression experiment

The reviewer copied `lib/`, `test/`, dependency metadata, and package configuration to an isolated temporary directory. The original repository was not modified. Three independent deliberate regressions were applied together:

| Deliberate change in the temporary copy | Result |
| --- | --- |
| `CPFValidator.generate` always returns raw digits, ignoring `useFormat` | Full suite remained green |
| `UtilBrasilFields.gerarCNPJ` always calls the numeric generator, ignoring `isAlphanumeric` | Full suite remained green |
| `UtilData.obterMes` always returns `99` | Full suite remained green |

The unchanged suite passed **all 190 tests with all three changes present**. This was a targeted combined experiment, not a comprehensive mutation-testing campaign or three separately measured mutation scores. It provides direct evidence for TEST-02, TEST-03, and TEST-06.

## TEST-01 — Formatter tests omit essential editing state and edit sequences

**Locations:** `test/src/formatters/real_input_formatter_test.dart:5-11,27-39,57-68`; representative helper at `test/src/formatters/cpf_input_formatter_test.dart:5-11`; widget cases at `test/brasil_fields_test.dart:157-195`.

All 18 focused formatter test files construct `TextEditingValue(text: ...)` without a valid selection, then return only `.text`. No tests explicitly assert `selection` or `composing` state. Several groups named `backspace` or `digitacao` repeatedly pass an empty old value and independently format shorter or longer strings.

The widget scenarios replace whole values with `tester.enterText` and assert only controller text. They do not exercise select-all deletion, middle insertion, replacement of a selection, or editing around punctuation. Their shared filter helper also differs from the incomplete CNPJ instructions in the README.

**Consequence:** caret/selection defects, feedback of formatted punctuation into the next edit, and the confirmed inability to clear a Centavos field can pass.

**Acceptance criteria:**

- Helpers accept and return full `TextEditingValue`s with explicit valid selections.
- Assert text and cursor/selection behavior; add relevant composing-state cases under the supported Flutter contract.
- Drive sequential edits by carrying each returned value into the next edit through the supported filter chain.
- Add widget tests for select-all Delete, middle insertion, selection replacement, and deletion at separators.
- Test README examples as published, without silently supplying extra prerequisites.
- Keep exhaustive mask tables as unit tests; use widget tests for integration behavior. Relates to PKG-03 and PKG-06.

## TEST-02 — Random inequality does not verify generator formatting

**Locations:** `test/cpf_test.dart:39-47`, `test/cnpj_test.dart:41-49`, `test/cnpj_alfanumerico_test.dart:46-54`.

Each generator test creates two unrelated random identifiers and asserts `raw != formatted`. This usually succeeds even when both values are raw. Calling the same production validator on both outputs does not check their formatting. Generation and validation also share checksum code, so agreement between them is not an independent proof of check-digit correctness.

Ignoring CPF's `useFormat` option survived the controlled experiment.

Shape and checksum checks also miss a separate existing generator defect: CPF and numeric CNPJ use `Random().nextInt(9)` for body digits, restricting them to `0` through `8`. Check digits can still contain `9`. The deterministic verification must cover the complete body-digit domain, not only valid output shapes. See PKG-08 in the companion review.

**Acceptance criteria:**

- Check the exact anchored shape of raw and formatted outputs independently.
- Verify stripping and reformatting one generated identifier; do not compare two unrelated random identifiers as a formatting assertion.
- Retain fixed known-valid and known-invalid identifiers with explicit expected results.
- Where generation behavior needs deterministic verification, provide an appropriate test seam or independent reference calculation. Avoid tests that depend on luck or require a particular random output.
- Through a deterministic seam, verify the exclusive random bound is 10 and exercise every body digit `0` through `9` in both numeric generators. Include non-repeated bodies containing `9`, then verify their check digits independently; do not rely on unseeded sampling or mistake a `9` in a check digit for body-domain coverage.
- Demonstrate that deliberately ignoring `useFormat` now causes a relevant test to fail.
- Cover the public generator wrappers and their omitted-argument defaults as specified in TEST-08, in addition to these direct validator tests.

## TEST-03 — Alphanumeric generator tests select the wrong branch or allow invalid shapes

**Location:** `test/util_brasil_fields_test.dart:444-467`.

The test named `não formatado alfanumérico` omits `isAlphanumeric: true`, duplicating the numeric branch. Generator regexes are unanchored. The formatted alpha regex uses `\w` throughout, accepting lowercase, underscores, and letters in the final two numeric check-digit positions.

Always routing the utility to the numeric generator survived the controlled experiment.

**Acceptance criteria:**

- Correct the omitted option and explicitly cover both formatting modes and both generator routes.
- Use anchored shapes, such as `^[A-Z0-9]{12}[0-9]{2}$` for raw alphanumeric CNPJ, and numeric-only check digits in the formatted equivalent.
- Ensure tests reject prefixes, suffixes, underscores, lowercase output, and nonnumeric check digits where the output contract prohibits them.
- Verify routing with deterministic evidence. An all-numeric identifier can legitimately belong to the alphanumeric character space; do not introduce a flaky assertion that every random alphanumeric result must contain a letter.
- Demonstrate that ignoring `isAlphanumeric` causes a routing test to fail.

## TEST-04 — Malformed validator fixtures only test the length guard

**Locations:** `test/cpf_test.dart:11-17`, `test/cnpj_test.dart:9-15`, `test/cnpj_alfanumerico_test.dart:9-15`, and `test/nup_test.dart:12-22`.

The invalid fixtures with `stripBeforeValidation: false` have the wrong total length. Validation returns before parsing characters or computing a checksum. Thus these tests do not protect the character-handling behavior their inputs appear to exercise.

**Acceptance criteria:**

- Add malformed values with exactly 11 characters for CPF, 14 for CNPJ, and 20 for NUP.
- Assert `false` without exceptions, including the concrete examples in PKG-04 and PKG-05.
- Vary character positions, including body and check digits, and retain separate wrong-length cases.
- Cover valid and invalid inputs with stripping enabled and disabled, respecting the existing normalization contract.
- Add direct public-wrapper tests for `isCPFValido`, `isCNPJValido`, and `isNUPValido`, including false/null results and CNPJ option routing. Existing `obter*` success cases only cover some wrapper behavior indirectly.

## TEST-05 — Currency examples omit boundaries and API round trips

**Location:** `test/util_brasil_fields_test.dart:34-114`.

The parser is tested against handwritten ordinary-space input. Formatting tests separately expect U+00A0, but no test passes that actual output to the parser. Centavos tests use a few amounts such as `1590.9`, `0.1`, and `-10.5`, which do not expose the confirmed truncation examples.

**Acceptance criteria:**

- Add exact expected results for `0.29`, `0.57`, `1.13`, and their negative counterparts where relevant.
- Test `converterMoedaParaDouble(value.obterReal())` for two-decimal values, along with output from `UtilBrasilFields.obterReal`.
- Test both currency-symbol helpers with ordinary and nonbreaking spaces.
- Include zero, sign handling, decimal precision, and grouping boundaries with explicit expectations.
- Compare numeric round trips using a tolerance appropriate to the documented precision when exact double equality is unsuitable. Relates to PKG-01 and PKG-02.

## TEST-06 — Public date helpers are entirely unexecuted

**Locations:** date tests begin at `test/util_brasil_fields_test.dart:177`; implementation at `lib/src/util/util_data.dart:16-31,65-99`.

Coverage shows no execution of `UtilData.validarData`, `removeCaracteres`, `obterMes`, or `obterDia`. Replacing `obterMes` with a constant `99` survived the full suite.

**Acceptance criteria:**

- Add direct tests for each helper with raw/formatted inputs, relevant boundaries, and invalid-length behavior.
- Verify extracted day and month against independently specified expected values across multiple dates.
- Demonstrate that returning a constant invalid month is caught.
- Do not silently redefine `validarData` as calendar validation: its current documentation describes checking the Brazilian input format. Decide and document any stronger calendar-validation contract before implementing it.

## TEST-07 — Overlength tests do not protect existing user input

**Representative locations:** `test/src/formatters/cartao_bancario_input_formatter_test.dart:17-18`, `cpf_input_formatter_test.dart:16`, and `cnpj_input_formatter_test.dart:20-22`. These are examples, not the complete remediation scope.

The tests submit oversized text with an empty old value and expect an empty result. Both preserving `oldValue` and incorrectly erasing the field satisfy these assertions.

The pattern occurs in **17 of the 18** focused formatter test files: altura, cartão bancário, CEP, CEST, alphanumeric CNPJ, numeric CNPJ, CNS, CPF, hora, IOF, KM, NCM, NUP, placa de veículo, real, telefone, and temperatura. `validade_cartao_input_formatter_test.dart` is the remaining file; its invalid constructor-length test is not this overflow-preservation test.

**Acceptance criteria:**

- Apply the following criteria across all 17 affected files and every relevant option variant, not only the three representative citations.
- Start with a populated, fully formatted old value and an explicit selection.
- Attempt one extra character through the actual supported formatter chain.
- Assert equality with the complete old value, not only an empty string.
- Include replacement/paste cases around maximum length where behavior differs.

## TEST-08 — Public generator defaults and published examples are untested

**Locations:** `test/util_brasil_fields_test.dart:444-467`; `lib/src/util/util_brasil_fields.dart:132-150`; `README.md:102-105`.

There are no test calls to `UtilBrasilFields.gerarCPF`. Every call to `UtilBrasilFields.gerarCNPJ` in the test suite explicitly supplies `useFormat`, leaving the omitted-argument default untested. Direct validator tests do not protect these wrapper contracts.

The README describes zero-argument calls as formatted and shows positional boolean calls (`gerarCPF(false)` and `gerarCNPJ(false)`). Both public wrappers actually use named parameters and default `useFormat` to `false`. The positional examples do not match the Dart signatures. See PKG-07 for the package/documentation defect.

**Acceptance criteria:**

- Import the public entrypoint and call both wrappers with no arguments; assert the exact raw shape promised by their current default-false signatures.
- Cover explicit `useFormat: false` and `useFormat: true` for both wrappers, plus the CNPJ alphanumeric option without unnecessarily specifying `useFormat` in every case.
- Compile and execute the supported generator examples from the README. Make their prose, call syntax, and output shapes agree.
- Correct the documentation to the existing named-parameter contract unless a deliberate API change is authorized. Do not silently change defaults to accommodate stale examples.
- Ensure mutating a wrapper's default or ignoring its format option causes a relevant test to fail.

## TEST-09 — Utilities, extensions, and three validators bypass public-export tests

**Locations:** imports at `test/util_brasil_fields_test.dart:1-3`, `test/cpf_test.dart:1`, `test/cnpj_test.dart:1`, `test/cnpj_alfanumerico_test.dart:1`; exports at `lib/brasil_fields.dart:31-34`.

These tests import implementation paths under `package:brasil_fields/src/...` directly. They exercise implementations without proving that consumers can access them through `package:brasil_fields/brasil_fields.dart`. The utility/extension exports could be omitted, or the public entrypoint could hide `CPFValidator`, `CNPJValidator`, and `CnpjAlfanumericoValidator`, without these tests detecting the public API regression.

This is a specific gap, not a claim that no exports are tested. `test/nup_test.dart` already imports the public entrypoint, as do many formatter tests. Removing the entire validator export would therefore break existing NUP tests; selective omission of the other three validator symbols is the unprotected case.

**Acceptance criteria:**

- Add a consumer-facing contract test that imports the package only through `package:brasil_fields/brasil_fields.dart`, with no direct or helper-mediated implementation imports supplying the symbols under test.
- Reference and exercise `UtilBrasilFields`, `UtilData`, the int and double extensions, and all four public validators through that entrypoint.
- Use meaningful existing behavior examples and public defaults; avoid adding a large duplicate suite just to test visibility.
- Removing a utility/extension export or selectively hiding one of the three previously unprotected validators must make the contract test fail to compile or otherwise fail clearly.
- Internal unit tests may retain implementation imports where appropriate; the missing consumer-facing layer is what needs to be added.

## Additional targeted follow-ups

These are coverage/design opportunities, not additional runtime bugs confirmed by this review:

- `CentavosInputFormatter` has no focused unit-test file. Add option/boundary tables for currency on/off, two/three decimals, empty input, zeros, grouping, and maximum length. `DataInputFormatter`, `CertNascimentoInputFormatter`, and `PesoInputFormatter` also rely on very few widget examples.
- `test/src/formatters/cns_formatter_test.dart:27-36` requires trailing spaces while a TODO questions that behavior. Decide the intended separator behavior before treating the current output as a permanent requirement.
- `test/src/formatters/hora_input_formatter_test.dart:17` tests `25:59`, but lacks a boundary table for `23:59`, `24:00`, `00:00`, `12:59`, and `12:60`.
- NUP tests reuse a single valid identifier with check digits `21`. Add independently verified cases with a leading-zero check digit and varied fields.
- Existing random-generator checks are nondeterministic. Avoid adding more unseeded sampling as a substitute for deterministic boundary and shape tests.

## Verification record and implementation handoff

Commands actually run by the primary reviewer:

```sh
# Original checkout: execution coverage of the unchanged suite.
flutter test --no-pub --coverage --coverage-path /tmp/brasil-fields-test-quality.lcov --reporter expanded

# Isolated copy /tmp/brasil-fields-test-quality-30ei81ra:
# unchanged tests against the three deliberate regressions described above.
flutter test --no-pub --reporter expanded

git status --short
```

The coverage report's `DA` records were aggregated to calculate executed/instrumented line counts. Static review also inspected all focused formatter tests, widget tests, four validator test files, and utility tests. The installed SDK and dependency-resolution caveats are recorded in the companion package review.

The temporary experiment initially lacked `package_graph.json` and did not start. After copying that dependency metadata, the full experiment completed successfully. The reported 190 passing tests refer to the completed run.

### Team follow-up incorporated

The implementation team's subsequent review identified four P2 omissions. They were checked against the unchanged baseline and incorporated as follows:

| Team observation | Handoff update |
| --- | --- |
| Overlength scope is 17/18 focused files | TEST-07 now names the full affected set and requires remediation across it |
| Wrapper defaults and README generator examples are missed | Added TEST-08 and package finding PKG-07 |
| Numeric generator body digit `9` is impossible | Expanded TEST-02's deterministic criteria and added PKG-08 |
| Public exports are not fully protected | Added TEST-09, explicitly preserving the NUP/formatter coverage qualification |

The team reported `flutter test --no-pub --reporter compact` passing all 190 tests with no file changes. That result is attributed to the team; this documentation update did not rerun the suite. Follow-up verification used source/import searches, enumeration of the 18 focused formatter files, and the installed Dart SDK's `Random.nextInt` documentation confirming its exclusive upper bound. No further runtime mutation result is claimed for these additions.

No comprehensive mutation score, minimum-SDK matrix, platform matrix, or remote CI result is claimed. Historical temporary paths are not required to use this handoff: the mutations, assertions at fault, and acceptance criteria are preserved in this document.

For implementation, retain useful existing examples, repair the assertion/helper weaknesses, add failing regressions for the package findings, and then fix production behavior. Run focused checks during development and the full suite, analysis, and formatting checks after integration. Review the behavior being protected rather than using a higher test count or line-coverage target as the definition of completion.
