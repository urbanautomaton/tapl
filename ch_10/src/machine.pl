:- [src(lambda), src(lambda_parser)].

println([]) :- write("\n").
println([H|T]) :-
  write(H), println(T).

run(Program, Result) :-
  parse_term(Program, Term),
  println(["AST parsed:", Term]),
  typeof([], Term, Type),
  println(["Type established:", Type]),
  run_(Term, Result),
  println(["Result:", Result]).

run_(Term, Term) :-
  value(Term), !.
run_(T1, Result) :-
  evaluate(T1, T2),
  println(["Intermediate:", T2]),
  run_(T2, Result).

% example queries:
%
% run(`(λx:Bool->Bool. x true) (λy:Bool. if y then false else true)`, X).
% I got bored here real quick huh
