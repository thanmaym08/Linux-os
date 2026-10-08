# Makefile for Phase 0 eBPF probe
CLANG ?= clang
LLVM_STRIP ?= llvm-strip
BPF_TARGET := bpf

# Architecture detection
ARCH := $(shell uname -m | sed 's/x86_64/x86/' | sed 's/aarch64/arm64/')

INCLUDES := -I/usr/include -I/usr/include/$(shell uname -m)-linux-gnu

CFLAGS := -g -O2 -target $(BPF_TARGET) -D__TARGET_ARCH_$(ARCH) $(INCLUDES)

.PHONY: all clean

all: hello.bpf.o

hello.bpf.o: hello.bpf.c
	$(CLANG) $(CFLAGS) -c $< -o $@
	$(LLVM_STRIP) -g $@

clean:
	rm -f hello.bpf.o
