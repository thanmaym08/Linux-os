// SPDX-License-Identifier: GPL-2.0
/*
 * hello_omni.c - JARVIS OS (OMNISYNC) Phase 0 Verification Kernel Module
 *
 * Purpose:
 *   Validates that the host/VM kernel development headers, compiler flags,
 *   DKMS infrastructure, and out-of-tree module loading/unloading mechanics
 *   operate cleanly before building the privileged omni_chan driver in Phase 3b.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/version.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("JARVIS OS Principal Systems Architect");
MODULE_DESCRIPTION("JARVIS OS / OMNISYNC - Phase 0 Verification LKM");
MODULE_VERSION("0.1.0");

static int __init hello_omni_init(void)
{
    pr_info("[OMNISYNC-KERNEL] Phase 0 Verification Module loaded successfully.\n");
    pr_info("[OMNISYNC-KERNEL] Kernel release: %s\n", UTS_RELEASE);
    pr_info("[OMNISYNC-KERNEL] Memory & Execution Boundary: Ring 0 Active.\n");
    return 0;
}

static void __exit hello_omni_exit(void)
{
    pr_info("[OMNISYNC-KERNEL] Phase 0 Verification Module unloaded cleanly.\n");
}

module_init(hello_omni_init);
module_exit(hello_omni_exit);
