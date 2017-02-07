% vim: set ft=prolog:

% these are direct transcriptions of the BNF grammar definitions of terms...
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

result(X, X) :- value(X), !.
result(X, Y) :- reduce(X, Y), value(Y), !.

% boolean reductions
reduce(if(true, X, _), X).
reduce(if(false, _, X), X).
reduce(if(X, Y, Z), A) :- reduce(X, X1), result(if(X1, Y, Z), A).

% arithmetic reductions
reduce(succ(X), A) :- reduce(X, X1), result(succ(X1), A).
reduce(pred(0), 0).
reduce(pred(succ(X)), X) :- nv(X).
reduce(pred(X), A) :- reduce(X, X1), result(pred(X1), A).

% numerical predicate reductions
reduce(iszero(0), true).
reduce(iszero(succ(X)), false) :- nv(X).
reduce(iszero(X), A) :- reduce(X, X1), result(iszero(X1), A).
