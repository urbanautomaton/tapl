% vim: set ft=prolog:

:- [src(terms)].

% T-Var
typeof(Γ, X, T) :-
  variable(X),
  member((X, T), Γ).

% T-True
typeof(_, true, bool).

% T-False
typeof(_, false, bool).

% T-If
typeof(Γ, if(X, Y, Z), T) :-
  typeof(Γ, X, bool),
  typeof(Γ, Y, T),
  typeof(Γ, Z, T).

% T-Abs
typeof(Γ, λ(X, T1, Z), function(T1, T2)) :-
  typeof([(X, T1)|Γ], Z, T2).

% T-App
typeof(Γ, (X, Y), T2) :-
  typeof(Γ, X, function(T1, T2)),
  typeof(Γ, Y, T1).
