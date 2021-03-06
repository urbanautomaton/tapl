% vim: set ft=prolog:

:- [src(arith)].

:- begin_tests(evaluate).

test(evaluate_for_zero) :- evaluate(0, 0).
test(evaluate_for_true) :- evaluate(true, true).
test(evaluate_for_false) :- evaluate(false, false).

test(evaluate_for_incorrect_program, all(X = [])) :-
  evaluate(pred(true), X).

test(evaluate_for_multiple_succ) :-
  evaluate(succ(succ(0)), succ(succ(0))).

test(evaluate_for_arithmetic_expression) :-
  evaluate(pred(succ(0)), 0).

test(evaluate_pred_zero) :-
  evaluate(pred(pred(pred(0))), 0).

test(evaluate_for_something_complex) :-
  evaluate(
    if(iszero(succ(pred(0))), succ(0), succ(succ(0))),
    succ(succ(0))
  ).

test(evaluate_for_something_ridiculous_or_at_least_as_ridiculous_as_i_could_be_bothered_typing_which_is_an_assertion_perhaps_undermined_somewhat_by_the_name_of_this_test) :-
  evaluate(
    if(
      if(
        if(
          if(iszero(0), true, iszero(succ(0))),
          false,
          iszero(succ(succ(0)))
        ),
        false,
        false
      ),
      false,
      false
    ),
    false
  ).

:- end_tests(evaluate).

:- begin_tests(reduce).

test(reduce_if_true, [nondet]) :-
  reduce(if(true, 0, succ(0)), 0).

test(reduce_if_false, [nondet]) :-
  reduce(if(false, 0, succ(0)), succ(0)).

test(reduce_if_guard, all(X = [if(true, false, false)])) :-
  reduce(
    if(if(true, true, true), false, false),
    X
  ).

:- end_tests(reduce).

:- begin_tests(programs_for).

test(programs_for_false_depth_2, [nondet]) :-
  programs_for(false, Ps, 2),
  sort(Ps, PsSorted),
  assertion(PsSorted = [
    false,
    if(false, _, false),
    if(true, false, true)
  ]).

test(programs_for_succ_0_depth_3, [nondet]) :-
  programs_for(succ(0), Ps, 3),
  sort(Ps, PsSorted),
  assertion(PsSorted = [
    succ(0),
    succ(pred(0)),
    succ(if(false, _, 0)),
    succ(if(true, 0, _)),
    if(false, _, succ(0)),
    if(true, succ(0), _),
    if(iszero(0), succ(0), _),
    if(if(false, _, false), _, succ(0)),
    if(if(false, _, true), succ(0), _),
    if(if(true, false, _), _, succ(0)),
    if(if(true, true, _), succ(0), _)
  ]).

:- end_tests(programs_for).
