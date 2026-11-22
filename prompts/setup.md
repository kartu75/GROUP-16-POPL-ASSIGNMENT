# Setup prompts

Prompts used for the skill files and the test harness, copied word for word, in order.

## SK-P

```
Create the file skills/prolog-dev/SKILL.md. It must start with a
YAML header containing name: prolog-dev and a one-line description.
Then include these sections, each short and concrete:
1. Language and version: SWI-Prolog 9.x. Allowed libraries only: lists,
apply, yall, aggregate.
2. Hard rules: no assert/retract, no global variables (b_setval,
nb_setval), no initialization directive, never call halt/0, nothing
printed at load time, only print what the task specifies.
3. Coding conventions: snake_case predicate names, a one-line comment
above every predicate giving its declarative reading, mode annotations
like +List, -Result in comments, one clause per case, prefer pure
relations, use once/1 only where the task wants a single answer.
4. How to run and test: swipl -q -f code/<ID>_q1.pl -g main -t halt,
and swipl -q -f FILE -g "GOAL" -t halt for any other predicate. Always
run the code after writing it and show real output.
5. Self-review checklist the AI must apply before answering: (a) file
loads with no warnings (singleton variables, discontiguous clauses),
(b) no forbidden constructs, (c) names are quoted atoms exactly as the
task says ('Alex', 'c++', 'AI'), (d) output format matches character
for character, (e) predicate fails cleanly (does not loop or throw) on
bad or empty input, (f) answers are strings when strings are required,
not atoms.
6. Known failure modes of AI tools in Prolog: using assert to memoize;
adding :- initialization(main); calling halt/0 inside main; forgetting
quotes on 'Alex', 'c++', 'AI'; using ~p or ~q in format/2 (prints
quotes) instead of ~w; using atom_concat/atom_string results where a
string is required; using / for integer division (it can yield floats,
so check divisibility with mod and use //); using library(clpfd) or
other libraries that are not allowed; leaving choice points or infinite
loops by missing once/1; printing debug output; changing the required
output format "to look nicer".
Do not write any other file.
```

## SK-S

```
Create the file skills/scheme-dev/SKILL.md. It must start with a 
YAML header containing name: scheme-dev and a one-line description. 
Then include these sections, each short and concrete:
1. Language and version: Racket 8.x, file starts with #lang 
racket/base. The file contains only definitions: no top-level calls, 
nothing printed when loaded.
2. The ONLY allowed built-ins: define, lambda, let, let*, letrec, named 
let, if, cond (with else), and, or, not, begin, quote, cons, car, cdr, 
list, compositions of car/cdr up to four levels, null?, pair?, eq?, 
assq, assoc, + - * < > <= >= =, max, display, newline. The file for the 
read problem may also use read. Everything else is forbidden: no set! 
or relatives, no vectors, hash tables, strings, loops (do, for), and no 
length, append, reverse, map, filter, member, memq, list-ref, list
tail, add1, sub1, equal?, eqv?, list?, first, rest, empty?, printf, 
displayln, print, void. If a helper like my-reverse is needed, write 
it.
3. Coding conventions: kebab-case names, a one-line comment above each 
function with its recursive reading (base case, recursive case), all 
state passed through arguments, prefer tail recursion with an 
accumulator where natural, small helpers over big functions.
4. How to run and test: the grader appends calls to the end of the file 
and runs racket FILE. To test, copy the file to a temp file, append the 
call, run racket on it. Always run the code and show real output.
5. Self-review checklist before answering: (a) every identifier used is 
in the allowed list (scan the code for each name), (b) no top-level 
call or print, (c) output uses only display and newline and ends with a 
newline, (d) the empty-list case works, (e) works on very deep and very 
long inputs (depth 100, 10,000 elements) without error.
6. Known failure modes of AI tools in Racket: reaching for length, 
append, reverse, map, filter, member, list?, equal?, add1, sub1 out of 
habit; using displayln or printf; leaving a test call at the bottom of 
the file; forgetting #lang racket/base; using set! for accumulators; 
using else outside cond; treating () as an atom or an atom as a list 
(check pair? and null? explicitly); quadratic behavior from repeated 
my-append on long lists.
Do not write any other file.
```
