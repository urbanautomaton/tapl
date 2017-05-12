# The simply typed lambda calculus

Prolog implementation of the simply typed lambda calculus described in Ch 9.

## To run

You'll need swi-prolog installed. On Mac using homebrew:

    $ brew install swi-prolog

On other systems I think there's someone you can telephone.

Then to run the tests:

    $ make test

And to run it interactively:

    # TODO fix example
    $ make console
    ?- evaluate(((λ(x, x), λ(x, x)), λ(z, z)), X).
    X = (λ(x, x), λ(z, z)).
