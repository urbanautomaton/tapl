% vim: set ft=prolog:

:- [src(lambda)].

:- begin_tests(evaluate).

% (λx. x)(λx. x) -> (λx. x)
test(evaluate_id_id, [nondet]) :-
  assertion(
    evaluate(
      (λ(x, x), λ(x, x)),
      λ(x, x)
    )
  ).

% (λx. x) ((λx. x) (λz. (λx. x) z)) -> (λx. x) (λz. (λx. x) z)
test(evaluate_rhs_app, [nondet]) :-
  assertion(
    evaluate(
      (λ(x, x), (λ(x, x), λ(z, (λ(x, x), z)))),
      (λ(x, x), λ(z, (λ(x, x), z)))
    )
  ).

% ((λx. x) (λx. x)) (λz. z) -> (λx. x) (λz. z)
test(evaluate_lhs_app, [nondet]) :-
  assertion(
    evaluate(
      ((λ(x, x), λ(x, x)), λ(z, z)),
      (λ(x, x), λ(z, z))
    )
  ).

% (λx. λy. x y) (λx. y) -> λz. (λx. y) z
test(evaluate_with_capture_risk, [nondet]) :-
  evaluate(
    (λ(x, λ(y, (x, y))), λ(x, y)),
    λ(z, (λ(x, y), z))
  ).

:- end_tests(evaluate).

:- begin_tests(free_variables).

test(free_variables_of_var, [nondet]) :-
  free_variables(x, [x]).

test(free_variables_of_identity, [nondet]) :-
  free_variables(λ(x, x), []).

test(free_variables_of_application, [nondet]) :-
  free_variables((x, y), [x, y]).

test(free_variables_of_complex_term, [nondet]) :-
  free_variables(
    (λ(x, ((x, y), λ(w, w))), a),
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
  rewrite(x, λ(x, x), z, λ(x, x)).

test(rewrite_non_blocking_lambda, [nondet]) :-
  rewrite(x, λ(y, x), z, λ(y, z)).

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
