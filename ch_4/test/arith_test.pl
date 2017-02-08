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

test(reduce_if_by_only_a_single_step, all(X = [if(true, false, false)])) :-
  reduce(
    if(if(true, true, true), false, false),
    X
  ).

:- end_tests(reduce).
