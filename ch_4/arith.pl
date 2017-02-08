% vim: set ft=prolog:

% term/1 succeeds if the input program is syntactically valid. I haven't
% actually used it in the evaluation predicates (since invalid programs will
% fail anyway) but it's here for completeness.
term(0).
term(true).
term(false).
term(succ(X)) :- term(X).
term(pred(X)) :- term(X).
term(iszero(X)) :- term(X).
term(if(X, Y, Z)) :- term(X), term(Y), term(Z).

% ...ditto for values...
value(X) :- nv(X).
value(true).
value(false).

% ...and finally numeric values (to which the values/1 predicate refers).
nv(0).
nv(succ(X)) :- nv(X).

% result/2 is a wrapper predicate around the reduction rules to tell us when
% to stop (i.e. when we reach a value, either directly or via further
% reduction)
%
% The cuts are here because we know these programs will only ever evaluate to
% a single value, so we don't want to offer a choicepoint.
result(X, X) :- value(X), !.
result(X, Z) :- reduce(X, Y), result(Y, Z), !.

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
