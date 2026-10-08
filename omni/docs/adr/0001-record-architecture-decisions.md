# ADR 0001: Record Architecture Decisions and System Boundaries

## Status
Accepted

## Context
JARVIS OS requires strict architectural discipline across 16 implementation phases (P0 to P15). We must establish immutable boundaries to prevent scope creep, kernel destabilization, or unsafe execution patterns.

## Decision
1. **Kernel/Userspace Separation:** The kernel provides telemetry (eBPF) and enforcement (cgroups v2, LSM, seccomp). No AI inference or cognitive code will ever run in Ring 0.
2. **Deterministic Precedence:** The task engine, verification framework, policy ledger, and watchdog must run deterministically. LLMs act solely as advisory planners and tool-call generators.
3. **Verification Gates:** No phase is marked `WORKING` without passing an automated verification gate executed by `tools/omni-gate` on real Linux and recorded with cryptographic evidence in `STATUS.md`.

## Consequences
- Every new capability requires a corresponding test and gate check.
- System stability is preserved even if the local model produces malformed or hallucinated tool arguments.
