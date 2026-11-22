#!/usr/bin/env bash
# Tests for code/67_q3.rkt (S1: binary tree traversals and statistics).
# Run from anywhere: bash tests/test_q3.sh   (or through tests/run_all.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1
source tests/lib.sh

FILE=code/67_q3.rkt

rkt() {
    run_rkt "$FILE" "$1" 2>&1 | tr -d '\r'
}

COMMON_TREES='
(define t1 '\''(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '\''(1 () (2 () (3 () ()))))
(define t3 '\''(a (b () ()) (c () ())))
(define t_empty '\''())
(define t_single '\''(5 () ()))
'

# (1) print-inorder on t1 gives "(1 2 3 4 5 6 7)"
check "print-inorder on t1 gives (1 2 3 4 5 6 7)" "(1 2 3 4 5 6 7)" \
    "$(rkt "$COMMON_TREES (print-inorder t1)")"

# (2) print-all-traversals on t1 gives the three lines:
# (1 2 3 4 5 6 7), (4 2 1 3 6 5 7), (1 3 2 5 7 6 4)
T1_EXP=$(printf "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)")
check "print-all-traversals on t1" "$T1_EXP" \
    "$(rkt "$COMMON_TREES (print-all-traversals t1)")"

# (3) print-all-traversals on t2 gives (1 2 3), (1 2 3), (3 2 1)
T2_EXP=$(printf "(1 2 3)\n(1 2 3)\n(3 2 1)")
check "print-all-traversals on t2" "$T2_EXP" \
    "$(rkt "$COMMON_TREES (print-all-traversals t2)")"

# (4) print-all-traversals on t3 gives (b a c), (a b c), (b c a)
T3_EXP=$(printf "(b a c)\n(a b c)\n(b c a)")
check "print-all-traversals on t3" "$T3_EXP" \
    "$(rkt "$COMMON_TREES (print-all-traversals t3)")"

# (5) print-all-traversals on the empty tree: all three lines are ()
EMPTY_EXP=$(printf "()\n()\n()")
check "print-all-traversals on empty tree" "$EMPTY_EXP" \
    "$(rkt "$COMMON_TREES (print-all-traversals t_empty)")"

# (6) print-height-and-leaves gives (3 4) for t1, (3 1) for t2, (2 2) for t3, (0 0) for empty tree
check "print-height-and-leaves on t1" "(3 4)" \
    "$(rkt "$COMMON_TREES (print-height-and-leaves t1)")"

check "print-height-and-leaves on t2" "(3 1)" \
    "$(rkt "$COMMON_TREES (print-height-and-leaves t2)")"

check "print-height-and-leaves on t3" "(2 2)" \
    "$(rkt "$COMMON_TREES (print-height-and-leaves t3)")"

check "print-height-and-leaves on empty tree" "(0 0)" \
    "$(rkt "$COMMON_TREES (print-height-and-leaves t_empty)")"

# (7) Long left-leaning tree of depth 5000 to check it does not crash
DEEP_SNIPPET='
(define (make-deep n)
  (let loop ((k n) (t '\''()))
    (if (= k 0)
        t
        (loop (- k 1) (list k t '\''())))))
(define deep-tree (make-deep 5000))
(display (tree-height deep-tree))
(newline)
'
check "depth 5000 left-leaning tree height does not crash" "5000" \
    "$(rkt "$DEEP_SNIPPET")"

# (8) Loading file prints nothing
check "loading code/67_q3.rkt prints nothing" "" \
    "$(rkt "")"

echo
if [ "$FAILURES" -eq 0 ]; then
    echo "test_q3: all checks passed"
else
    echo "test_q3: $FAILURES check(s) failed"
fi
