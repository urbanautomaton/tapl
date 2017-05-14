% vim: set ft=prolog:

:- [src(terms)].

typeof(X, T) :-
  typeof(context{}, X, T).

% T-Var
typeof(Γ, X, T) :-
  variable(X),
  T = Γ.get(X).

% T-True
typeof(_, const(true), bool).

% T-False
typeof(_, const(false), bool).

% T-Zero
typeof(_, const(0), nat).

% T-If
typeof(Γ, if(X, Y, Z), T) :-
  typeof(Γ, X, bool),
  typeof(Γ, Y, T),
  typeof(Γ, Z, T).

% T-Abs
typeof(Γ, λ(X, T1, Z), function(T1, T2)) :-
  typeof(Γ.put(X, T1), Z, T2).

% T-App
typeof(Γ, (X, Y), T2) :-
  typeof(Γ, X, function(T1, T2)),
  typeof(Γ, Y, T1).

% T-IsZero
typeof(Γ, iszero(X), bool) :-
  typeof(Γ, X, nat).

% T-Succ
typeof(Γ, succ(X), nat) :-
  typeof(Γ, X, nat).

% T-Pred
typeof(Γ, pred(X), nat) :-
  typeof(Γ, X, nat).
