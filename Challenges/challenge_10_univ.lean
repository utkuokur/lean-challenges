import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs

/-!
# The Unfriendly Partition Conjecture — Universal Statement

Does every countable graph admit a partition of its vertex set into two parts
such that every vertex has at least as many neighbours in the other part as
in its own?

This is known to hold for locally finite graphs and certain other classes,
but the general countable case remains open.  There are uncountable
counterexamples (Shelah–Milner 1990), hence the countability restriction.

A partition into two parts is simply a function `V → Bool`; neighbourhood
sizes are compared by **injections**, so vertices of infinite degree are
handled correctly.  This mirrors ProofBench `P010`.  (The parametrized game
version in `Challenges/challenge_10.lean` additionally needs *partial*
partitions `V → Option Bool`; the plain conjecture does not, so this file is
self-contained.)
-/

universe u v

/- An injection-based comparison of cardinalities. -/
def InjectsInto (A : Type u) (B : Type v) : Prop :=
  ∃ e : A -> B, Function.Injective e

/- `A` has at least as many elements as `B`. -/
def AtLeastAsMany (A : Type u) (B : Type v) : Prop :=
  InjectsInto B A

/- Neighbours of `x` mapped to side `b`. -/
def neighboursInSide {V : Type u} (G : SimpleGraph V) (f : V -> Bool)
    (x : V) (b : Bool) : Type u :=
  {y : V // G.Adj x y ∧ f y = b}

/- A partition is unfriendly at `x` when `x` has at least as many neighbours
in the opposite partition class as in its own class, with cardinalities
compared by injections (so vertices of infinite degree are handled
correctly). -/
def UnfriendlyAt {V : Type u} (G : SimpleGraph V) (f : V -> Bool)
    (x : V) : Prop :=
  AtLeastAsMany
    (neighboursInSide G f x (!f x))
    (neighboursInSide G f x (f x))

/- A partition unfriendly at every vertex. -/
def IsUnfriendlyPartition {V : Type u} (G : SimpleGraph V)
    (f : V -> Bool) : Prop :=
  ∀ x : V, UnfriendlyAt G f x

/- **The Unfriendly Partition Conjecture** (Cowan and Emerson): every
countable graph has a partition that is unfriendly at every vertex. -/
theorem challenge_10_univ :
    ∀ {V : Type u}, Countable V → ∀ G : SimpleGraph V,
      ∃ f : V -> Bool, IsUnfriendlyPartition G f := sorry
