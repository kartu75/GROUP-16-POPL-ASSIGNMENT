#!/usr/bin/env bash
# Tests for code/67_q4.rkt (S2: insert-if-short and make-inserter).
# Run from anywhere: bash tests/test_q4.sh (or through tests/run_all.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1
source tests/lib.sh

ID="${GROUP_ID:-67}"
FILE="code/${ID}_q4.rkt"

rkt() {
    run_rkt "$FILE" "$1" "${2:-}" 2>&1 | tr -d '\r'
}

# (1) print-insert-result cases via stdin
OUT1="$(rkt '(print-insert-result)' '42 ((1 2) (3 4 5) (6) ()) 3')"
check "print-insert-result case 1" "((42 1 2) (3 4 5) (42 6) (42))" "$OUT1"

OUT2="$(rkt '(print-insert-result)' '0 (((1) 2) (3) ((4 5 6) ())) 3')"
check "print-insert-result case 2" "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))" "$OUT2"

OUT3="$(rkt '(print-insert-result)' '7 () 3')"
check "print-insert-result case 3 (empty list n=3)" "(7)" "$OUT3"

OUT4="$(rkt '(print-insert-result)' '7 () 0')"
check "print-insert-result case 4 (empty list n=0)" "()" "$OUT4"

# (2) x is a symbol
OUT5="$(rkt '(print-insert-result)' 'a (b) 2')"
check "x is a symbol (a (b) 2)" "(a b)" "$OUT5"

OUT5B="$(rkt '(print-insert-result)' 'a ((b)) 2')"
check "x is a symbol nested (a ((b)) 2)" "(a (a b))" "$OUT5B"

# (3) n = 0 never inserts anything
OUT6="$(rkt '(display (insert-if-short 42 '\''((1 2) (3 4 5) (6) ()) 0))')"
check "n = 0 never inserts anything" "((1 2) (3 4 5) (6) ())" "$OUT6"

# (4) n large inserts in every list
OUT7="$(rkt '(display (insert-if-short 99 '\''((1 2) (3 4 5)) 1000))')"
check "n large inserts in every list" "(99 (99 1 2) (99 3 4 5))" "$OUT7"

# (5) Stress test: list of 10,000 numbers with n = 10001
STRESS1_CODE="
(let* ([lst (build-list 10000 (lambda (i) i))]
       [res (insert-if-short 42 lst 10001)])
  (display (length res)))
"
OUT_STRESS1="$(rkt "$STRESS1_CODE")"
check "stress test: 10,000 numbers with n = 10001 gives length 10,001" "10001" "$OUT_STRESS1"

# (6) Stress test: nesting depth of 100 with n = 5
STRESS2_CODE="
(let* ([deep-tree (let loop ([d 100] [tree 1])
                    (if (= d 0) tree (loop (- d 1) (list tree))))]
       [res (insert-if-short 'x deep-tree 5)]
       [all-x? (let check-depth ([d 100] [curr res])
                 (if (= d 0)
                     (= curr 1)
                     (and (pair? curr)
                          (eq? (car curr) 'x)
                          (check-depth (- d 1) (car (cdr curr))))))])
  (display all-x?))
"
OUT_STRESS2="$(rkt "$STRESS2_CODE")"
check "stress test: depth 100 nesting with n = 5 inserts at every level" "#t" "$OUT_STRESS2"

# (7) Check insert-if-short is defined exactly once
COUNT="$(grep -c "(define (insert-if-short" "$FILE" | tr -d ' ')"
check "insert-if-short is defined exactly once" "1" "$COUNT"
