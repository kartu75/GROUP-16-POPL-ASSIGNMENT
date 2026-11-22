:- use_module(library(lists)).

% eval_ok(+Op, +A, +B, -V): V is the integer result of applying binary arithmetic operation Op (+, -, *, /) to integers A and B, requiring exact division (A mod B =:= 0, B =\= 0) for /.
eval_ok(+, A, B, V) :- V is A + B.
eval_ok(-, A, B, V) :- V is A - B.
eval_ok(*, A, B, V) :- V is A * B.
eval_ok(/, A, B, V) :-
    B =\= 0,
    A mod B =:= 0,
    V is A // B.
