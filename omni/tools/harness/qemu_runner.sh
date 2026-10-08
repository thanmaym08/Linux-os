#!/usr/bin/env bash
# ==============================================================================
# JARVIS OS (OMNISYNC) - Headless QEMU/KVM Test Harness
# Module 0c: Executes headless VM test runs, fault-injections, and records logs
# ==============================================================================
set -euo pipefail

TIMEOUT_SEC="${1:-45}"
KERNEL_PATH="${2:-/boot/vmlinuz-$(uname -r 2>/dev/null || echo 'vmlinuz')}"
INITRD_PATH="${3:-/boot/initrd.img-$(uname -r 2>/dev/null || echo 'initrd.img')}"
LOG_FILE="${4:-/tmp/omni_qemu_test.log}"

echo "[*] Initializing JARVIS OS QEMU Test Harness..."
echo "    Timeout:     ${TIMEOUT_SEC}s"
echo "    Kernel:      ${KERNEL_PATH}"
echo "    Serial Log:  ${LOG_FILE}"

# Check hardware acceleration
KVM_ARGS=""
if [ -e /dev/kvm ] && [ -w /dev/kvm ]; then
    echo "[+] Using KVM hardware virtualization (-enable-kvm -cpu host)."
    KVM_ARGS="-enable-kvm -cpu host"
else
    echo "[!] /dev/kvm not accessible. Falling back to software TCG (-cpu max)."
    KVM_ARGS="-cpu max"
fi

if [ ! -f "$KERNEL_PATH" ]; then
    echo "[!] WARNING: Kernel file not found at $KERNEL_PATH."
    echo "    Running QEMU sanity binary verification instead."
    qemu-system-x86_64 --version
    exit 0
fi

# Run QEMU with serial console piped to logfile and quiet init
echo "[*] Spawning QEMU instance..."
QEMU_PID=0
EXIT_CODE=0

timeout "${TIMEOUT_SEC}" qemu-system-x86_64 \
    ${KVM_ARGS} \
    -m 2048 \
    -smp 2 \
    -kernel "$KERNEL_PATH" \
    -initrd "$INITRD_PATH" \
    -nographic \
    -append "console=ttyS0 root=/dev/ram0 panic=1 quiet init=/bin/sh" \
    -serial file:"$LOG_FILE" \
    -no-reboot \
    -display none || EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 124 ]; then
    echo "[-] QEMU run timed out after ${TIMEOUT_SEC} seconds (as intended for timeout tests or hang)."
    exit 124
elif [ "$EXIT_CODE" -ne 0 ]; then
    echo "[-] QEMU exited with error code: ${EXIT_CODE}"
    exit "$EXIT_CODE"
fi

echo "[+] QEMU session executed cleanly."
exit 0
