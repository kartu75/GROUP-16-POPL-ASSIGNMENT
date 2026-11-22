#!/usr/bin/env bash

# run_all.sh
# Runs every tests/test_q*.sh in order and exits non-zero if any failed.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT" || exit 1

shopt -s nullglob
TEST_FILES=("$SCRIPT_DIR"/test_q*.sh)

if [ ${#TEST_FILES[@]} -eq 0 ]; then
    echo "No tests found matching tests/test_q*.sh"
    exit 0
fi

FAILED=0

for test_script in "${TEST_FILES[@]}"; do
    test_name="$(basename "$test_script")"
    echo "=== Running $test_name ==="

    if ! bash "$test_script"; then
        FAILED=1
        echo "FAILED: $test_name"
    fi
    echo ""
done

if [ "$FAILED" -ne 0 ]; then
    echo "Test suite failed."
    exit 1
fi

echo "All tests passed."
exit 0
