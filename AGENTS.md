# brasil_fields repository instructions

This repository contains the `brasil_fields` Flutter/Dart package.

## Repository structure

- Public package entrypoint: `lib/brasil_fields.dart`
- Package implementation: `lib/src/`
- Input formatters: `lib/src/formatters/`
- Validators: `lib/src/validators/`
- Utilities: `lib/src/util/`
- Static models/data: `lib/src/modelos/`
- Package tests: `test/`
- Example application: `example/`
- CI workflow: `.github/workflows/workflow.yml`

For package implementation work, follow the repository skill at
`.agents/skills/contributing-brasil-fields/SKILL.md`.

## Development rules

- Preserve backward compatibility unless the task explicitly requests a breaking change.
- Do not expose internal implementation through `lib/brasil_fields.dart` unless it is intended to become public API.
- Keep formatting and validation behavior separate.
- For `TextInputFormatter` changes, consider:
  - normal typing
  - deletion
  - select-all deletion
  - pasting
  - middle insertion/replacement
  - cursor/selection preservation
  - IME composing state where applicable
- Keep API documentation concise and in Portuguese, matching the existing package style.
- Avoid unrelated refactors.
- Do not modify generated files unless the task requires it.
- Do not change package versions or `CHANGELOG.md` unless explicitly requested.

## Dependency policy

- Use the existing dependency constraints unless a task specifically requires changing them.
- Do not run broad dependency upgrades as part of unrelated work.
- Do not run `flutter upgrade`.
- Treat dependency lockfile changes as intentional changes that must be explained.

## Verification

Run focused tests for the changed behavior first.

Before finishing a normal code change, run:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
(cd example && flutter test)
```

Check the worktree afterward for incidental changes from these commands.
