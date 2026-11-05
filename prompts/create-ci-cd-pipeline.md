# Structured prompt: Create the Oakline CI/CD pipeline

Teaching artifact for Lab-style prompt design. Compare the weak original ask
with the five-component rewrite that produced
[`.github/workflows/ci-cd.yml`](../.github/workflows/ci-cd.yml).

---

## Weak prompt (original ask from the conversation)

```text
Create github actions workflow to build, test, scan (using sonarqube), and
publish artefact for both frontend and backend and then deploy both the
application on the AWS virtual machine

The Ip address of the virtual machine is 34.200.249.158

Docker is installed on the virtual machine so you can deploy all three apps
as docker containers

Once the application (both frontend and backend are ready add another job to
run all testcases we have created in the test folder

Use application URL as the public IP of the VM above

Port 80 and 8080 are enabled for testing
```

**Gaps this left open:** which Sonar product, which registry, Dockerfile style,
how frontend talks to `/api` on the VM, PR vs main behaviour, which secrets,
Postgres on the VM, and how E2E is split.

---

## Structured prompt (five components)

Paste this into a new agent session to recreate (or extend) the same pipeline.

```text
Role:
You are a senior DevOps engineer who designs production-ready GitHub Actions
pipelines for a 3-tier Java/React ecommerce app. Prefer clear job boundaries,
secure secret handling, and a deploy path a QA team can trust after every
main push.

Task:
Create a GitHub Actions CI/CD pipeline that, for both the Spring Boot backend
and the Vite/React frontend:
  1. Builds the app
  2. Runs its automated checks (backend: mvn verify; frontend: lint + build)
  3. Scans the code with a self-hosted SonarQube server
  4. Publishes a Docker image to GitHub Container Registry (ghcr.io)
Then deploy postgres + backend + frontend as Docker containers on the given
AWS VM over SSH, wait until both apps are healthy, and run the Playwright
suite under tests/ against the live URLs (API and UI jobs in parallel).

Context:
- Repo layout:
  - backend/ — Maven, Java 21, Spring Boot, listens on 8080, /api/health
  - frontend/ — Vite + React; browser calls relative /api (same-origin)
  - tests/ — Playwright + TypeScript (projects: setup, api, ui-chromium;
    scripts: lint:tests, test:api, test:ui)
  - docker-compose.yml — Postgres-only for local dev (not for prod deploy)
- There are no Dockerfiles yet. Add runtime-only Dockerfiles that COPY
  CI-built artefacts (backend jar, frontend dist). Do not multi-stage build
  from source inside the image.
- Frontend must be served on port 80 with nginx; proxy /api/ to the backend
  container so the browser stays same-origin (no CORS changes).
- Backend must stay reachable on port 8080 for API E2E tests.
- VM public IP: 34.200.249.158 — Docker + Compose v2 installed;
  ports 80 and 8080 open; SSH via GitHub secrets.
- SonarQube: self-hosted. Use secrets SONAR_HOST_URL and SONAR_TOKEN.
  Separate Sonar project keys: oakline-backend, oakline-frontend.
- Registry: ghcr.io images
  ghcr.io/<owner>/oakline-backend and oakline-frontend,
  tagged with ${{ github.sha }} and latest. Auth with GITHUB_TOKEN.
- Branch rules:
  - pull_request → build, test, scan only
  - push to main OR workflow_dispatch → also publish, deploy, E2E
- Post-deploy E2E env:
  BASE_URL=http://34.200.249.158
  API_URL=http://34.200.249.158:8080/api
  DEMO_USER=demo / DEMO_PASSWORD=password1
  BROWSERS=chromium
- After deploy, poll until backend /api/health is UP and frontend returns 200
  before starting E2E. Run E2E as a matrix: suite=[api, ui], fail-fast=false.
  Upload reports/ and test-results/ as artefacts.
- Add JaCoCo to backend Maven verify so Sonar gets coverage.
- Secrets to document: SONAR_HOST_URL, SONAR_TOKEN, VM_SSH_USER, VM_SSH_KEY;
  optional POSTGRES_PASSWORD and APP_JWT_SECRET (demo fallbacks OK).
- Do not invent cloud infra beyond this single VM. Do not push to Docker Hub.

Format:
- One workflow: .github/workflows/ci-cd.yml
- Also add: backend/Dockerfile, frontend/Dockerfile, frontend/nginx.conf,
  deploy/docker-compose.prod.yml, matching .dockerignore files
- Small backend/pom.xml edit for JaCoCo only
- Job graph with clear needs:
  backend-build-test  → sonar-backend  → publish-backend  ┐
  frontend-build-test → sonar-frontend → publish-frontend ┴→ deploy → e2e-tests
- Concurrency group per workflow+ref; cancel in-progress only off main
- When done, list required GitHub secrets and VM assumptions
- Plan first if asked; otherwise implement and smoke-check Docker builds locally

Tone:
Direct, production-minded, and specific. Prefer concrete file paths, image
names, ports, and secret names over generic CI advice. No fluff. Do not
propose ECS, EKS, Helm, or Terraform unless a stated requirement is impossible
on one Docker VM.
```

---

## Why this structure worked

| Component | What it locked in for this pipeline |
|-----------|-------------------------------------|
| **Role** | Senior DevOps framing → secrets, job boundaries, QA-trustworthy deploy |
| **Task** | Ordered stages (build → test → scan → publish → deploy → E2E) per app |
| **Context** | Stack, ports, VM IP, Sonar/GHCR, PR vs main, relative `/api`, E2E matrix |
| **Format** | Exact files + job graph → stops inventing extra infra or multi-stage images |
| **Tone** | Keeps the agent on “one VM + Docker” instead of a cloud platform redesign |

**Biggest lever: Context.** Without VM IP, registry, Sonar type, and the
relative `/api` constraint, the agent invents infra or breaks CORS on the VM.

---

## Fill-in template (reuse for another app)

```text
Role:
You are a senior DevOps engineer who designs production-ready GitHub Actions
pipelines for [STACK].

Task:
Create a CI/CD pipeline that: [BUILD] → [TEST] → [SCAN TOOL] → [PUBLISH TARGET]
→ [DEPLOY TARGET] → [POST-DEPLOY CHECKS].

Context:
- Apps/services: [...]
- Runtime constraints (ports, Docker, proxy/CORS): [...]
- Environment (VM/IP/cluster): [...]
- Scan + registry choices: [...]
- Branch rules (PR vs main): [...]
- Secrets available / to document: [...]

Format:
- Workflow path: [...]
- Supporting files to add/change: [...]
- Job graph: [...]
- Done when: [...]

Tone:
[Direct / explanatory / teaching — pick one]
```
