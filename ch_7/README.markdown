# arith.pl

Prolog implementation of the arithmetic expressions language defined in Ch. 3.

## To run

You'll need swi-prolog installed. On Mac using homebrew:

    $ brew install swi-prolog

On other systems I think there's someone you can telephone.

Then to run the tests:

    $ make test

And to run it interactively:

    $ make console
    ?- evaluate(iszero(if(true, 0, succ(0))), X).
    X = true.
