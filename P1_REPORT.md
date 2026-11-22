# P1 Report

## Result of count_solutions for clues 1 to 8

```
swipl -q -f code/16_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), write(N), nl" -t halt
3
```

**N = 3.** Out of all 13824 candidates (24 department orders x 24 language orders x 24 project
orders, checked with `count_solutions([], N)`), exactly three satisfy all eight clues.

## What N = 3 tells us about the puzzle

The puzzle is **under-determined**: clues 1 to 8 are consistent (N > 0) but do not pin down a
single answer (N > 1). So `main/0`, which prints "one solution that satisfies clues 1 to 8",
is printing the first of three valid answers in enumeration order, not *the* answer. A ninth
clue is needed to make the solution unique.

## The three solutions

| # | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

Ben is fixed in all three. The department-language pairs are also the same in every solution
(design-java, development-javascript, research-c++, testing-python).

If we hide the names and only look at the (department, language, project) triples, solutions 1
and 3 are **identical**:

- Solution 1 and 3: design-java-AI, development-javascript-web, research-c++-data, testing-python-embedded
- Solution 2: design-java-embedded, development-javascript-web, research-c++-data, testing-python-AI

They differ only in *who* has each triple. Clue 9 is not allowed to mention any friend by name,
so any such clue is either true in both 1 and 3 or false in both. That means the only solution a
name-free clue can single out is **solution 2**.

## Clue 9

```prolog
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Solution) :-
    member(p(_, Dept, _, 'AI'), Solution),
    Dept == testing.
```

- In solutions 1 and 3 the AI friend works in design, so clue 9 is false.
- In solution 2 the AI friend (Carla) works in testing, so clue 9 is true.

```
count_solutions([1,2,3,4,5,6,7,8,9], N)  ->  N = 1
```

The unique solution is:

```
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```

## Note on main/0

`main/0` still uses only clues 1 to 8, as the task specifies, so it prints solution 1. With
clue 9 added the unique answer is solution 2; `main` was deliberately left unchanged.
