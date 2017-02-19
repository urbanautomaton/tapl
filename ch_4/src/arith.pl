% vim: set ft=prolog:

% term/1 succeeds if the input program is syntactically valid. I haven't
% actually used it in the evaluation predicates (since invalid programs will
% fail anyway due to not matching any rules) but it's here for completeness.
term(0).
term(true).
term(false).
term(succ(X)) :- term(X).
term(pred(X)) :- term(X).
term(iszero(X)) :- term(X).
term(if(X, Y, Z)) :- term(X), term(Y), term(Z).

% size/2 succeeds if the first argument's term size is equal to the second
% argument. It treats uninstantiated variables as a term of size 1.
size(X, 1) :- var(X), !.
size(true, 1).
size(false, 1).
size(0, 1).
size(succ(T), S) :-
  size(T, S1),
  S is S1 + 1.
size(pred(T), S) :-
  size(T, S1),
  S is S1 + 1.
size(iszero(T), S) :-
  size(T, S1),
  S is S1 + 1.
size(if(A, B, C), S) :-
  size(A, SA),
  size(B, SB),
  size(C, SC),
  S is SA + SB + SC.

% depth/2 succeeds if the first argument's term depth is equal to the second
% argument. It treats uninstantiated variables as a term of depth 1.
depth(X, 1) :- var(X), !.
depth(true, 1).
depth(false, 1).
depth(0, 1).
depth(succ(T), D) :-
  depth(T, D1),
  D is D1 + 1.
depth(pred(T), D) :-
  depth(T, D1),
  D is D1 + 1.
depth(iszero(T), D) :-
  depth(T, D1),
  D is D1 + 1.
depth(if(A, B, C), D) :-
  depth(A, DA),
  depth(B, DB),
  depth(C, DC),
  max_member(DM, [DA, DB, DC]),
  D is DM + 1.


% value/1 succeeds if the term is a value. If any part of the term is
% uninstantiated, it is not considered a value.
value(X) :- nv(X).
value(true).
value(false).

% nv/1 succeeds if the term is a numeric value. If any part of the term is
% uninstantiated, it is not considered a numeric value.
nv(0).
nv(succ(X)) :- nonvar(X), nv(X).

% programs_for/3 succeeds when Programs contains all programs of depth =< Max
% that evaluate to Value.
programs_for(Value, Programs, Max) :-
  value(Value),
  programs_for_acc([Value], Programs, Max).

programs_for_acc(Acc, Acc, Max) :- expand(Acc, [], Max).
programs_for_acc(Acc, Programs, Max) :-
  expand(Acc, T1s, Max),
  T1s \= [],
  append(Acc, T1s, NewAcc),
  programs_for_acc(NewAcc, Programs, Max).

expand(T0s, T1s, Max) :-
  findall(
    T1,
    (
      member(T0, T0s),
      reduce(T1, T0),
      \+ member(T1, T0s),
      depth(T1, ST1),
      ST1 =< Max
    ),
    T1s
  ).

% evaluate/2 succeeds when the first argument is an arith program evaluating
% to the second argument.
%
% The cuts are here because we know these programs will only ever evaluate to
% a single value, so we don't want to offer a choicepoint.
evaluate(X, X) :- value(X), !.
evaluate(X, Z) :- reduce(X, Y), evaluate(Y, Z), !.

% reduce/2 provides single small-step operational semantic rules for reducing
% a given term.

% boolean reductions
reduce(if(true, X, _), X).
reduce(if(false, _, X), X).
reduce(if(X, Y, Z), if(X1, Y, Z)) :- reduce(X, X1).

% arithmetic reductions
reduce(succ(X), succ(X1)) :- reduce(X, X1).
reduce(pred(0), 0).
reduce(pred(succ(X)), X) :- nv(X).
reduce(pred(X), pred(X1)) :- reduce(X, X1).

% numerical predicate reductions
reduce(iszero(0), true).
reduce(iszero(succ(X)), false) :- nv(X).
reduce(iszero(X), iszero(X1)) :- reduce(X, X1).
