---
name: prolog-dev
description: Conventions, run commands, self-review checklist and known AI pitfalls for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (P1, P2).
---

# prolog-dev

Use this skill for every Prolog task in this repository. Do exactly the one unit of
work asked for, touch only the files named in the prompt, and do not run git.

## 1. Language and version

- SWI-Prolog 9.x (tested with 9.2.9).
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate`.
  Load them with `:- use_module(library(lists)).` etc. No other `use_module`.

## 2. Hard rules

- No `assert`, `asserta`, `assertz`, `retract`, `retractall`.
- No global variables: no `b_setval`, `b_getval`, `nb_setval`, `nb_getval`.
- No `initialization` directive of any kind.
- Never call `halt/0` or `halt/1`. The grader adds `-t halt`.
- Nothing is printed when the file is loaded. The only directives allowed are
  `use_module` lines.
- Print only what the task specifies, nothing else (no debug output, no extra blank lines).

## 3. Coding conventions

- Predicate names in `snake_case`; variables in `CamelCase`.
- A one-line comment directly above every predicate giving its declarative reading
  and its mode, for example:
  ```prolog
  % count_solutions(+Active, -N): N is the number of candidates that satisfy every clue in Active.
  ```
- Mode annotations in comments: `+` input (bound), `-` output (unbound), `?` either.
- One clause per case; keep all clauses of a predicate together (contiguous).
- Prefer pure relations (unification, `member/2`, `permutation/2`, `append/3`)
  over side effects.
- Use `once/1` only where the task wants a single answer (for example `main/0`,
  `generate_equation/2`). Elsewhere, let the predicate enumerate on backtracking.
- Integer arithmetic only with `is/2`, `=:=`, `=\=`, `mod`, `//`.

## 4. How to run and test

- Main goal: `swipl -q -f code/16_q1.pl -g main -t halt`
- Any other predicate: `swipl -q -f FILE -g "GOAL" -t halt`, for example
  `swipl -q -f code/16_q2.pl -g "all_equations([4,2,5,3],E), print(E), nl" -t halt`
- To see a result, put the printing in the `-g` goal, never in the file.
- Always run the code after writing it and show the real output in the answer.
  Never claim output that was not produced by an actual run.

## 5. Self-review checklist (apply before answering)

- [ ] (a) The file loads with no warnings: no singleton variables, no
      discontiguous clauses, no redefinition warnings.
- [ ] (b) No forbidden constructs: assert/retract, global variables,
      initialization, halt, libraries outside the allowed four.
- [ ] (c) Names are quoted atoms exactly as the task says: `'Alex'`, `'Ben'`,
      `'Carla'`, `'Dana'`, `'c++'`, `'AI'`.
- [ ] (d) Output format matches the task character for character (spaces,
      commas, brackets, newlines, no quotes).
- [ ] (e) Predicates fail cleanly on bad or empty input: they do not loop
      and do not throw.
- [ ] (f) Answers are SWI-Prolog strings when strings are required
      (check with `string/1`), not atoms and not code lists.
- [ ] Only the requested unit was written; no other predicate was changed.

## 6. Known failure modes of AI tools in Prolog

- Using `assert` to memoize or to count.
- Adding `:- initialization(main).`
- Calling `halt/0` inside `main`.
- Forgetting the quotes on `'Alex'`, `'c++'`, `'AI'` (unquoted `Alex` is a variable;
  unquoted `c++` is a syntax error).
- Using `~p` or `~q` in `format/2`, which prints quotes; use `~w`.
- Using `atom_concat/3` or `atom_string/2` results where a string is required;
  build strings with `format(string(S), ...)` or `string_concat/3`.
- Using `/` for integer division: it can produce floats. Check divisibility with
  `mod` (`B =\= 0, A mod B =:= 0`) and compute with `//`.
- Loading `library(clpfd)` or any library outside lists, apply, yall, aggregate.
- Leaving choice points or looping forever where a single answer is needed
  (missing `once/1`).
- Printing debug output, or leaving test goals in the file.
- Changing the required output format "to look nicer".
