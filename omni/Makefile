# ==============================================================================
# JARVIS OS (OMNISYNC) - Master Build & Orchestration Makefile
# ==============================================================================
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: help setup p0-build p0-test gate-p0 status clean

help:
	@echo "======================================================================"
	@echo "JARVIS OS (OMNISYNC) - Phase Orchestrator"
	@echo "======================================================================"
	@echo "Targets:"
	@echo "  setup      - Install host build tools, kernel headers, QEMU, live-build"
	@echo "  p0-build   - Compile Phase 0 LKM (hello_omni) and eBPF probe (hello.bpf)"
	@echo "  p0-test    - Run headless QEMU harness / local evaluation runner"
	@echo "  gate-p0    - Run strict omni-gate verification and sign STATUS.md"
	@echo "  status     - Display current STATUS.md ledger"
	@echo "  clean      - Clean build artifacts across all submodules"

setup:
	@bash $(ROOT_DIR)/tools/setup_dev_env.sh

p0-build:
	@echo "[*] Compiling Phase 0 Kernel Verification Module..."
	$(MAKE) -C $(ROOT_DIR)/kernel/lkm/hello
	@echo "[*] Compiling Phase 0 eBPF Bytecode..."
	$(MAKE) -C $(ROOT_DIR)/kernel/bpf/hello

p0-test: p0-build
	@echo "[*] Running Phase 0 Baseline Evaluation Harness..."
	python3 $(ROOT_DIR)/evals/runner.py $(ROOT_DIR)/evals/suites/p0_baseline.json

gate-p0: p0-build
	@python3 $(ROOT_DIR)/tools/omni-gate run P0

status:
	@python3 $(ROOT_DIR)/tools/omni-gate status

clean:
	@$(MAKE) -C $(ROOT_DIR)/kernel/lkm/hello clean || true
	@$(MAKE) -C $(ROOT_DIR)/kernel/bpf/hello clean || true
	@rm -rf $(ROOT_DIR)/build /tmp/omni_qemu_test.log
