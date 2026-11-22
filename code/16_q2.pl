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

% prec(+Op, -Precedence): Precedence of arithmetic operator Op (* and / bind tighter than + and -).
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% tree_string(+Tree, -String): String is the canonical SWI-Prolog string representation of Tree with minimal parentheses following operator precedence and left-associativity.
tree_string(num(N), String) :-
    number_string(N, String).
tree_string(op(Op, Left, Right), String) :-
    format_left_operand(Left, Op, LeftStr),
    format_right_operand(Right, Op, RightStr),
    format(string(String), "~s~w~s", [LeftStr, Op, RightStr]).

% format_left_operand(+Tree, +ParentOp, -Str): String representation of a left operand, wrapped in parentheses only if its top operator has strictly lower precedence than ParentOp.
format_left_operand(num(N), _, Str) :-
    number_string(N, Str).
format_left_operand(op(LeftOp, L, R), ParentOp, Str) :-
    tree_string(op(LeftOp, L, R), InnerStr),
    prec(LeftOp, LP),
    prec(ParentOp, PP),
    (   LP < PP
    ->  format(string(Str), "(~s)", [InnerStr])
    ;   Str = InnerStr
    ).

% format_right_operand(+Tree, +ParentOp, -Str): String representation of a right operand, wrapped in parentheses if its top operator has the same or lower precedence than ParentOp.
format_right_operand(num(N), _, Str) :-
    number_string(N, Str).
format_right_operand(op(RightOp, L, R), ParentOp, Str) :-
    tree_string(op(RightOp, L, R), InnerStr),
    prec(RightOp, RP),
    prec(ParentOp, PP),
    (   RP =< PP
    ->  format(string(Str), "(~s)", [InnerStr])
    ;   Str = InnerStr
    ).


