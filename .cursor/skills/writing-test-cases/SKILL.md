---
name: writing-test-cases
description: >-
  Write Playwright + TypeScript UI and API tests for the Oakline ecommerce app
  using the required should/when naming and Input Data / Action / Validation
  test.step structure. Use when creating, adding, editing, or generating any
  test under tests/specs/, any *.spec.ts file, smoke tests, regression tests,
  E2E tests, API tests, or UI tests in this repository.
---

# Writing test cases (Oakline E2E)

Read this skill before creating or editing any file under `tests/specs/`.
After writing, run `npm run lint:tests` from `tests/`.

## Naming

Every test title must match:

```text
should <expected result> when <condition>
```

Good:
- `should return UP status when health endpoint is called`
- `should show empty results when max price filter is 0.01`

Bad:
- `health check`
- `login works`
- `test search AeroClick`

## Required body structure

Use Playwright `test.step()` blocks in this order:

1. **Input Data: ...** — optional. Only when the test needs data (credentials, search term, payload, unique user).
2. **Action: ...** — required. Perform the user/API action via page objects or API clients. **No `expect` calls.**
3. **Validation: ...** — required. Every `expect` assertion lives here.

Step titles must start with exactly `Input Data:`, `Action:`, or `Validation:` (including the colon and space).

## Where to put specs

| Layer | Directory |
|-------|-----------|
| API | `tests/specs/api/` |
| UI | `tests/specs/ui/` |

Import `test` and `expect` from `../../src/fixtures` (adjust relative path). Do not import from `@playwright/test` in specs.

## Framework rules

- Use fixtures, page objects (`HomePage`, `LoginPage`, …), and API clients (`api.auth`, `api.catalog`, …).
- Do not put raw CSS/XPath selectors or hard-coded full URLs in specs.
- Prefer `data-testid` locators inside page objects only.
- Tests that mutate cart/order state must use a fresh user (`authedApi` / `freshUserPage` / `uniqueUser()`). Use the `demo` user only for read-only or login checks.
- Tag smoke coverage with `{ tag: '@smoke' }`. Use `@regression` for deeper cases.

## Checklist before finishing

- [ ] Title matches `should ... when ...`
- [ ] Has `Action:` and `Validation:` steps (and `Input Data:` only if needed)
- [ ] Steps are in order; no other step prefixes
- [ ] No `expect` outside `Validation:`
- [ ] Spec lives under the correct `specs/api` or `specs/ui` folder
- [ ] `npm run lint:tests` passes

## Examples

See [examples.md](examples.md) for full API and UI templates.
