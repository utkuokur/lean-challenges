import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs

/-!
# Shared definitions for the Unfriendly Partition Conjecture

The plain (total-partition) vocabulary shared by `challenge_10_univ` (prove
direction) and `challenge_10_disprove`. A partition into two parts is simply a
function `V → Bool`; neighbourhood sizes are compared by **injections**, so
vertices of infinite degree are handled correctly.

`InjectsInto` / `AtLeastAsMany` are also reused by the parametrized game in
`Challenges/challenge_10.lean` (which additionally needs *partial* partitions
`V → Option Bool` for the `r`-partitioning game — those stay in that file).
-/

universe u v

/-- An injection-based comparison of cardinalities. -/
def InjectsInto (A : Type u) (B : Type v) : Prop :=
  ∃ e : A → B, Function.Injective e

/-- `A` has at least as many elements as `B`. -/
def AtLeastAsMany (A : Type u) (B : Type v) : Prop :=
  InjectsInto B A

theorem atLeastAsMany_refl (A : Type u) : AtLeastAsMany A A :=
  ⟨id, fun _ _ h => h⟩

/-- Neighbours of `x` mapped to side `b` by the partition `f`. -/
def neighboursInSide {V : Type u} (G : SimpleGraph V) (f : V → Bool)
    (x : V) (b : Bool) : Type u :=
  {y : V // G.Adj x y ∧ f y = b}

/-- A partition is unfriendly at `x` when `x` has at least as many neighbours
in the opposite partition class as in its own class. -/
def UnfriendlyAt {V : Type u} (G : SimpleGraph V) (f : V → Bool) (x : V) : Prop :=
  AtLeastAsMany
    (neighboursInSide G f x (!f x))
    (neighboursInSide G f x (f x))

/-- A partition unfriendly at every vertex. -/
def IsUnfriendlyPartition {V : Type u} (G : SimpleGraph V) (f : V → Bool) : Prop :=
  ∀ x : V, UnfriendlyAt G f x

/-- **The Unfriendly Partition Conjecture** (Cowan and Emerson): every
countable graph has a partition that is unfriendly at every vertex. -/
def UnfriendlyPartitionConjecture : Prop :=
  ∀ {V : Type u}, Countable V → ∀ G : SimpleGraph V,
    ∃ f : V → Bool, IsUnfriendlyPartition G f
