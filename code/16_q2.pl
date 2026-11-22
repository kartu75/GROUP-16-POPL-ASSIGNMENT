:- use_module(library(lists)).

% eval_ok(+Op, +A, +B, -V): V is the integer result of applying binary arithmetic operation Op (+, -, *, /) to integers A and B, requiring exact division (A mod B =:= 0, B =\= 0) for /.
eval_ok(+, A, B, V) :- V is A + B.
eval_ok(-, A, B, V) :- V is A - B.
eval_ok(*, A, B, V) :- V is A * B.
eval_ok(/, A, B, V) :-
    B =\= 0,
    A mod B =:= 0,
    V is A // B.

% expr_tree(+List, -Tree, -Value): Tree is an arithmetic expression tree over the non-empty list of non-negative integers List, and Value is its evaluated integer result computed with eval_ok/4.
expr_tree([N], num(N), N).
expr_tree(List, op(Op, LeftTree, RightTree), Value) :-
    append(LeftPart, RightPart, List),
    LeftPart = [_|_],
    RightPart = [_|_],
    expr_tree(LeftPart, LeftTree, LeftVal),
    expr_tree(RightPart, RightTree, RightVal),
    member(Op, [+, -, *, /]),
    eval_ok(Op, LeftVal, RightVal, Value).

