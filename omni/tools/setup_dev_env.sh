#!/usr/bin/env bash
# ==============================================================================
# JARVIS OS (OMNISYNC) - Phase 0 Development Environment Setup
# Target: Native Debian 12 / Ubuntu 24.04 LTS x86_64 or WSL2 with custom kernel
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "JARVIS OS: Installing Phase 0 Host Toolchain and Prerequisites"
echo "======================================================================"

# 1. Ensure apt is non-interactive
export DEBIAN_FRONTEND=noninteractive

# 2. Base toolchain, kernel build dependencies, eBPF & tracing tools
echo "[*] Updating package repositories..."
sudo apt-get update -y

echo "[*] Installing core build toolchain and kernel headers..."
sudo apt-get install -y --no-install-recommends \
    build-essential \
    linux-headers-"$(uname -r)" \
    clang \
    llvm \
    lld \
    libbpf-dev \
    libelf-dev \
    bpftool \
    pkg-config \
    libdbus-1-dev \
    libssl-dev \
    bison \
    flex \
    dkms

echo "[*] Installing virtualization, packaging, and filesystem utilities..."
sudo apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    ovmf \
    live-build \
    debootstrap \
    btrfs-progs \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi

echo "[*] Installing runtime scripting and testing dependencies..."
sudo apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    stress-ng \
    curl \
    git \
    tree

# 3. Rust toolchain (MSRV 1.78+)
if ! command -v cargo &> /dev/null; then
    echo "[*] Installing Rust toolchain via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    # Source for current shell session
    source "$HOME/.cargo/env"
else
    echo "[+] Rust toolchain is already installed: $(cargo --version)"
fi

# 4. Verification of KVM Virtualization
echo "======================================================================"
echo "Virtualization Hardware Check:"
if [ -e /dev/kvm ] && [ -w /dev/kvm ]; then
    echo "  [+] KVM hardware acceleration is available and writable (/dev/kvm)."
else
    echo "  [!] WARNING: /dev/kvm is missing or not writable by current user."
    echo "      Ensure nested virtualization is enabled in BIOS / VM hypervisor."
    echo "      QEMU tests will fall back to software emulation TCG."
fi

# 5. Kernel options verification for eBPF, BTF, cgroups v2
echo "Kernel Subsystem Compatibility Check:"
CURRENT_KERNEL=$(uname -r)
echo "  Kernel: $CURRENT_KERNEL"
if [ -f "/sys/kernel/btf/vmlinux" ]; then
    echo "  [+] BPF Type Format (BTF) is present at /sys/kernel/btf/vmlinux."
else
    echo "  [!] WARNING: /sys/kernel/btf/vmlinux missing. CO-RE eBPF probes will require kernel headers."
fi

if grep -q "cgroup2" /proc/filesystems; then
    echo "  [+] cgroups v2 support is active."
else
    echo "  [!] WARNING: cgroups v2 is not active in this kernel."
fi

echo "======================================================================"
echo "Phase 0 Environment Setup Complete."
echo "======================================================================"
