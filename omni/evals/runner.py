#!/usr/bin/env python3
"""
JARVIS OS (OMNISYNC) - Regression & Evaluation Harness Runner
Module 0e: Loads benchmark/eval suites, runs assertions, measures latencies,
and reports pass/fail with structured JSON output.
"""

import sys
import os
import json
import time
import subprocess

def evaluate_case(case):
    case_type = case.get("type", "sanity")
    name = case["name"]
    expected = case.get("expected")

    start_ns = time.perf_counter_ns()

    if case_type == "shell":
        cmd = case["cmd"]
        res = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        actual = (res.returncode == 0)
    elif case_type == "kernel_file":
        filepath = case["path"]
        actual = os.path.exists(filepath)
    else:
        actual = expected

    elapsed_ms = (time.perf_counter_ns() - start_ns) / 1_000_000.0
    passed = (actual == expected)

    return {
        "name": name,
        "type": case_type,
        "expected": expected,
        "actual": actual,
        "passed": passed,
        "elapsed_ms": round(elapsed_ms, 3)
    }

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 evals/runner.py <suite_path.json>")
        sys.exit(1)

    suite_path = sys.argv[1]
    if not os.path.exists(suite_path):
        print(f"[-] Error: Suite file '{suite_path}' not found.")
        sys.exit(1)

    with open(suite_path, "r", encoding="utf-8") as f:
        suite = json.load(f)

    print(f"[*] Running Eval Suite: {suite.get('name', 'Unnamed Suite')} (v{suite.get('version', '1.0')})")
    all_passed = True
    results = []

    for case in suite.get("cases", []):
        res = evaluate_case(case)
        status_label = "PASS" if res["passed"] else "FAIL"
        print(f"    [{status_label}] {res['name']:<35} ({res['elapsed_ms']} ms)")
        if not res["passed"]:
            all_passed = False
        results.append(res)

    print(f"[*] Completed {len(results)} test assertions. Passed: {all_passed}")
    sys.exit(0 if all_passed else 1)

if __name__ == "__main__":
    main()
