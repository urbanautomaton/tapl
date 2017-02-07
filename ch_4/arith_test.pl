% vim: set ft=prolog:

:- [arith].

:- begin_tests(arith).

test(result_for_zero) :- result(0, 0).
test(result_for_true) :- result(true, true).
test(result_for_false) :- result(false, false).

test(result_for_incorrect_program, all(X = [])) :-
  result(pred(true), X).

test(result_for_arithmetic_expression) :-
  result(pred(succ(0)), 0).

test(result_for_something_complex) :-
  result(
    if(iszero(succ(pred(0))), succ(0), succ(succ(0))),
    succ(succ(0))
  ).

test(result_for_something_ridiculous_or_at_least_as_ridiculous_as_i_could_be_bothered_typing_which_is_an_assertion_perhaps_undermined_somewhat_by_the_name_of_this_test) :-
  result(
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

:- end_tests(arith).
