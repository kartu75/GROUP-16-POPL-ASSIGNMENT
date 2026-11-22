#!/usr/bin/env bash
# Tests for code/67_q2.pl (P2: arithmetic equations and canonical printer).
# Run from anywhere: bash tests/test_q2.sh (or through tests/run_all.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1
source tests/lib.sh

ID="${GROUP_ID:-67}"
FILE="code/${ID}_q2.pl"

pl() {
    run_pl "$FILE" "$1" 2>&1 | tr -d '\r'
}

# (1) all_equations([4,2,5,3], Es) equals ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3","4=2*(5-3)","4=2+(5-3)","4=2+5-3"]
ACTUAL_1="$(pl 'all_equations([4,2,5,3], Es), format("~w", [Es])')"
EXPECTED_1='[4*2-5=3,4*2=5+3,4-2=5-3,4/2=5-3,4=2*(5-3),4=2+(5-3),4=2+5-3]'
check "all_equations([4,2,5,3]) matches expected 7 equations" "$EXPECTED_1" "$ACTUAL_1"

# (2) generate_equation([4,2,5,3], E) gives one of those 7 strings and E is a string
ACTUAL_2="$(pl 'generate_equation([4,2,5,3], E), string(E), member(E, ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3","4=2*(5-3)","4=2+(5-3)","4=2+5-3"]), write(ok)')"
check "generate_equation([4,2,5,3], E) gives valid equation string" "ok" "$ACTUAL_2"

# (3) generate_equation([2,3,4], E) fails and all_equations([2,3,4], Es) gives []
ACTUAL_3="$(pl '(generate_equation([2,3,4], _) -> write(fail) ; write(ok)), write(" "), all_equations([2,3,4], Es), write(Es)')"
check "generate_equation fails and all_equations gives [] for [2,3,4]" "ok []" "$ACTUAL_3"

# (4) all_equations([2,4,8], Es) equals ["2*4=8"]
ACTUAL_4="$(pl 'all_equations([2,4,8], Es), format("~w", [Es])')"
check "all_equations([2,4,8]) equals [2*4=8]" "[2*4=8]" "$ACTUAL_4"

# (5) all_equations([], Es) is [] and generate_equation([], E) fails
ACTUAL_5="$(pl 'all_equations([], Es), write(Es), write(" "), (generate_equation([], _) -> write(fail) ; write(ok))')"
check "all_equations([], []) and generate_equation([], E) fails" "[] ok" "$ACTUAL_5"

# (6) generate_equation([7], E) fails and all_equations([7], Es) is []
ACTUAL_6="$(pl '(generate_equation([7], _) -> write(fail) ; write(ok)), write(" "), all_equations([7], Es), write(Es)')"
check "generate_equation([7], E) fails and all_equations([7], Es) is []" "ok []" "$ACTUAL_6"

# (7) all_equations([1,1], Es) equals ["1=1"]
ACTUAL_7="$(pl 'all_equations([1,1], Es), format("~w", [Es])')"
check "all_equations([1,1]) equals [1=1]" "[1=1]" "$ACTUAL_7"

# (8) all_equations([6,2,3], Es) equals ["6/2=3","6=2*3"]
ACTUAL_8="$(pl 'all_equations([6,2,3], Es), format("~w", [Es])')"
check "all_equations([6,2,3]) equals [6/2=3,6=2*3]" "[6/2=3,6=2*3]" "$ACTUAL_8"

# (9) all_equations([4,0,0], Es) equals ["4*0=0"]
ACTUAL_9="$(pl 'all_equations([4,0,0], Es), format("~w", [Es])')"
check "all_equations([4,0,0]) equals [4*0=0]" "[4*0=0]" "$ACTUAL_9"

# (10) count_equations([4,2,5,3], N) gives 7
ACTUAL_10="$(pl 'count_equations([4,2,5,3], N), write(N)')"
check "count_equations([4,2,5,3], N) gives 7" "7" "$ACTUAL_10"

# (11) The 8 tree_string examples from the canonical-form rules
CANON_GOAL='
Trees = [
    op(*,op(+,num(4),num(2)),num(3)) - "(4+2)*3",
    op(+,num(4),op(*,num(2),num(3))) - "4+2*3",
    op(*,op(/,num(8),num(4)),num(2)) - "8/4*2",
    op(/,num(8),op(*,num(4),num(2))) - "8/(4*2)",
    op(-,op(-,num(1),num(2)),num(3)) - "1-2-3",
    op(-,num(1),op(-,num(2),num(3))) - "1-(2-3)",
    op(+,num(1),op(+,num(2),num(3))) - "1+(2+3)",
    op(+,op(+,num(1),num(2)),num(3)) - "1+2+3"
],
forall(member(Tr - Expected, Trees), (
    tree_string(Tr, S),
    string(S),
    S == Expected
)),
write(ok)
'
ACTUAL_11="$(pl "$CANON_GOAL")"
check "8 canonical tree_string examples all match" "ok" "$ACTUAL_11"
