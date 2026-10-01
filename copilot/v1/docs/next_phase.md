# Migration backlog

**Target:** exactly Spring Boot 4.1.1 / Java 25, from Boot 3.5.7 / Java 17.
**Last reviewed:** 2026-10-01.
**Source:** the migration plan created on 2026-09-30 and subsequent explicit
user decisions. These durable records summarize that session plan; they do not
grant any implementation approval.

Initial POM/most version changes are **done, pending verification**, recorded as
MIG-POM-00 in `work_current_phase.md`. All phases below remain unstarted.

## Tasks and actual prerequisites

Move a task row to `work_current_phase.md` when requesting its gate. Record the
request and set `Awaiting G<n>` before implementation; after explicit approval,
record it and set `In progress`. Do not duplicate authoritative task rows.

| ID | Title | Status | Gate | Scope | Worklog | Evidence | Last reviewed |
|---|---|---|---|---|---|---|---|
| MIG-01 | Reproduce build/dependency baseline | Not started | G1 | Approve baseline inspection and local Maven cache writes; verify JDK/forked javac, effective POMs, profiles, actual dependency versions, common-core resolution, and root-reactor service main compilation with tests skipped. Prerequisite: MIG-PLAN-00. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: baseline commands; G1 implementation approval absent | 2026-10-01 |
| MIG-02 | Verify parent/dependency contracts | Not started | G2 | Preserve completed migration; correct stale references to existing com.idi.ms.ng.plugins GAVs, verify versions/JAR/WAR inheritance, Boot modules/BOM, legacy Jackson dependencies and Java 25 processors. Prerequisite: MIG-01. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: changes and verification; G2 approval and baseline absent | 2026-10-01 |
| MIG-03 | Restore main-source compilation | Not started | G3 | Boot 4 PathRequest import/module, semantics-preserving replacement of removed Ant matcher, minimal Jackson 2/3 type alignment and demonstrated main API fixes. Verify complete main compilation and bytecode major 69. Prerequisite: MIG-02. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: compilation/fixes; G3 approval and dependency baseline absent | 2026-10-01 |
| MIG-04 | Restore bootstrap/runtime contracts | Not started | G4 | Supported auto-configuration imports, environment-postprocessor exclusion names, applicable Jakarta lifecycle callbacks, optional-infrastructure-off startup and narrow-scan discovery. Prerequisite: MIG-03; runtime checks need explicit permission. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: changes/startup; G4 approval and runtime permission absent | 2026-10-01 |
| MIG-05 | Complete Jackson coexistence | Not started | G5 | Preserve legacy ObjectMapper/overrides, permit Boot-managed Jackson 3 HTTP, establish converter ownership and compatibility contracts for MVC/clients/Redis/Rabbit/rule engine/common-core DTOs. Prerequisites: MIG-02, MIG-03, MIG-04. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: wiring/behavior checks; G5 approval and prerequisites absent | 2026-10-01 |
| MIG-06 | Verify library JAR and true WAR output | Not started | G6 | Real test WAR and servlet initialization; provided container/API scopes, ordinary consumable library JARs, approved package/install and startup. Prerequisites: MIG-04, MIG-05; confirm external container/version first. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: packaging/startup; G6 approval and container details absent | 2026-10-01 |
| MIG-07 | Migrate and authorize tests | Not started | G7 | Separately authorize test compilation/execution; migrate test APIs/Mockito annotations/MVC fixtures; assert security/JSON/Reactor/bootstrap and permitted integrations; inspect actual counts/exclusions/coverage. Prerequisites: MIG-03, MIG-04, MIG-05, MIG-06. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: all tests; explicit test authorization and G7 prerequisites absent | 2026-10-01 |
| MIG-08 | Verify existing consumers/common-core | Not started | G8 | Representative WAR, library JAR, versions-only, plugin-only and service consumers; old source/business contracts on Java 25; resolved common-core API/runtime and serialized formats. Prerequisites: MIG-06, MIG-07; external source edits need separate approval. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: consumer validation; G8 approval, consumer projects, and fixtures absent | 2026-10-01 |
| MIG-09 | Document and review staged rollout | Not started | G9 | Update related docs; inspect final diffs/evidence; trace mutable snapshots and rollback inputs; publish/stage/commit only if separately authorized. Prerequisite: MIG-08. | 2026-10-01 - Imported unstarted phase from approved planning scope. | cmds: not run<br>files: none<br>commit: not created<br>not run: rollout/publication; G9 and separate delivery approval absent | 2026-10-01 |

## Gate-specific decisions to collect

- G1: approve the baseline commands/cache writes. Existing settings and repository
  cache stay in use; do not isolate user.home or change repository configuration.
- G2/G3: present demonstrated dependency/API changes. Any new dependency,
  bean-wiring pattern, public API or matching-policy change also requires DESIGN.
  A phase approval may cover DESIGN only if its explicit scope covers that design.
- G4/G6: authorize dedicated local startup checks and identify the target external
  servlet container/version. No app/DB/Docker/IDE process changes by inference.
- G7: specify test compilation versus execution and allowed fixtures independently.
  Until explicit authorization, use `-Dmaven.test.skip=true` on all Maven builds.
- G8: identify representative old consumers and baseline outputs; no source access
  or changes in external common-core without explicit permission.
- G9: explicitly approve any publication/rollout. DELIVERY separately controls
  commit/merge/push; CLOSE controls writing `complete_phases.md`.

## Compatibility acceptance

- Existing project groupIds/artifactIds and `2.0.0-SNAPSHOT` remain unchanged.
  Correct stale references rather than rename published modules.
- Verify actual Boot 4.1.1 resolution and Java 25 bytecode. Old source compatibility
  does not mean Java 25 artifacts can run on Java 17.
- Preserve MVC HTTP and required Mono/Flux/Reactor behavior; no reactive server
  migration or removal of Reactor.
- Preserve legacy Jackson 2 mapper/integration contracts while allowing
  Boot-managed Jackson 3 HTTP. Confirm converter ordering and accepted payload
  differences; no global switch to Jackson 2 by default.
- Preserve existing any-depth login/verify/logLevel matching and profile/filter
  behavior. Do not copy unsupported `/**/suffix` syntax into PathPattern.
- Main compilation, correct archives, startup, meaningful authorized tests,
  common-core integration and each consumer matrix row need separate evidence.
  Missing fixtures, deferred tests or zero executed tests are not successful
  behavior validation; record them as blocked/deferred.

## Deferred follow-ups

No additional out-of-scope follow-ups identified during instruction adaptation.
Append discovered work here; changing the backlog does not approve execution.
