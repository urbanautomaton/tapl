% vim: set ft=prolog:

variable(X) :- atom(X).
app((X, Y)) :- term(X), term(Y).
abs(λ(X, Y)) :- atom(X), term(Y).

term(X) :- variable(X).
term(X) :- app(X).
term(X) :- abs(X).

value(X) :- abs(X).

% E-App1
evaluate((X, Y), (RX, Y)) :-
  evaluate(X, RX).

% E-App2
evaluate((λ(X, Y), Z), (λ(X, Y), RZ)) :-
  evaluate(Z, RZ).

% E-AppAbs
evaluate((λ(X, Y), λ(A, B)), R) :-
  beta_reduce((λ(X, Y), λ(A, B)), R).

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

replace(Name, λ(X, Y), With, RY) :-
  Name \== X,
  free_variables(With, FreeInWith),
  \+ member(X, FreeInWith),
  replace(Name, Y, With, RY).

replace(Name, λ(X, Y), With, λ(X1, RY)) :-
  Name \== X,
  free_variables(With, FreeInWith),
  member(X, FreeInWith),
  alpha_convert(λ(X, Y), λ(X1, Y1), FreeInWith),
  replace(Name, λ(X1, Y1), With, RY).

alpha_convert(λ(X, Y), λ(X1, Y1), Avoiding) :-
  fresh_name(X, X1, Avoiding),
  rewrite(X, Y, X1, Y1).

rewrite(Name, In, With, With) :-
  variable(In),
  Name == In.

rewrite(Name, In, _, In) :-
  variable(In),
  Name \== In.

rewrite(Name, (X, Y), With, (X1, Y1)) :-
  rewrite(Name, X, With, X1),
  rewrite(Name, Y, With, Y1).

rewrite(Name, λ(Name, Y), _, λ(Name, Y)).
rewrite(Name, λ(X, Y), With, λ(X, Y1)) :-
  Name \== X,
  rewrite(Name, Y, With, Y1).

free_variables(T, Vs) :-
  free_variables([], T, Vs).

free_variables(Bound, X, []) :-
  variable(X),
  member(X, Bound).

free_variables(Bound, X, [X]) :-
  variable(X),
  \+ member(X, Bound).

free_variables(Bound, (X, Y), Vs) :-
  free_variables(Bound, X, VXs),
  free_variables(Bound, Y, VYs),
  append(VXs, VYs, Vs).

free_variables(Bound, λ(X, Y), Vs) :-
  free_variables([X|Bound], Y, Vs).

fresh_name(N, N1, Avoiding) :-
  next_name(N, N1),
  \+ member(N1, Avoiding).

fresh_name(N, N2, Avoiding) :-
  next_name(N, N1),
  member(N1, Avoiding),
  fresh_name(N1, N2, Avoiding).

next_name(N, N1) :-
  atom_codes(N, NCodes),
  reverse(NCodes, NCodesR),
  increment(NCodesR, N1CodesR, 97, 122),
  reverse(N1CodesR, N1Codes),
  atom_codes(N1, N1Codes).

increment([], [Min], Min, _).

increment([H|T], [H1|T], Min, Max) :-
  H1 is H + 1,
  H1 >= Min,
  H1 =< Max.

increment([H|T], [Min|T1], Min, Max) :-
  H1 is H + 1,
  H1 > Max,
  increment(T, T1, Min, Max).
