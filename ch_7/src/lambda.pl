% vim: set ft=prolog:

variable(X) :- atom(X).
app((X, Y)) :- term(X), term(Y).
abs(λ(X, Y)) :- atom(X), term(Y).

term(X) :- variable(X).
term(X) :- app(X).
term(X) :- abs(X).

value(X) :- abs(X).

% E-AppAbs
evaluate((λ(X, Y), λ(A, B)), R) :-
  beta_reduce((λ(X, Y), λ(A, B)), R).

% E-App2
evaluate((λ(X, Y), Z), (λ(X, Y), RZ)) :-
  evaluate(Z, RZ).

% E-App1
evaluate((X, Y), (RX, Y)) :-
  evaluate(X, RX).

beta_reduce((λ(X, Y), Z), R) :-
  replace(X, Y, Z, R).

% replace/4 - replace(Name, In, With, Result)
replace(Name, In, With, With) :-
  variable(In),
  Name == In.

replace(Name, In, _, In) :-
  variable(In),
  Name \== In.

replace(Name, (X, Y), With, (RX, RY)) :-
  replace(Name, X, With, RX),
  replace(Name, Y, With, RY).

replace(Name, λ(Name, Y), _, λ(Name, Y)).

replace(Name, λ(X, Y), With, λ(X, RY)) :-
  Name \== X,
  replace(Name, Y, With, RY).
