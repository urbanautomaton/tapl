% vim: set ft=prolog:

variable(X) :- atom(X).

value(λ(_, _, _)).
value(const(true)).
value(const(false)).
