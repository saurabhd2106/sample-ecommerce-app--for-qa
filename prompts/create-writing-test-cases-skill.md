# Structured prompt: Create a writing-test-cases skill

Use this to author (or recreate) a project skill that gives agents a reusable
structure for API and UI Playwright tests. Swap Context blanks for another
repo or stack; keep the five components.

---

## Weak prompt (for comparison)

```text
Create a Cursor skill for writing API and UI tests with a reusable structure.
```

---

## Structured prompt (five components)

```text
Role:
You are a staff QA architect who authors Cursor Agent Skills. Follow the
create-skill guidance: concise SKILL.md (under 500 lines), third-person
description with WHAT + WHEN trigger terms, progressive disclosure for
examples, and no fluff the agent already knows.

Task:
Create a project skill that teaches agents a reusable structure for writing
Playwright + TypeScript API and UI test cases in this repo. The skill must
make every new/edited spec follow one naming convention, one step layout,
and the same fixtures/page-objects/API-clients patterns — so tests stay
consistent without restating rules in every chat.

Do not invent a second framework. Codify the conventions already used under
tests/. Prefer tightening and documenting what exists over redesigning it.

Context:
- Skill location: .cursor/skills/writing-test-cases/ (project skill, shared
  with the repo). Optional companion always-apply rule at
  .cursor/rules/test-case-format.mdc that points agents at the skill.
- Stack: Playwright Test + TypeScript; specs under tests/specs/api/ and
  tests/specs/ui/; shared fixtures at tests/src/fixtures; page objects under
  tests/src/ui/pages/; API clients under tests/src/api/clients/.
- Naming (non-negotiable): every test title matches
  `should <expected result> when <condition>`.
- Body structure (non-negotiable): Playwright test.step() blocks in this
  order only:
    1. Input Data: ... — optional; only when the test needs data
    2. Action: ... — required; perform the action; no expect calls
    3. Validation: ... — required; every expect lives here
  Step titles must start with exactly `Input Data:`, `Action:`, or
  `Validation:` (colon + space).
- Imports: test and expect from the fixtures module, never directly from
  @playwright/test inside specs.
- Framework rules to encode:
  - Use fixtures, page objects, and API clients; no raw CSS/XPath or
    hard-coded full URLs in specs
  - Prefer data-testid locators inside page objects only
  - Mutating cart/order flows use a fresh user; demo user only for
    read-only or login checks
  - Tag smoke with @smoke; deeper cases with @regression
- Finish gate: run `npm run lint:tests` from tests/ (format checker for
  titles/steps) before considering work done.
- Progressive disclosure: keep SKILL.md short (naming, steps, placement,
  framework rules, checklist). Put full copy-paste API and UI templates in
  examples.md and link it from SKILL.md.
- Description must auto-trigger on: creating/adding/editing/generating
  tests under tests/specs/, *.spec.ts, smoke, regression, E2E, API, UI.

Format:
- Create or update:
  - .cursor/skills/writing-test-cases/SKILL.md
  - .cursor/skills/writing-test-cases/examples.md
  - Optionally .cursor/rules/test-case-format.mdc (alwaysApply: true) that
    lists the six hard rules and tells the agent to read the skill first
- SKILL.md frontmatter:
  - name: writing-test-cases
  - description: third person, WHAT + WHEN, include trigger terms above
- SKILL.md body sections (keep lean):
  - Naming (good/bad examples)
  - Required body structure
  - Where to put specs (API vs UI table)
  - Framework rules (bullets)
  - Checklist before finishing
  - Link to examples.md
- examples.md: at least one UI with Input Data, one UI without, one API
  with Input Data — matching real fixtures/page objects from this repo
- Done when: skill is discoverable from description alone; an agent given
  “add a login UI test” would produce should/when + Input Data/Action/
  Validation without further prompting; lint:tests still matches the rules
  the skill documents

Tone:
Prescriptive and short. Encode hard rules as musts, not suggestions.
No alternate test runners, no BDD rewrite, no essay on why testing matters.
If something is already enforced by lint:tests, say so once and move on.
```

---

## Why this structure worked

| Component | What it locked in for the skill |
|-----------|----------------------------------|
| **Role** | Skill-author mindset → concise SKILL.md, good description, progressive disclosure |
| **Task** | “Codify existing conventions” → reusable structure, not a new framework |
| **Context** | Naming, step order, fixtures, tags, lint gate, trigger terms for discovery |
| **Format** | Exact files + section outline + examples.md + optional always-apply rule |
| **Tone** | Hard rules stay hard; no BDD/Jest detours |

---

## Fill-in template (reuse for another repo)

```text
Role:
You are a staff QA architect who authors Cursor Agent Skills. Follow
create-skill guidance: concise SKILL.md, third-person WHAT+WHEN description,
progressive disclosure for examples.

Task:
Create a project skill that teaches agents a reusable structure for writing
[API / UI / E2E] tests with [RUNNER + LANGUAGE] in this repo. Codify existing
conventions under [TEST ROOT]; do not invent a second framework.

Context:
- Skill path: .cursor/skills/[skill-name]/
- Spec layout: [API dir] / [UI dir]
- Fixtures / page objects / clients: [...]
- Naming rule: [...]
- Required step/body structure: [...]
- Import / locator / data rules: [...]
- Finish gate (lint or format check): [...]
- Description trigger terms: [...]

Format:
- Files: SKILL.md, examples.md, optional always-apply rule
- SKILL.md sections: [...]
- examples.md must include: [UI + API templates using real helpers]
- Done when: agent can write a conforming test from a one-line ask

Tone:
Prescriptive and short. Hard rules as musts. No alternate runners.
```
