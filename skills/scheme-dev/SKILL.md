---
name: scheme-dev
description: Conventions, allowed built-ins, run commands, self-review checklist, and known AI pitfalls for Racket/Scheme code.
---

# scheme-dev

Use this skill for every Scheme/Racket task in this repository.

## 1. Language and version

- Racket 8.x.
- Every file must start with `#lang racket/base`.
- The file contains only definitions: no top-level calls, and nothing printed when loaded.

## 2. The ONLY allowed built-ins

- **Allowed built-ins:** `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote`, `cons`, `car`, `cdr`, `list`, compositions of `car`/`cdr` up to four levels, `null?`, `pair?`, `eq?`, `assq`, `assoc`, `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`, `display`, `newline`.
- The file for the read problem may also use `read`.
- **Everything else is forbidden:**
  - No `set!` or relatives.
  - No vectors, hash tables, strings, loops (`do`, `for`).
  - No `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `add1`, `sub1`, `equal?`, `eqv?`, `list?`, `first`, `rest`, `empty?`, `printf`, `displayln`, `print`, `void`.
- If a helper like `my-reverse` is needed, write it.

## 3. Coding conventions

- Kebab-case names for all identifiers and functions.
- A one-line comment directly above each function describing its recursive reading (base case, recursive case).
- All state passed through arguments.
- Prefer tail recursion with an accumulator where natural.
- Prefer small helpers over big functions.

## 4. How to run and test

- The grader appends calls to the end of the file and runs `racket FILE`.
- To test, copy the file to a temp file, append the call, and run `racket` on it.
- Always run the code and show real output.

## 5. Self-review checklist before answering

- (a) Every identifier used is in the allowed list (scan the code for each name).
- (b) No top-level call or print.
- (c) Output uses only `display` and `newline` and ends with a newline.
- (d) The empty-list case works.
- (e) Works on very deep and very long inputs (depth 100, 10,000 elements) without error.

## 6. Known failure modes of AI tools in Racket

- Reaching for `length`, `append`, `reverse`, `map`, `filter`, `member`, `list?`, `equal?`, `add1`, `sub1` out of habit.
- Using `displayln` or `printf`.
- Leaving a test call at the bottom of the file.
- Forgetting `#lang racket/base`.
- Using `set!` for accumulators.
- Using `else` outside `cond`.
- Treating `()` as an atom or an atom as a list (check `pair?` and `null?` explicitly).
- Quadratic behavior from repeated `my-append` on long lists.
