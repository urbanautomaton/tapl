% vim: set ft=prolog:

:- [src(terms), src(beta_reduce)].

% E-App1
evaluate((X, Y), (RX, Y)) :-
  evaluate(X, RX).

% E-App2
evaluate((λ(X, T, Y), Z), (λ(X, T, Y), RZ)) :-
  evaluate(Z, RZ).

% E-AppAbs
evaluate((λ(X, _, Y), V), R) :-
  value(V),
  beta_reduce((λ(X, _, Y), V), R).

% E-IfTrue
evaluate(if(const(true), X, _), X).

% E-IfFalse
evaluate(if(const(false), _, X), X).

% E-If
evaluate(if(X, Y, Z), if(X1, Y, Z)) :-
  evaluate(X, X1).

% E-Succ
evaluate(succ(T1), succ(T2)) :-
  evaluate(T1, T2).

% E-PredZero
evaluate(pred(const(0)), const(0)).

% E-PredSucc
evaluate(pred(succ(X)), X) :-
  numeric_value(X).

% E-Pred
evaluate(pred(T1), pred(T2)) :-
  evaluate(T1, T2).

% E-IszeroZero
evaluate(iszero(const(0)), const(true)).

% E-IszeroSucc
evaluate(iszero(succ(X)), const(false)) :-
  numeric_value(X).

% E-Iszero
evaluate(iszero(T1), iszero(T2)) :-
  evaluate(T1, T2).
