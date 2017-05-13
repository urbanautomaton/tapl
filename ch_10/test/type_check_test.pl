% vim: set ft=prolog:

:- [src(type_check)].

:- begin_tests(typeof).

test(typeof_true, [nondet]) :-
  assertion(typeof([], const(true), bool)).

test(typeof_false, [nondet]) :-
  assertion(typeof([], const(false), bool)).

test(typeof_if_true_then_bools, [nondet]) :-
  assertion(
    typeof(
      [],
      if(const(true), const(false), const(true)),
      bool
    )
  ).

test(typeof_application, [nondet]) :-
  assertion(
    typeof(
      [],
      (λ(x, bool, x), const(true)),
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
      λ(y,bool,if(y,const(false),const(true))),
      function(bool, bool)
    )
  ).

:- end_tests(typeof).
