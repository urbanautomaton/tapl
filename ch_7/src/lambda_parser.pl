% vim: set ft=prolog:

parse_term(String, Term) :-
  phrase(lambda_expr(Term), String, []).

% t  ::= t' t | t'
% t' ::= x | λx. t | (t)

tuplize(X, Y, (Y, X)).

lambda_expr(X) -->
  lambda_expr_(X).
lambda_expr(Z) -->
  lambda_expr_(X), ` `, lambda_expr_(Y), application_tail((X, Y), Z).

application_tail(Accum, Accum) --> { }.
application_tail(Accum, Z) --> ` `, lambda_expr_(Y), application_tail((Accum, Y), Z).

lambda_expr_(X) -->
  lambda_var(X).
lambda_expr_(λ(X, Y)) -->
  `λ.`, lambda_var(X), ` `, lambda_expr(Y).
lambda_expr_(X) -->
  `(`, lambda_expr(X), `)`.

lambda_var(Variable) -->
  lower_letter(H),
  lower_letters(T),
  { atom_codes(Variable, [H|T]) }.

lower_letters([C|T]) -->
  lower_letter(C), !,
  lower_letters(T).
lower_letters([]) --> [].

lower_letter(C) -->
  [C],
  { code_type(C, lower) }.
