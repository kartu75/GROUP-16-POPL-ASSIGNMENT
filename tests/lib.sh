#!/usr/bin/env bash

# Failure counter
FAILURES=0

# check NAME EXPECTED ACTUAL
# Prints PASS NAME or FAIL NAME with the expected and actual values, and counts failures.
check() {
    local name="$1"
    local expected="$2"
    local actual="$3"

    if [ "$expected" = "$actual" ]; then
        printf "PASS %s\n" "$name"
    else
        FAILURES=$((FAILURES + 1))
        printf "FAIL %s\n" "$name"
        printf "  expected: %s\n" "$expected"
        printf "  actual:   %s\n" "$actual"
    fi
}

# run_pl FILE GOAL
# Runs swipl -q -f FILE -g "GOAL" -t halt
run_pl() {
    local file="$1"
    local goal="$2"
    swipl -q -f "$file" -g "$goal" -t halt
}

# run_rkt FILE CALLS_STRING [STDIN]
# Copies FILE to a temp file, appends CALLS_STRING to the end,
# and runs racket on the temp file, feeding STDIN if given.
run_rkt() {
    local file="$1"
    local calls_string="$2"
    local stdin_input="${3:-}"

    local tmp
    tmp="$(mktemp /tmp/rkt_test_XXXXXX.rkt)"
    cp "$file" "$tmp"
    printf "\n%s\n" "$calls_string" >> "$tmp"

    local ret=0
    if [ $# -ge 3 ]; then
        printf "%s\n" "$stdin_input" | racket "$tmp" || ret=$?
    else
        racket "$tmp" || ret=$?
    fi
    rm -f "$tmp"
    return $ret
}

# Ensure that any test script sourcing lib.sh exits non-zero if FAILURES > 0
if [ -n "${BASH_VERSION:-}" ]; then
    trap 'exit_code=$?; if [ "$exit_code" -ne 0 ]; then exit "$exit_code"; elif [ "${FAILURES:-0}" -gt 0 ]; then exit 1; fi' EXIT
fi
