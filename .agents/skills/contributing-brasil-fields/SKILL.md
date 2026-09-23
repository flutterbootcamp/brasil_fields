---
name: contributing-brasil-fields
description: Maintain or extend the brasil_fields Flutter package in this repository. Use for changes to its formatters, validators, utilities, models, or tests; not for integrating the package into another app.
---

# Contributing to brasil_fields

Work from the behavior in `lib/` and the tests, not from examples alone. The public entrypoint is `lib/brasil_fields.dart`; export new code only when it is intended to be part of the public API. Internal helpers can stay private to `lib/src/`.

## Implementation

- Put input formatters in `lib/src/formatters/`, validators in `lib/src/validators/`, utilities in `lib/src/util/`, and static data collections in `lib/src/modelos/`.
- For a `TextInputFormatter`, check typing, deletion, pasting, cursor position, and active IME composition. Determine whether it expects digits only or accepts letters before recommending an input filter.
- Keep formatting separate from validation. A mask does not establish that an identifier, date, or amount is valid.
- Write concise Portuguese API comments that describe actual behavior, parameter defaults, and meaningful limits. Avoid comments that repeat the next line of code.

## Verification

- Add or update focused tests for changed behavior. Formatter tests live under `test/src/formatters/`; `formatter_test_harness.dart` provides numeric and alphanumeric formatter chains and cursor helpers.
- Run focused tests first, then the relevant package checks. CI runs `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test --coverage`, and the example app's tests; see `.github/workflows/workflow.yml`.
- Preserve unrelated worktree changes and report which checks actually ran.
