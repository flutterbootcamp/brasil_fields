# brasil_fields

- For package code or tests, follow `.agents/skills/contributing-brasil-fields/SKILL.md`.
- Preserve public behavior unless the task explicitly requests a breaking change. Export from `lib/brasil_fields.dart` only when an API is intended to be public.
- Avoid unrelated edits and preserve existing worktree changes.
- Keep dependency constraints; do not run `flutter upgrade` or broad dependency upgrades. Explain any intentional lockfile changes.
- Change the package version, `CHANGELOG.md`, or generated files only when the task requires it.
- Use `.github/workflows/workflow.yml` to select verification relevant to the change.
