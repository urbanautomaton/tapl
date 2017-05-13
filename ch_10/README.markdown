# The simply typed lambda calculus

Prolog implementation of the simply typed lambda calculus described in Ch 9.

## To run

You'll need swi-prolog installed. On Mac using homebrew:

    $ brew install swi-prolog

On other systems I think there's someone you can telephone.

Then to run the tests:

    $ make test

And to run it interactively:

    $ make console
    ?- run(`(λx:Bool->Bool. x true) (λy:Bool. if y then false else true)`, _).
    AST parsed:λ(x,function(bool,bool), (x,true)),λ(y,bool,if(y,false,true))
    Type established:bool
    Intermediate:λ(y,bool,if(y,false,true)),true
    Intermediate:if(true,false,true)
    Intermediate:false
    Result:false
