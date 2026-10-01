# AGENTS.md - Java infrastructure migration / Copilot CLI

## Session bootstrap and scope

Copilot CLI reads this root `AGENTS.md`; no Codex launcher or file rename is
required. Read it and both phase-record files before repository work. Read any
nested `AGENTS.md` before editing within its scope; nested rules refine these
rules and do not waive migration constraints or approval gates.

One primary Copilot session owns the task. Use subagents only for bounded work
that benefits from delegation; the primary session remains responsible for
approvals, changes, verification, and phase records. Do not allow concurrent
agents to edit the same files without explicit coordination.

This is a multi-module Java infrastructure repository, not a Kotlin RAG service:

- `idi-ms-application-parent`: compiler/plugin and versions/JAR/WAR parent POMs.
- `idi-ms-ng-starter-parent\idi-ms-plugin-ng`: base infrastructure library.
- `idi-ms-ng-starter-parent\idi-ms-service-ng`: shared business/base code.
- `idi-ms-ng-starter-parent\idi-ms-test-ng`: test application and integration tests.

Target exactly **Spring Boot 4.1.1 and Java 25**, migrating from Boot 3.5.7 /
Java 17. Follow existing Java, Maven, Spring MVC, JUnit, and Mockito patterns.
Do not introduce Kotlin, Spring AI, Embabel, Flyway, or Spotless requirements
from the original template.

## Migration invariants

- Preserve every existing published project groupId/artifactId and directory
  name. Correct stale references to the existing GAVs; do not rename artifacts.
- Keep `2.0.0-SNAPSHOT`; any version change requires separate approval.
- Credit initial POM/most version migration as done, pending verification.
  Do not replace it wholesale or treat declarations as proof of a working build.
- Preserve servlet MVC HTTP and required Mono/Flux/Reactor code/dependencies.
  Do not enable a reactive server or remove Reactor to fix compilation.
- Keep Jackson 2 for legacy `com.fasterxml.jackson.databind.ObjectMapper`
  consumers/integrations. Boot-managed HTTP may use Jackson 3; preserve explicit
  mapper overrides and validate converter ownership and payload contracts.
- Preserve security profile, session, filter-hook and URL-matching behavior.
  A removed matcher is not permission to broaden/restrict endpoint access.
- Verify `com.idi.ms.ng.common:common-core:2.0.0-SNAPSHOT` here. Its source is
  external; modifying it requires separate permission and repository access.
- Preserve unrelated user edits and generated/untracked content. Never infer
  build success from existing target files.

## Phase records - mandatory for repository-changing tasks

Durable source of truth:
`docs\work_current_phase.md` (current tasks),
`docs\next_phase.md` (backlog), and
`docs\complete_phases.md` (closed phases, created only after CLOSE approval).
Session plans/SQL tracking are supporting aids; keep them synchronized when
available, but new sessions must not depend on another session's private files.

Before a task:

1. Read current and backlog records.
2. Ensure a task row exists before the first source/POM/doc edit. Move backlog
   work into current when requesting intake/phase approval; do not duplicate rows.
3. Record scope, affected modules, prerequisites, gate request and planned checks.
   Set `Awaiting G<n>` or `Awaiting approval` if approval is needed; stop.
4. After explicit task/gate approval, set `In progress` before implementation.
   Update **Last reviewed** using the actual supplied/system date; ask if unknown.

After a task, before reporting: set `Completed`, `Blocked`, or `Deferred`; record
actual evidence, update **Last reviewed**, and add follow-ups to the backlog.
No code/doc-changing response ends without the matching record update.
Question-only responses need no artificial task or record edit.

Close every final response with:
`Phase records: <files>` or `Phase records: unchanged - <reason>`.

Task-row schema:

`| ID | Title | Status | Gate | Scope | Worklog | Evidence | Last reviewed |`

- Status: `Not started`, `In progress`, `Awaiting G<n>`, `Awaiting approval`,
  `Blocked`, `Completed`, or `Deferred`.
- Gate: next gate to clear, or `-`. Name supplemental gates explicitly.
- Worklog: append-only dated session entries, at most 12 words each.
  Use `<br>` between entries in a table; never rewrite historical entries.
- Evidence: four labelled lines separated by `<br>`:
  `cmds:` commands/checks and real results;
  `files:` paths touched;
  `commit:` actual hash or explicit `not created (not requested)` / `unknown`;
  `not run:` omitted checks and why, or `-` if none.
- A completed row missing any evidence label is invalid. A completed uncommitted
  task is valid when stated honestly; completion never implies permission to commit.

## Approval gates

Preserve the migration plan's existing numbering. Each gate approves only its
phase/task scope, not all later phases:

| Gate | Phase to approve |
|---|---|
| G1 | Baseline: Java/compiler, effective POM/dependency inspection, skipped-test main build |
| G2 | Parent/dependency contract verification and demonstrated corrections |
| G3 | Main-source API/compiler migration, without security-policy changes |
| G4 | Bootstrap/registration/exclusions/lifecycle and explicitly allowed startup |
| G5 | Jackson 2 / Jackson 3 coexistence and integration-boundary wiring |
| G6 | Library JAR / real WAR packaging and approved runtime/container checks |
| G7 | Test migration; explicitly authorize compilation versus execution and fixtures |
| G8 | Representative old consumer source and common-core integration verification |
| G9 | Documentation, release evidence, rollback and staged-rollout review |

Supplemental gates, not replacements for G1-G9:

- **DOC-INTAKE:** standalone tasks outside the migration phases. Present scope,
  affected layers, and rough check plan. An explicit user request/confirmation
  covering these details may serve as intake approval; record it.
- **DESIGN:** new module/dependency, new bean-wiring pattern, public API/schema,
  or intentional behavior change. Present chosen approach, one rejected
  alternative, and migration/rollback note. A phase approval covers DESIGN only
  if the presented and explicitly approved scope includes that design.
- **DELIVERY:** before any commit, merge, push, Maven deploy or publication.
  Present evidence and exact intended action; approval for commit is not push
  or deployment approval.
- **CLOSE:** before archiving a phase in `docs\complete_phases.md`. Present task
  outcomes and proposed carry-over; do not infer closure from completed rows.

At a gate, write the request into the current task record and stop for the user.
Use Copilot's question tool when available. Tool/permission grants, approval of
a plan, previous unrelated approvals, or records written by an agent do not
constitute task/gate approval. Waivers require an explicit user statement in the
current session. Never automatically advance to the next phase.

Within an approved scope, routine refactoring, formatting, comments, docs,
backlog updates and required checks do not need repeated confirmation.
Dependency patch bumps need no extra DESIGN gate if the approved phase permits
them and no API/runtime contract changes; they do not waive phase/test gates.

## Windows Maven and RTK

Before every Maven invocation in a fresh PowerShell process:

```powershell
$env:JAVA_HOME = 'C:\config\java\jdk-25'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
```

Preserve the existing Maven user home, settings, credentials, and repository
cache so internal artifacts/common-core remain resolvable. Do not set
`JAVA_TOOL_OPTIONS=-Duser.home=...`, `XDG_CONFIG_HOME`, or workspace-local
`maven.repo.local`; do not overwrite `MAVEN_ARGS` or system-wide Java settings.
If inherited options contradict the required JDK/test policy, stop and resolve
the conflict rather than silently overriding user configuration.

Wrap Maven output with RTK. Use `rtk proxy mvn ...` when exact argument
passthrough is needed; proxy avoids filtering/rewriting and accepts direct `-D`
arguments. Do not move options into MAVEN_ARGS merely to accommodate RTK.

Until explicitly authorized otherwise, **every Maven build must use
`-Dmaven.test.skip=true`**. This skips test compilation and execution.
`-DskipTests` alone is insufficient.

Example command, only after G1 approval, from the repository root:

```powershell
$env:JAVA_HOME = 'C:\config\java\jdk-25'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
rtk proxy mvn -B -Dmaven.test.skip=true -pl :idi-ms-service-spring7 -am compile
```

Use the smallest appropriate lifecycle: `compile` for main API checks,
`package` for approved JAR/WAR inspection, `install` when local consumers need
artifacts. Packaging is allowed; installation is not a substitute for tests.
Run `clean` only after reviewing its scope and existing generated content.
Run `spring-boot:run` only for explicitly authorized application checks.

At G7, distinguish permission for test compilation from permission for execution.
Use `-Dmaven.test.skip=false` only on authorized commands; use `-DskipTests=true`
additionally if an authorized install/package must compile tests but not run them.
No live-service tests without separate permission and an identified environment.

Use `rtk git status`, `rtk git diff`, and `rtk git log` with pagers disabled.
Use existing formatters only if configured; no Spotless plugin is currently
declared in repository POMs. Do not install formatting tooling just for commits.

## Phase sync and delivery

On `phase-sync`, touch no source/POM/runtime files. Read records, then inspect
`rtk git --no-pager log --since="<last-reviewed date> 00:00:00" --format=... HEAD`
using an inclusive boundary and actual commit timestamps. Compare commit hashes
to recorded evidence; dates alone are not proof of unrecorded work. Update only
phase records for demonstrable scope/outcomes and report a diff summary.
Do not infer approval or a passing build from a commit message.

When a commit is explicitly requested, prefix its message with the task ID
(for example `MIG-03: ...`), use the required Copilot co-author trailer unless
the user opts out, and stage only task-scoped files. Never commit a task still
marked `Not started`. Record the resulting hash without recursive/amended
commits merely to embed a commit's own hash in its contents.

## Verification, architecture and safety

- Follow existing infrastructure/business boundaries and shared helpers;
  avoid unrelated cleanups, broad package renames, or new abstraction layers.
- Update directly related docs/config examples for intentional contract changes.
  Do not introduce nonexistent example files or add secrets to examples.
- Add/adjust meaningful regression tests for changed behavior when authorized.
  Before authorization, record required cases as deferred; do not claim parity.
- Always distinguish compilation, packaging, startup, executed tests, and external
  integrations. State omitted checks and reasons in evidence and the final report.
  Zero executed tests, disabled tests and missing fixtures are not a pass.
- Do not start/stop/configure application servers, databases, Docker, or IDEs
  without explicit approval. Announce approved runtime work before executing it.
  Stop only dedicated processes created for the task, identified by PID.
- Do not edit secrets, `.env`, credentials, keystores, or secret-bearing config
  without explicit permission. Do not log or copy credentials into records.
- Do not purge shared Maven caches, reset/revert unrelated work, or edit external
  repositories by inference. Escalate unavailable artifacts/fixtures explicitly.
