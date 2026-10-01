# Current phase

**Phase:** Copilot CLI instruction and record bootstrap (documentation only).
**Last reviewed:** 2026-10-01.
**Approval:** On 2026-10-01 the user approved a root AGENTS.md for this Java
migration, docs-based records initialized from the existing plan, preservation of
Maven settings/cache, and preservation of G1-G9 with separate supplemental gates.
This approval does not authorize migration Phase 1, tests, runtime, or publication.
**Phase close:** Not requested or approved; completed rows remain here until CLOSE.

## Tasks

Evidence cells use four labelled lines separated by `<br>`. A missing commit is
recorded honestly, not treated as an instruction to create one.

| ID | Title | Status | Gate | Scope | Worklog | Evidence | Last reviewed |
|---|---|---|---|---|---|---|---|
| MIG-DOC-01 | Adapt instructions for Copilot CLI | Completed | - | Root AGENTS.md, phase-record bootstrap, and session-plan synchronization only. User approved DOC-INTAKE on 2026-10-01. No Java/POM edits or builds. | 2026-10-01 - Adapting Copilot instructions and initializing migration phase records. | cmds: Copilot CLI help confirms root AGENTS.md loading; rtk proxy --help confirms passthrough; POM search finds no Spotless; PowerShell documentation checks pass for 12 unique rows, 8 columns, evidence labels, dates, ASCII and preserved unstarted G1-G9; rtk git status shows only task docs added alongside pre-existing untracked content<br>files: AGENTS.md; docs\work_current_phase.md; docs\next_phase.md; session plan.md and task tracking synchronized<br>commit: not created (not requested)<br>not run: Maven builds/tests/runtime; documentation-only task and migration gates remain pending; phase archive not created because CLOSE was not authorized | 2026-10-01 |
| MIG-POM-00 | Initial POM and version migration | Completed | - | Historical user work: Boot 4.1.1, Java 25, stable renamed coordinates and most version updates. Implementation credited as done; verification is still backlog work. | 2026-09-30 - Recorded existing POM migration; verification remains pending. | cmds: POM/source inspection confirms target declarations; no successful build inferred<br>files: existing parent/module POMs (user work; unchanged by this task)<br>commit: unknown (historical work; not supplied)<br>not run: fresh compilation, dependency resolution, runtime, and consumer tests; reserved for gated migration phases | 2026-10-01 |
| MIG-PLAN-00 | Analyze migration and establish gated plan | Completed | - | Historical planning only: parent topology, compiler/security/Jackson/bootstrap/packaging risks; nine phase gates. Detailed plan retained in the originating Copilot session. | 2026-09-30 - Analyzed migration surfaces and saved nine-phase implementation plan. | cmds: direct POM/source/resource inspection; rtk mvn -version confirmed Maven 3.9.6 on Java 25<br>files: session plan.md and session task tracking (outside repository)<br>commit: not created (planning only; not requested)<br>not run: compilation, packaging, install, tests, or runtime; no implementation phase was approved | 2026-10-01 |

## Next approval

MIG-01 remains in `docs\next_phase.md`, awaiting **G1**. Present its scope,
affected modules, Java 25/skipped-test commands, and expected evidence before
moving it into an active implementation phase. Do not execute it as a follow-up
to this documentation task.
