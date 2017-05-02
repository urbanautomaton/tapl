% vim: set ft=prolog:

:- [src(lambda_parser)].

:- begin_tests(parse_term).

test(parse_term_variable, [nondet]) :-
  parse_term(`x`, X), X = x.

test(parse_long_variable, [nondet]) :-
  parse_term(`zazaz`, Z), Z = zazaz.

test(parse_not_a_variable, [nondet]) :-
  \+ parse_term(`zzz `, _).

test(parse_application, [nondet]) :-
  parse_term(`x y`, X), X = (x, y).

test(parse_multiple_application, [nondet]) :-
  parse_term(`x y z`, X), X = ((x, y), z).

test(parse_parenthesised_application, [nondet]) :-
  parse_term(`x (y z)`, X), X = (x, (y, z)).

test(parse_more_parentheses_for_the_hell_of_it, [nondet]) :-
  parse_term(`(x y) (z a)`, X), X = ((x, y), (z, a)).

test(parse_abstraction, [nondet]) :-
  parse_term(`λ.x x`, X), X = λ(x, x).

test(parse_complex_abstraction, [nondet]) :-
  parse_term(`λ.x λ.y (λ.z (z y) x)`, X), X = λ(x, λ(y, λ(z, ((z, y), x)))).

test(parse_complex_abstraction_no_parens, [nondet]) :-
  parse_term(`λ.x λ.y λ.z z y x`, X), X = λ(x, λ(y, λ(z, ((z, y), x)))).

:- end_tests(parse_term).
