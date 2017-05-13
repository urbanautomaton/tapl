% vim: set ft=prolog:

:- [src(type_check)].

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

test(typeof_abstraction_with_if_body, [nondet]) :-
  assertion(
    typeof(
      [],
      λ(y,bool,if(y,false,true)),
      function(bool, bool)
    )
  ).

:- end_tests(typeof).
