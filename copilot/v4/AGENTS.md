# AGENTS.md — IDI MS NG infrastructure migration

One Copilot CLI session owns the repo. Copilot reads this file first. A nested
`AGENTS.md` refines (never cancels) these rules.

## Stack
Java 25 · Spring Boot 4.1.1 · Spring MVC (servlet) · Maven 3.9 · JUnit 5 +
Mockito · Jackson 2 and 3 coexisting · Reactor (library use, not a reactive server)

Modules: `idi-ms-application-parent` (compiler/plugin + versions/JAR/WAR parents) ·
`idi-ms-ng-starter-parent\idi-ms-plugin-ng` (base infrastructure) ·
`idi-ms-ng-starter-parent\idi-ms-service-ng` (shared business/base) ·
`idi-ms-ng-starter-parent\idi-ms-test-ng` (test app + integration tests).

`com.idi.ms.ng.common:common-core:2.0.0-SNAPSHOT` is external — verify it here;
changing it needs separate permission and repo access.

## Phase records — MANDATORY every task
Single source of truth: `docs\work_current_phase.md` (current) and
`docs\next_phase.md` (backlog). Keeping them current is part of every task.
Only an explicit user instruction suspends this; silence does not.

**Intake:** never start work with no row in `work_current_phase.md` — move it
from `next_phase.md` first. When the backlog runs out or a phase closes, open
`PLAN.md` and copy the next phase's ID, gate, scope, and prerequisites into
`next_phase.md`. That is the only reason to read `PLAN.md`; never invent a task
ID or gate number that isn't in it.

**Before a task:** read both record files. Set the row to `In progress` *before*
the first code, POM, or doc edit, with scope + approval dependency. Update
**Last reviewed** with the supplied or system date; ask if unknown.

**After a task, before reporting:** set the row to `Completed` / `Blocked` /
`Deferred` with full Evidence; update **Last reviewed**; add follow-ups to
`next_phase.md`; on phase close record it in `docs\complete_phases.md` (CLOSE).

Never end a code/doc-changing response without the matching record update.
Question-only responses need no row. Close every response with
`Phase records: <files>` or `Phase records: unchanged — <reason>`.

## Task row schema (`work_current_phase.md`)
`| ID | Title | Status | Gate | Scope | Worklog | Evidence | Last reviewed |`

- **Status:** `Not started` | `In progress` | `Awaiting G<n>` | `Awaiting approval` | `Blocked` | `Completed` | `Deferred`
- **Gate:** next gate to clear, or `—`
- **Worklog:** append-only, one line per session: `YYYY-MM-DD — <≤12 words>`,
  joined with `<br>`; never rewrite history
- **Evidence:** four labelled lines joined with `<br>` —
  `cmds:` commands + real results · `files:` paths touched ·
  `commit:` hash, `not created (not requested)`, or `unknown` ·
  `not run:` what was skipped and why (mandatory; write `—` if nothing).
  Example: `cmds: mvn -Dmaven.test.skip=true compile → BUILD SUCCESS`
- A `Completed` row missing a label is **invalid** — fix before reporting.
  Completed-and-uncommitted is valid when stated; completion never authorizes
  a commit. Committing against a `Not started` row is a violation.

## Gates
A gate = stop, write the request into the task row, wait. Between gates you have
full autonomy — don't ask for confirmation of routine work.

Numbered gates `G1`–`G9` belong to the migration phases and are defined in
`PLAN.md`; carry each one into the task row with its phase. These supplemental
gates apply to any task, in addition:

- **DESIGN** — new module, new dependency, new bean-wiring pattern, public API
  or matching-policy change, intentional behavior change. Present: chosen
  approach, one rejected alternative, rollback note. A phase approval covers
  DESIGN only if its presented scope included that design.
- **DELIVERY** — before any commit, merge, push, or `deploy`. Present: Evidence
  and the exact intended action. Commit approval is not push approval.
- **CLOSE** — before writing `docs\complete_phases.md`. Present: per-task
  outcomes + proposed carry-over list.

**Not gates** (proceed alone): refactors within one layer, formatting, comments,
docs, editing `next_phase.md`, dependency *patch* bumps inside an approved scope.

Each gate approves its own scope only. Tool grants, plan approval, prior
approvals, and agent-written records are not approvals. Waivers require an
explicit user statement in the current session. Never advance a phase
automatically.

## Migration invariants
- Preserve published groupIds, artifactIds, and directory names; fix stale
  references instead of renaming artifacts. Version stays `2.0.0-SNAPSHOT`.
- Initial POM/version migration is **done, pending verification**. Declarations
  are not proof of a build; `target\` contents are not proof of success.
- Keep servlet MVC and required Mono/Flux/Reactor code.
- Keep Jackson 2 for legacy `com.fasterxml.jackson.databind.ObjectMapper`
  consumers; Boot-managed HTTP may use Jackson 3. Preserve explicit mapper
  overrides; validate converter ownership and payload contracts.
- Preserve security profile, session, filter-hook, and URL-matching behavior.
  A removed matcher is not permission to change endpoint access.
- Preserve unrelated user edits and untracked content.

## Commands
Set per PowerShell process, before every Maven call:

```powershell
$env:JAVA_HOME = 'C:\config\java\jdk-25'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
