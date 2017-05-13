% vim: set ft=prolog:

variable(X) :- atom(X).

value(λ(_, _, _)).
value(const(_)).
value(succ(X)) :-
  value(X).

numeric_value(const(0)).
numeric_value(succ(X)) :- numeric_value(X).
