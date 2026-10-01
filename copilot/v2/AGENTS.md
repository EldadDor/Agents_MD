# AGENTS.md — IDI MS NG / Spring Boot 4.1.1 + Java 25 migration

Copilot CLI reads this file first. Read nested `AGENTS.md` before editing in its
scope; nested rules refine these.

## Repository

Multi-module Java infrastructure, Maven, Spring MVC, JUnit 5 + Mockito.

- `idi-ms-application-parent` — compiler/plugin and versions/JAR/WAR parents
- `idi-ms-ng-starter-parent\idi-ms-plugin-ng` — base infrastructure library
- `idi-ms-ng-starter-parent\idi-ms-service-ng` — shared business/base code
- `idi-ms-ng-starter-parent\idi-ms-test-ng` — test application, integration tests

Target: Spring Boot 4.1.1, Java 25. Version stays `2.0.0-SNAPSHOT`.
`com.idi.ms.ng.common:common-core:2.0.0-SNAPSHOT` is external; verify here,
change it only with separate permission.

## Plan and phases

`PLAN.md` is the authoritative plan: it defines every phase, its gate, scope,
prerequisites, and done-when criteria.

Work enters the repo in one direction:

`PLAN.md` → `docs\next_phase.md` (backlog row) → `docs\work_current_phase.md`
(active row) → `docs\complete_phases.md` (after CLOSE approval).

Never start a task without a row in `work_current_phase.md`. Move it from
`next_phase.md` first; if it isn't there yet, derive it from `PLAN.md` and add it
to the backlog. Task IDs and gate numbers come from `PLAN.md` — never invent them.

## Phase records — mandatory for repository-changing tasks

**Before a task:** read both record files. Set the row to `In progress` before
the first edit, with scope and gate. Update **Last reviewed** with the supplied
or system date; ask if unknown.

**After a task, before reporting:** set `Completed` / `Blocked` / `Deferred`
with full Evidence, update **Last reviewed**, add follow-ups to `next_phase.md`.

Close every response with `Phase records: <files>` or
`Phase records: unchanged — <reason>`. Question-only responses need no row.

Row schema:

`| ID | Title | Status | Gate | Scope | Worklog | Evidence | Last reviewed |`

- **Status:** `Not started` | `In progress` | `Awaiting G<n>` | `Awaiting approval` | `Blocked` | `Completed` | `Deferred`
- **Gate:** next gate from `PLAN.md`, or `—`
- **Worklog:** append-only, `YYYY-MM-DD — <≤12 words>`, joined with `<br>`
- **Evidence:** four labelled lines joined with `<br>` — `cmds:` commands and real
  results · `files:` paths touched · `commit:` hash, `not created (not requested)`,
  or `unknown` · `not run:` what was skipped and why (`—` if nothing)
- A `Completed` row missing a label is invalid. Completed and uncommitted is
  valid when stated; completion never authorizes a commit.

## Gates

A gate = stop, write the request into the task row, wait for the user. Between
gates you have full autonomy for routine work.

`PLAN.md` defines the phase gates. These supplemental gates apply to any task:

- **DESIGN** — new module, dependency, bean-wiring pattern, public API, or
  intentional behavior change. Present: approach, one rejected alternative,
  rollback note.
- **DELIVERY** — before any commit, merge, push, or deploy. Present evidence and
  the exact action. Commit approval is not push approval.
- **CLOSE** — before writing `docs\complete_phases.md`. Present outcomes and
  carry-over list.

A gate approves its own scope only. Tool grants, plan approval, and prior
approvals are not gate approvals. Waivers require an explicit user statement in
the current session. Never advance to the next phase automatically.

**Not gates:** refactors within one layer, formatting, comments, docs, backlog
edits, dependency patch bumps inside an approved scope.

## Migration invariants

- Preserve published groupIds, artifactIds, and directory names. Fix stale
  references; don't rename artifacts.
- Initial POM and version migration is done, pending verification. Declarations
  are not proof of a build.
- Keep servlet MVC and existing Mono/Flux/Reactor code. No reactive server.
- Keep Jackson 2 for legacy `com.fasterxml.jackson.databind.ObjectMapper`
  consumers; Boot-managed HTTP may use Jackson 3. Preserve explicit mapper
  overrides; validate converter ownership.
- Preserve security profile, session, filter-hook, and URL-matching behavior.
  A removed matcher is not permission to change endpoint access.
- Preserve unrelated user edits and untracked content.

## Maven on Windows

Set per PowerShell process, before every Maven call:

```powershell
$env:JAVA_HOME = 'C:\config\java\jdk-25'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
