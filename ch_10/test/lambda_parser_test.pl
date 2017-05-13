% vim: set ft=prolog:

:- [src(lambda_parser)].

:- begin_tests(parse_term).

test(parse_term_variable) :-
  parse_term(`x`, x).

test(parse_long_variable) :-
  parse_term(`zazaz`, zazaz).

test(parse_not_a_variable) :-
  \+ parse_term(`zzz `, _).

test(parse_application) :-
  parse_term(`x y`, (x, y)).

test(parse_multiple_application) :-
  parse_term(`x y z`, ((x, y), z)).

test(parse_parenthesised_application) :-
  parse_term(`x (y z)`, (x, (y, z))).

test(parse_more_parentheses_for_the_hell_of_it) :-
  parse_term(`(x y) (z a)`, ((x, y), (z, a))).

test(parse_abstraction) :-
  parse_term(`λx:Bool. x`, λ(x, bool, x)).

test(parse_abstraction_with_function_arg) :-
  parse_term(
    `λx:Bool->Bool. x`,
    λ(x, function(bool, bool), x)
  ).

test(parse_abstraction_with_nested_type_arg) :-
  parse_term(
    `λx:Bool->Bool->Bool. x`,
    λ(x, function(bool, function(bool, bool)), x)
  ).

test(parse_abstraction_with_left_nested_type_arg) :-
  parse_term(
    `λx:(Bool->Bool)->Bool. x`,
    λ(x, function(function(bool, bool), bool), x)
  ).

test(parse_if_statement) :-
  parse_term(
    `if x then y else z`,
    if(x, y, z)
  ).

:- end_tests(parse_term).
