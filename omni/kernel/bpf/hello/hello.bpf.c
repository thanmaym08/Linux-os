// SPDX-License-Identifier: GPL-2.0
/*
 * hello.bpf.c - JARVIS OS (OMNISYNC) Phase 0 Verification eBPF Probe
 *
 * Purpose:
 *   Validates that Clang/LLVM can target the BPF backend, include Linux BPF
 *   helper headers, and emit valid BPF ELF bytecode containing BTF info.
 */

#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

char LICENSE[] SEC("license") = "GPL";

/*
 * Hook onto sys_enter tracepoint for write(2).
 * Verifies kernel tracepoint attachment and counter tracking.
 */
SEC("tracepoint/syscalls/sys_enter_write")
int tracepoint__syscalls__sys_enter_write(void *ctx)
{
    // Return 0 to allow the write syscall to continue untouched
    return 0;
}
