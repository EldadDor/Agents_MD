# AGENTS.md — RAG Dev Plane

Two Codex agents work in this repository: **backend** (`src/`, `tests/`,
`database/`, Python config) and **frontend** (`frontend/`). Stay in your area.
Shared documentation lives in `docs/`. If a nested `AGENTS.md` exists in your
working directory, it refines (never cancels) the rules below.

## Phase records — MANDATORY on every task

The phase records are the single source of truth for what is being worked on
and what comes next. Keeping them current is part of every task, not a separate
request. Only an explicit user instruction (e.g. "don't touch the phase docs")
suspends this rule; a prompt that says nothing about them does **not**.

| Area | Current phase | Backlog |
| --- | --- | --- |
| Backend | `docs/work_current_phase.md` | `docs/next_phase.md` |
| Frontend | `docs/frontend/work_current_phase.md` | `docs/frontend/next_phase.md` |

**Before starting a task**
1. Read both files for your area.
2. Set the task row to **In progress** with the intended scope and any approval
   dependency. Update **Last reviewed**.

**After finishing a task — before you report back to the user**
1. Set the row to **Completed**, **Blocked**, or **Deferred** with concrete
   evidence: commands run and results, files touched, and what was *not* run.
2. Update **Last reviewed**.
3. Add newly discovered follow-ups or scope changes to `next_phase.md`.
4. When a whole phase closes, add its record to `docs/complete_phases.md`.

Never end a response that changed code or docs without the matching
phase-record update. Close each response with a line
`Phase records: <file(s) updated>` or `Phase records: unchanged — <reason>`.

## Cross-team handoff — secondary

`docs/agent_handoff/` is for information that crosses the backend/frontend
boundary (features, bugs, API changes, clarifications, validation results,
blockers). Read it when the user asks, or when your task depends on or changes
the other side's contract. Write to your direction-specific file
(`backend_to_frontend.md` or `frontend_to_backend.md`); record approvals in
`decisions.md`. Follow the template in its `README.md`; newest entry first;
never rewrite earlier entries. A handoff entry is **never** a substitute for the
phase-record update above.

`docs/frontend_architecture.md` is the authoritative API contract. The backend
owns contract decisions; the frontend proposes and requests.

## Safety

- Do not start, stop, or configure Uvicorn, Ollama, PostgreSQL/pgvector,
  Docker, or IDEs unless the user explicitly asks. Announce first.
- Do not edit `.env`, credentials, or secrets unless explicitly asked.
- Do not run tests that contact live services without prior approval.
- Run the smallest relevant static check or test when permitted; always state
  what was not run.

## Precedence

Explicit user prompt > this file (plus nested `AGENTS.md`) > phase records >
handoff entries > other docs.

---

# Backend area rules (ignore when working in `frontend/`)

## Stack baseline
- Python 3.14, `uv` for dependency management and execution
- FastAPI, Pydantic v2
- PostgreSQL + pgvector as the default vector store; Qdrant remains supported
- OpenAI-compatible chat provider; Ollama embedding provider
- Pytest; Docker and Docker Compose for local infrastructure

## Current provider defaults
- Chat model: `qwen2.5:7b-instruct-q4_K_M` via `CHAT_BASE_URL`
- Embedding model: `nomic-embed-text` (768 dimensions) via `EMBEDDING_BASE_URL`
- Vector store: pgvector (`rag.document_chunks`, 768 dimensions, cosine distance)

## Architecture rules
- Keep chat generation and embedding generation in separate client adapters.
- Retrieval depends on the embedding client, not the chat client; answer
  synthesis depends on the chat client, not the embedding client.
- Vector-store records must preserve provenance-rich metadata.
- Prompt templates are centrally managed and reused.
- Database objects are created by versioned SQL in `database/migrations`, never
  by application startup.

## Delivery rules
- Preserve the dual-provider model unless explicitly asked to unify it.
- Add new providers behind the existing adapter pattern.
- Update `.env.example`, docs, and tests whenever provider configuration changes.
- Keep the default local embedding path working without cloud calls.