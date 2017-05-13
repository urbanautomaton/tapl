% vim: set ft=prolog:

:- [library(dcg/basics)].

parse_term(String, Term) :-
  phrase(lambda_expr(X), String, []), X = Term, !.

% t  ::= t' t | t'
% t' ::= x | λx:type. t | if t then t else t | iszero(t) | succ(t) | pred(t) | true | false | 0 | (t)

lambda_expr(X) -->
  lambda_expr_(X).
lambda_expr(Z) -->
  lambda_expr_(X), whitespace, lambda_expr_(Y), application_tail((X, Y), Z).

application_tail(Accum, Accum) --> { }.
application_tail(Accum, Z) --> whitespace, lambda_expr_(Y), application_tail((Accum, Y), Z).

lambda_expr_(X) -->
  lambda_var(X).
lambda_expr_(λ(X, T, Y)) -->
  `λ`, lambda_var(X), `:`, lambda_type(T), `.`, whites, lambda_expr(Y).
lambda_expr_(if(X, Y, Z)) -->
  `if `, lambda_expr(X), whitespace, `then`, whitespace, lambda_expr(Y), whitespace, `else`, whitespace, lambda_expr(Z).
lambda_expr_(iszero(X)) -->
  `iszero(`, lambda_expr(X), `)`.
lambda_expr_(succ(X)) -->
  `succ(`, lambda_expr(X), `)`.
lambda_expr_(pred(X)) -->
  `pred(`, lambda_expr(X), `)`.
lambda_expr_(const(true)) --> `true`.
lambda_expr_(const(false)) --> `false`.
lambda_expr_(const(0)) --> `0`.
lambda_expr_(X) -->
  `(`, lambda_expr(X), `)`.

lambda_type(T) --> lambda_type_(T).
lambda_type(function(T1,T2)) --> lambda_type_(T1), `->`, lambda_type(T2).

lambda_type_(bool) --> `Bool`.
lambda_type_(T) --> `(`, lambda_type(T), `)`.

lambda_var(Variable) -->
  atom_name(Variable),
  { \+ reserved(Variable) }.

whitespace --> white, whites.

reserved(if).
reserved(then).
reserved(else).
reserved(true).
reserved(false).

atom_name(A) -->
  lower_letter(H),
  lower_letters(T),
  { atom_codes(A, [H|T]) }.

lower_letters([C|T]) -->
  lower_letter(C), !,
  lower_letters(T).
lower_letters([]) --> [].

lower_letter(C) -->
  [C],
  { code_type(C, lower) }.
