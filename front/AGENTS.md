# Frontend Agent Instructions

The root `AGENTS.md` phase-record rule applies here without exception. For this
area the files are `../docs/frontend/work_current_phase.md` and
`../docs/frontend/next_phase.md`. Update them before and after every task,
whether or not the prompt mentions them, unless the user explicitly says not to.

## Scope

Work only inside `frontend/**` unless the user explicitly asks to change a
// ... existing code ...
## Validation

- Run frontend type checks, tests, and production builds when the user permits.
- Do not start Uvicorn or use live model/database services unless explicitly
  approved.
- A task is not complete until its row in
  `../docs/frontend/work_current_phase.md` records the result and evidence.