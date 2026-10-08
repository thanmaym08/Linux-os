# Linux-os: JARVIS OS (OMNISYNC)

An autonomous, offline-first Debian/Ubuntu-based Linux operating system where local AI is integrated into the kernel and system service plumbing.

## Architecture Highlights
- **Kernel/Userspace Separation:** Kernel provides senses (eBPF telemetry, PSI) and enforcement (cgroups v2, namespaces, LSM, seccomp). No AI inference runs in Ring 0.
- **Autonomic Nervous System:** Dual-tier architecture featuring `omni-autonomicd` (sub-millisecond reflexes) and a Deliberative Cortex (local quantized LLM + symbolic planner).
- **Triad Safety Model:** AI Proposes -> Policy Engine Approves -> Kernel Enforces. No raw root shell.
- **Verification-Gated:** Managed via `tools/omni-gate` and recorded cryptographically in `STATUS.md`.

## Repository Structure
```
omni/
├── .github/workflows/       # CI pipelines
├── docs/                    # Architecture specs and ADRs
├── evals/                   # Evaluation suites and test runner
├── kernel/                  # eBPF probes and out-of-tree verification LKM
├── tools/                   # omni-gate CLI, QEMU harness, host setup scripts
├── Makefile                 # Master build engine
└── STATUS.md                # Cryptographic verification ledger
```
