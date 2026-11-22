:- use_module(library(lists)).

% candidate(-Solution): Solution is a list of p(Name, Dept, Lang, Project) for 'Alex', 'Ben', 'Carla', 'Dana' in that order, where each attribute's four values are assigned as a permutation (each value used exactly once).
candidate([p('Alex', D1, L1, P1), p('Ben', D2, L2, P2), p('Carla', D3, L3, P3), p('Dana', D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]).

% clue(+N, +Solution): clue number N holds in the fully filled-in Solution.
% Clue 1: the friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.
% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \== development,
    Lang \== 'c++'.
% Clue 3: the friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_, testing, Lang, _), Solution),
    Lang == python.
% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \== testing.
