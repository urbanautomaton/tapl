% vim: set ft=prolog:

:- [src(evaluate)].

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
      (λ(x, type1, x), const(true)),
      const(true)
    )
  ).

% (λx. λy. x y) (λx. y) -> λz. (λx. y) z
test(evaluate_with_capture_risk, [nondet]) :-
  evaluate(
    (λ(x, type1, λ(y, type2, (x, y))), λ(x, type3, y)),
    λ(z, type2, (λ(x, type3, y), z))
  ).

test(evaluate_app_abs_with_if_body, [nondet]) :-
  evaluate(
    (λ(y,bool,if(y,const(false),const(true))), const(true)),
    if(const(true), const(false), const(true))
  ).

% if true then x else y
test(evaluate_if_with_true_arg, [nondet]) :-
  evaluate(
    if(const(true), x, y),
    x
  ).

% if false then x else y
test(evaluate_if_with_false_arg, [nondet]) :-
  evaluate(
    if(const(false), x, y),
    y
  ).

% if (λ.x x) true then false else true
test(evaluate_if_with_reducible_arg, [nondet]) :-
  evaluate(
    if((λ(x, type1, x), const(true)), const(false), const(true)),
    if(const(true), const(false), const(true))
  ).

test(evaluate_succ_reducible, [nondet]) :-
  evaluate(
    succ(if(const(true), const(0), succ(const(0)))),
    succ(const(0))
  ).

test(evaluate_pred_zero, [nondet]) :-
  evaluate(
    pred(const(0)),
    const(0)
  ).

test(evaluate_pred_succ_zero, [nondet]) :-
  evaluate(
    pred(succ(const(0))),
    const(0)
  ).

test(evaluate_pred_reducible, [nondet]) :-
  evaluate(
    pred(if(const(true), const(0), succ(const(0)))),
    pred(const(0))
  ).

test(evaluate_iszero_zero, [nondet]) :-
  evaluate(
    iszero(const(0)),
    const(true)
  ).

test(evaluate_is_zero_succ, [nondet]) :-
  evaluate(
    iszero(succ(const(0))),
    const(false)
  ).

test(evaluate_is_zero_reducible, [nondet]) :-
  evaluate(
    iszero(if(const(true), const(0), succ(const(0)))),
    iszero(const(0))
  ).

:- end_tests(evaluate).
