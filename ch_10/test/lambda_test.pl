% vim: set ft=prolog:

:- [src(lambda)].

:- begin_tests(typeof).

test(typeof_true, [nondet]) :-
  assertion(typeof([], true, bool)).

test(typeof_false, [nondet]) :-
  assertion(typeof([], false, bool)).

test(typeof_if_true_then_bools, [nondet]) :-
  assertion(
    typeof(
      [],
      if(true, false, true),
      bool
    )
  ).

test(typeof_application, [nondet]) :-
  assertion(
    typeof(
      [],
      (λ(x, bool, x), true),
      bool
    )
  ).

test(typeof_simple_abstraction, [nondet]) :-
  assertion(
    typeof(
      [],
      λ(x, bool, x),
      function(bool, bool)
    )
  ).

:- end_tests(typeof).

:- begin_tests(evaluate).

% (λx. x)(λx. x) -> (λx. x)
test(evaluate_id_id, [nondet]) :-
  assertion(
    evaluate(
      (λ(x, type, x), λ(x, type, x)),
      λ(x, type, x)
    )
  ).

% (λx. x) ((λx. x) (λz. (λx. x) z)) -> (λx. x) (λz. (λx. x) z)
test(evaluate_rhs_app, [nondet]) :-
  assertion(
    evaluate(
      (λ(x, type1, x), (λ(x, type2, x), λ(z, type3, (λ(x, type4, x), z)))),
      (λ(x, type1, x), λ(z, type3, (λ(x, type4, x), z)))
    )
  ).

% ((λx. x) (λx. x)) (λz. z) -> (λx. x) (λz. z)
test(evaluate_lhs_app, [nondet]) :-
  assertion(
    evaluate(
      ((λ(x, type1, x), λ(x, type2, x)), λ(z, type3, z)),
      (λ(x, type2, x), λ(z, type3, z))
    )
  ).

% (λ.x x) true
test(evaluate_app_with_rhs_bool, [nondet]) :-
  assertion(
    evaluate(
      (λ(x, type1, x), true),
      true
    )
  ).

% (λx. λy. x y) (λx. y) -> λz. (λx. y) z
test(evaluate_with_capture_risk, [nondet]) :-
  evaluate(
    (λ(x, type1, λ(y, type2, (x, y))), λ(x, type3, y)),
    λ(z, type2, (λ(x, type3, y), z))
  ).

% if true then x else y
test(evaluate_if_with_true_arg, [nondet]) :-
  evaluate(
    if(true, x, y),
    x
  ).

% if false then x else y
test(evaluate_if_with_false_arg, [nondet]) :-
  evaluate(
    if(false, x, y),
    y
  ).

% if (λ.x x) true then false else true
test(evaluate_if_with_reducible_arg, [nondet]) :-
  evaluate(
    if((λ(x, type1, x), true), false, true),
    if(true, false, true)
  ).

:- end_tests(evaluate).

:- begin_tests(free_variables).

test(free_variables_of_var, [nondet]) :-
  free_variables(x, [x]).

test(free_variables_of_identity, [nondet]) :-
  free_variables(λ(x, type, x), []).

test(free_variables_of_application, [nondet]) :-
  free_variables((x, y), [x, y]).

test(free_variables_of_complex_term, [nondet]) :-
  free_variables(
    (λ(x, type, ((x, y), λ(w, type, w))), a),
    [y, a]
  ).

:- end_tests(free_variables).

:- begin_tests(rewrite).

test(rewrite_matching_var, [nondet]) :-
  rewrite(x, x, y, y).

test(rewrite_non_matching_var, [nondet]) :-
  rewrite(x, y, z, y).

test(rewrite_application, [nondet]) :-
  rewrite(x, (x, x), y, (y, y)).

test(rewrite_blocking_lambda, [nondet]) :-
  rewrite(x, λ(x, type, x), z, λ(x, type, x)).

test(rewrite_non_blocking_lambda, [nondet]) :-
  rewrite(x, λ(y, type, x), z, λ(y, type, z)).

:- end_tests(rewrite).

:- begin_tests(fresh_name).

test(fresh_name_avoiding_none, [nondet]) :-
  fresh_name(x, y, []).

test(fresh_name_wrapping_avoiding_none, [nondet]) :-
  fresh_name(z, aa, []).

test(fresh_name_avoiding_next, [nondet]) :-
  fresh_name(x, z, [y]).

test(fresh_name_multiple_wrapping, [nondet]) :-
  fresh_name(zzzz, aaaaa, []).

:- end_tests(fresh_name).
