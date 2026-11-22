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
