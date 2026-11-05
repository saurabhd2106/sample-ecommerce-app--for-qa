# Structured prompt: Create login test coverage (UI + API)

Use this as a reusable template. Swap the Context blanks for another feature
(register, checkout, cart, …) while keeping the same five components.

---

## Weak prompt (for comparison)

```text
Add login tests for valid, invalid, and empty inputs in the UI and API
test files. Also cover field validation.
```

---

## Structured prompt (five components)

```text
Role:
You are a senior QA automation engineer writing Playwright + TypeScript
UI and API tests for the Oakline ecommerce app. Follow the repo's
writing-test-cases skill and .cursor/rules/test-case-format rule without
being asked. Prefer page objects and API clients over raw selectors or URLs.

Task:
Close the login coverage gaps for these scenarios — but only add cases that
are not already covered in the suite:
  1. Valid input
  2. Invalid input (wrong password and unknown username)
  3. Empty input (both fields)
  4. Only password empty
  5. Only username empty (complete the field-validation set)
  6. Field validation steps (HTML required / password masking on UI;
     @NotBlank VALIDATION_ERROR fields on API)
Plan first, then implement. Do not edit the plan file after approval.
Verify coverage against both:
  - tests/specs/ui/login.spec.ts
  - tests/specs/api/auth.spec.ts

Context:
- App behaviour (derive assertions from code, do not invent messages):
  - UI LoginPage: both inputs have HTML `required`; empty submit is blocked
    by the browser (valueMissing), no form-error, no network call.
  - Password input type="password". Server errors render in
    data-testid="form-error" with message "Invalid username or password".
  - API LoginRequest: @NotBlank on username and password.
  - GlobalExceptionHandler returns 400 VALIDATION_ERROR with a `fields` map
    for blank input; 401 UNAUTHORIZED for bad/unknown credentials (same
    message — do not assume the API reveals which usernames exist).
  - AuthService trims username; password is not trimmed
    (whitespace-only password → VALIDATION_ERROR).
- Existing coverage to preserve:
  - UI + API: valid demo login (@smoke)
  - UI + API: wrong password (@smoke)
  - API: register + duplicate username (@smoke)
- Gaps to add (tag @regression):
  - UI: required/mask attributes; both empty; only password empty;
    only username empty; unknown username; tighten invalid-password to
    exact message + stay on /login
  - API: unknown username; both empty; only password empty; only username
    empty; whitespace-only password; username with surrounding whitespace
- Framework constraints:
  - Titles: `should <expected result> when <condition>`
  - Body: test.step blocks in order — optional `Input Data:`, required
    `Action:`, required `Validation:`; every expect only in Validation
  - Import test/expect from tests/src/fixtures, not @playwright/test
  - No raw CSS/XPath or hard-coded full URLs in specs
  - Use demo user only for read-only / login checks
- Page object: add isValueMissing(field) on LoginPage so specs stay free
  of DOM evaluation logic. login('', '') already works via fill('').

Format:
- Edit only:
  - tests/src/ui/pages/LoginPage.ts
  - tests/specs/ui/login.spec.ts
  - tests/specs/api/auth.spec.ts
- Deliverable shape: coverage matrix in the plan (covered vs missing for
  UI and API), then implementation matching that matrix
- Done when:
  - npm run lint:tests passes from tests/
  - npx playwright test specs/ui/login.spec.ts specs/api/auth.spec.ts
    passes against a running stack

Tone:
Direct and scenario-driven. Assert against real app behaviour and existing
helpers. No alternate frameworks, no inventing endpoints or error codes,
no drive-by refactors outside the three files above.
```

---

## Why this structure worked

| Component | What it locked in for this work |
|-----------|----------------------------------|
| **Role** | QA + skill/rule compliance → should/when titles, step structure, fixtures |
| **Task** | Explicit scenarios + “only add what is missing” + plan-then-implement |
| **Context** | Real UI/API behaviour, existing smoke cases, @regression gaps, page-object helper |
| **Format** | Exact three files and lint/test done criteria — no scope creep |
| **Tone** | Keeps the agent from inventing messages, codes, or rewriting the suite |

---

## Fill-in template (reuse for another feature)

```text
Role:
You are a senior QA automation engineer writing Playwright + TypeScript
UI and API tests for [APP]. Follow [SKILL / RULE PATHS]. Prefer page
objects and API clients over raw selectors or URLs.

Task:
Close coverage gaps for [FEATURE] for these scenarios — only add cases
not already in the suite:
  1. [SCENARIO]
  2. [SCENARIO]
  …
Plan first, then implement. Verify against:
  - [UI SPEC PATH]
  - [API SPEC PATH]

Context:
- App behaviour that drives assertions: [...]
- Existing coverage to preserve: [...]
- Gaps to add (and tags): [...]
- Framework constraints (naming, steps, fixtures, demo vs fresh user): [...]
- Page object / client helpers to add if needed: [...]

Format:
- Files to edit: [...]
- Done when: lint:tests + targeted playwright run pass

Tone:
Direct and scenario-driven. Assert against real behaviour; no invented
APIs, messages, or drive-by refactors.
```
