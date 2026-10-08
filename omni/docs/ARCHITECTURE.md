# JARVIS OS (Codename: OMNISYNC) - Architecture Specification

## 1. System Vision
JARVIS OS is a Debian/Ubuntu-based operating system where an autonomous, offline AI engine is integrated into the core OS infrastructure rather than operating as a user application.

## 2. Core Boundary Rules
- **Kernel Space (Ring 0):** Senses and enforces only. Hosts eBPF probes, cgroups v2 resource controllers, namespaces, seccomp filters, and the authenticated `omni_chan` communication channel. No model inference, vector math, or planning runs in the kernel.
- **Userspace (Ring 3):** Cognition, scheduling, and task management. Runs `omni-autonomicd`, the deterministic task engine, and the quantized local model runtime.

## 3. Triad Safety Engine
All AI-driven actions follow the strict sequence:
1. **AI Proposes:** Emits a typed, schema-validated tool RPC.
2. **Policy Approves:** Validates against capability tokens, path boundaries, and risk tiers (A: Reflex, B: State change with snapshot, C: Destructive requiring human confirmation).
3. **Kernel Enforces:** Dispatched to unshare sandboxes and cgroups v2 slices. The AI never receives an unrestricted root shell.
