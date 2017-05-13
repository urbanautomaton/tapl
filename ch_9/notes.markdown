# Meeting notes

## Typing functions

So we know about typing values, what about functions? We can introduce a
function type →, but this isn't really useful

Tom: it's too conservative - you're throwing away information that you
could use, e.g. (λ.x true) will emit a Bool in an application, and you
can't then check that

e.g. λ.x iszero(x): →

(λ.x iszero(x)) 0: [ought to be Bool]
→ Nat: we've got no means to infer that the type of the result should
be Bool, so we'd reject this even though intuitively it's totally fine

Leo: having the function type still lets you type *some* things, though
Tom: yep, any program that doesn't involve application. Not nothing, but
we can do better

Okay, so introduce T → T, giving us an infinite number of types. → is
a "type constructor" building a new type out of two other types.

           →
          / \
        Bool →
            / \
          Bool Bool

## Type inference vs type annotation

Brief chat about the difference here - what most of us are used to is
type annotation, where we declare the types of things, so e.g.

(λ.x if x then false else true)

we can either annotate:

(λ.x:Bool if x then false else true)

or have some more complex thing that looks at the unknown terms in the
body, says "x occurs in a position that has to be a Bool" and
automatically applies the annotation to the x in λ.x. But this is much
trickier and we'll only get to that at chapter 22, some time in 2022.

## The typing relation then

[crosstalk about the ⊢ operator, which wasn't really introduced but
just: x ⊢ y means given x, we can infer y]

Leo: the grouping of this was really hard to parse:

[picture of Leo parenthesising the T-Abs typing rule]

Okay, what's this type environment then?

Tom: it's what allows you to type variables, since it allows you to
accumulate typing information up the derivation tree. Eventually we're
going to need to say "what's the type of x", and if that info has come
out of an earlier stage of typing you need to carry that up.

(e.g. λ.x:Bool iszero(x)) gets you x:Bool in the abstraction body, so
for the subsequent typing of iszero(x), we add the assumption x:Bool:

x:Bool ⊢ iszero(x) : [what]?

So we start at the bottom with an empty type environment, and work
upwards, accumulating assumptions

Leo: I'd always previously read these rules from top to bottom, but this
makes a lot more sense now

Tom: you can kind of think of this in terms of stack frames - in our
implementation we end up writing some recursive function typeof that
we'll call, recursively, with whatever we've discovered at the first
level, eventually returning from the "top" of this derivation.

[A bit of chat about renaming that I missed]

## Worked example of T-Abs

[HAMFISTED WHITEBOARDING BY YOURS TRULY]

## T-Var

T-Var Burton

[MASSIVE IMAGE OF T-Var INFERENCE RULE]

Tom: So these rules are complementary: T-Abs stuffs assumptions in the
environment for later, and T-Var pulls them out further up (down?) the
derivation tree.

James: I'm not sure why T-Var is even necessary - doesn't it directly
follow with the turnstile that the LHS implies the RHS?

Tom: so this membership operator is kind of a "native operator" not
inherent to the language - a bit like substitution `[x → s] t` was
previously used for the E-App evaluation rule.

Leo/Tuzz in hive mind stylee: It's a bit like this rule is giving
meaning to the turnstile - in what circumstances can we infer a given
type for a variable, given a particular typing environment?

## T-App

[James does a worked example on the board MASSIVE PHOTO HERE]

A bit of discussion of the new modified T-If, which is identical to what
we had earlier with arith, but with the addition of the typing
environment.

[diversion on the problems of naming things and the lamentable T_11 T_12
notation being used for no apparent reason]

Tom: It's only going to get worse: soon we'll need a notation for type
variables, which is like a variable in the language of types?

[Carl Sagan mind blown gif]

## Type environments

A brief discussion of the type environment Γ, and what it means - is
this something that's mutated, or something that's accumulated through
the inference rules?

Tom: this is related to these rules being rule /schemas/ - the literal
rules we write out don't ever involve a Γ, they're an accumulation of
assumptions that we get from the type annotations on functions, having
started with the empty set Γ at the beginning of the derivation.

So Γ isn't a shared global context, it's some state that carries through
for a particular branch of the derivation tree.

## "Pure simply typed lambda calculus"

The "pure" simply typed lambda calc defines types T as

T ::= T → T

But this results in the empty set, e.g. if we take the set-generation
approach, we'd see:

T1 = {}
T2 = {} // all the members of T1 plugged in to T → T
...

So we have no concrete types, and the language is "degenerate" - this
only makes sense in the context of other extensions, e.g. we could
introduce Bool as a concrete type, and all of a sudden we've got

T1 = {Bool}
T2 = {Bool, Bool → Bool}
...

Tom: this is why we're not using the pure lambda calc, with its abstract
representation of types - you have to have some concrete type to get you
going, otherwise you've got nothing.

[FRUITLESS SEARCH FOR BREAD METAPHOR]

Simon: It's kind of like an abstract base class for a language?

All: that's got nothing to do with bread, get out

## Attempt at ex 9.3.2

Can we construct a Γ, T s.t. Γ ⊢ x x : T ?

No! Not with our current type system anyway

T-App means we need to assume LH x : T1 → T2 and RH x : T1, which isn't
unifiable in our existing setup

Tom: this is an example of how you can't assign types with this system
[i.e. the simply-typed lambda calc λ→] to all of the expressions you might
expect.

[c.f. slack convo about y-combinator and omega-combinator not being well
typed in λ→.

## Curry-Howard

We skipped this. It's probably rubbish innit.

## Erasure and typability

Basically says that evaluation under the typed rules is the same as
evaluation of the same terms with types erased under the untyped rules

Tom: it's kind of saying that you're able to "compile" a type-annotated
term into an un-annotated term, and evaluate it and it'll be fine. So
essentially it's proving that once you've type checked a term and it
passes, you can delete the type information and proceed without loss of
confidence.

Dmitri: But this only works one way, right?

Tom: yep, this only applies to "compilation" from typed to untyped
terms.

## Wrapping up

Tom: the chapter doesn't mention this, but this won't allow you to give
a type to a program that won't terminate. Thus this simply-typed λ calc
*isn't* Turing-complete, because you can't type a program that won't
terminate. This is why the y-combinator doesn't have a type in this,
because you can use it to write a non-terminating program.

This comes up in a few chapters [ch 12 on Normalisation, or
Normalization if that's your thing], but worth noting.

## Mudgerospective

We agreed that Tom's paprika hummus was EXCELLENT

Mudge: I had beef from last time to share about digressions
Leo: we seemed better this time

The meeting helped immensely - people find it much easier to understand
in the meeting than from reading the book. General feeling that this is
because we discuss things in concrete terms, which helps elucidate.

Simon: we're losing people - maybe that's normal, but perhaps it's a
perception issue with the amount of implementation work that's going on?

Charlie: the chapters themselves are a huge amount of work, regardless
of any implementation considerations.

Tom: So are we going through this too fast?

Tom: All the stuff we've talked about today is more difficult than
rotating a cat.

Mudge: Okay, so a volunteer to do next meeting?

[Dmitri waves his arms to turn on the lights]

[MASS ACCLAIM FOR DMITRI'S VOLUNTEERING]

Rich: Nah I'll do it innit.

[MASS ACCLAIM FOR RICH'S VOLUNTEERING]

[FIN]
