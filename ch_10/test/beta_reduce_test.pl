% vim: set ft=prolog:

:- [src(beta_reduce)].

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
