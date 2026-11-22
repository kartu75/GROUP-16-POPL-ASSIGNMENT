#!/usr/bin/env bash
# Tests for code/67_q1.pl (P1: department assignment puzzle).
# Run from anywhere: bash tests/test_q1.sh   (or through tests/run_all.sh)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1
source tests/lib.sh

FILE=code/67_q1.pl

# pl GOAL: run GOAL on FILE and drop the \r that swipl adds on Windows.
pl() {
    run_pl "$FILE" "$1" 2>&1 | tr -d '\r'
}

# (1) main prints exactly four lines "Name = [dept, lang, project]",
#     in the order Alex, Ben, Carla, Dana, with no quotes.
MAIN_OUT="$(pl main)"

check "main prints exactly 4 lines" "4" "$(printf '%s\n' "$MAIN_OUT" | wc -l | tr -d ' ')"

check "main names in order Alex, Ben, Carla, Dana" "Alex Ben Carla Dana" \
    "$(printf '%s\n' "$MAIN_OUT" | cut -d' ' -f1 | tr '\n' ' ' | sed 's/ $//')"

DEPT='(research|development|design|testing)'
LANG='(python|java|c\+\+|javascript)'
PROJ='(AI|web|embedded|data)'
LINE_RE="^(Alex|Ben|Carla|Dana) = \[$DEPT, $LANG, $PROJ\]\$"
BAD_LINES="$(printf '%s\n' "$MAIN_OUT" | grep -cvE "$LINE_RE")"
check "main every line matches 'Name = [dept, lang, project]'" "0" "$BAD_LINES"

check "main output has no quotes" "0" "$(printf '%s\n' "$MAIN_OUT" | grep -c "['\"]")"

# The printed answer must be one of the solutions of clues 1 to 8
# (main may print any of them, so compare against all of them).
IS_VALID="$(pl "with_output_to(string(Out), main),
    split_string(Out, \"\r\", \"\", Parts), atomics_to_string(Parts, Clean),
    ( candidate(S), satisfies([1,2,3,4,5,6,7,8], S),
      with_output_to(string(Exp),
          forall(member(p(N,D,L,P), S), format(\"~w = [~w, ~w, ~w]~n\", [N,D,L,P]))),
      Exp == Clean -> write(yes) ; write(no) ), nl")"
check "main prints a solution of clues 1 to 8" "yes" "$IS_VALID"

# (2) count_solutions for clues 1 to 8 equals 3.
check "count_solutions([1..8]) = 3" "3" \
    "$(pl "count_solutions([1,2,3,4,5,6,7,8], N), write(N), nl")"

# (3) count_solutions for clues 1 to 9 equals 1.
check "count_solutions([1..9]) = 1" "1" \
    "$(pl "count_solutions([1,2,3,4,5,6,7,8,9], N), write(N), nl")"

# (4) count_solutions for [] equals 13824 (24^3 candidates, no clue applied).
check "count_solutions([]) = 13824" "13824" \
    "$(pl "count_solutions([], N), write(N), nl")"

# (5) each of clue(1..9) is satisfied by at least one candidate.
for N in 1 2 3 4 5 6 7 8 9; do
    check "clue $N holds for at least one candidate" "yes" \
        "$(pl "( candidate(S), clue($N, S) -> write(yes) ; write(no) ), nl")"
done

# (6) clue 9 is true in exactly one solution of clues 1 to 8 and false in the others.
check "clue 9 true in exactly 1 of the solutions of clues 1 to 8" "1" \
    "$(pl "aggregate_all(count, (candidate(S), satisfies([1,2,3,4,5,6,7,8], S), clue(9, S)), C), write(C), nl")"
check "clue 9 false in the other 2 solutions of clues 1 to 8" "2" \
    "$(pl "aggregate_all(count, (candidate(S), satisfies([1,2,3,4,5,6,7,8], S), \\+ clue(9, S)), C), write(C), nl")"

# Extra: loading the file prints nothing (the grader loads it before every goal).
check "loading the file prints nothing" "" "$(pl true)"

echo
if [ "$FAILURES" -eq 0 ]; then
    echo "test_q1: all checks passed"
else
    echo "test_q1: $FAILURES check(s) failed"
fi
