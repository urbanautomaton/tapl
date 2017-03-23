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

% (λ(x, λ(y, x)), y) -> λ(z, y)
test(evaluate_with_capture_risk, [nondet]) :-
  evaluate(
    (λ(x, λ(y, x)), y),
    R
  ),
  assertion(R \= λ(y, y)).

:- end_tests(evaluate).
