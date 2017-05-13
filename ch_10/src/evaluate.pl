% vim: set ft=prolog:

:- [src(terms)].

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
evaluate(if(true, X, _), X).

% E-IfFalse
evaluate(if(false, _, X), X).

% E-If
evaluate(if(X, Y, Z), if(X1, Y, Z)) :-
  evaluate(X, X1).

beta_reduce((λ(X, _, Y), Z), R) :-
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

replace(Name, λ(Name, T, Y), _, λ(Name, T, Y)).

replace(Name, λ(X, _, Y), With, RY) :-
  Name \== X,
  free_variables(With, FreeInWith),
  \+ member(X, FreeInWith),
  replace(Name, Y, With, RY).

replace(Name, λ(X, T, Y), With, λ(X1, T, RY)) :-
  Name \== X,
  free_variables(With, FreeInWith),
  member(X, FreeInWith),
  alpha_convert(λ(X, T, Y), λ(X1, T, Y1), FreeInWith),
  replace(Name, λ(X1, T, Y1), With, RY).

replace(Name, if(X, Y, Z), With, if(RX, RY, RZ)) :-
  replace(Name, X, With, RX),
  replace(Name, Y, With, RY),
  replace(Name, Z, With, RZ).

alpha_convert(λ(X, T, Y), λ(X1, T, Y1), Avoiding) :-
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

rewrite(Name, λ(Name, _, Y), _, λ(Name, _, Y)).
rewrite(Name, λ(X, _, Y), With, λ(X, _, Y1)) :-
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

free_variables(Bound, λ(X, _, Y), Vs) :-
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
