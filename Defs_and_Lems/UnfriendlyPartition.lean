import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs

/-!
# Shared definitions for the Unfriendly Partition Conjecture

Vocabulary shared by the plain conjecture (`challenge_10_univ`,
`challenge_10_disprove`) and the parametrized `r`-partitioning game
(`challenge_10`).

A side assignment is a function `f : V → σ`. `neighboursInSide` and
`UnfriendlyAt` are generic in `σ`, with `sideVal : Bool → σ` embedding the two
sides:

* the plain conjecture uses **total** partitions `f : V → Bool` with
  `sideVal = id`;
* the game uses **partial** partitions `f : V → Option Bool` with
  `sideVal = some` (so `f y = some b` selects side `b`, and the `∃ b, f x = some b`
  clause of `UnfriendlyAt` additionally witnesses that `x` is assigned).

Neighbourhood sizes are compared by **injections**, so vertices of infinite
degree are handled correctly.
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

/-- Neighbours of `x` mapped to side `s` by the assignment `f : V → σ`. -/
def neighboursInSide {V : Type u} {σ : Type} (G : SimpleGraph V) (f : V → σ)
    (x : V) (s : σ) : Type u :=
  {y : V // G.Adj x y ∧ f y = s}

/-- A partition is unfriendly at `x` when `x` has at least as many neighbours in
the opposite class as in its own. `sideVal` embeds the two `Bool` sides into the
assignment codomain `σ` (`id` for a total `V → Bool` partition, `some` for a
partial `V → Option Bool` one); the `∃ b, f x = sideVal b` clause also records
that `x` is assigned a side. -/
def UnfriendlyAt {V : Type u} {σ : Type} (sideVal : Bool → σ)
    (G : SimpleGraph V) (f : V → σ) (x : V) : Prop :=
  ∃ b : Bool, f x = sideVal b ∧
    AtLeastAsMany
      (neighboursInSide G f x (sideVal !b))
      (neighboursInSide G f x (sideVal b))

/-- A total partition (`V → Bool`) unfriendly at every vertex. -/
def IsUnfriendlyPartition {V : Type u} (G : SimpleGraph V) (f : V → Bool) : Prop :=
  ∀ x : V, UnfriendlyAt id G f x

/-- **The Unfriendly Partition Conjecture** (Cowan and Emerson): every
countable graph has a partition that is unfriendly at every vertex. -/
def UnfriendlyPartitionConjecture : Prop :=
  ∀ {V : Type u}, Countable V → ∀ G : SimpleGraph V,
    ∃ f : V → Bool, IsUnfriendlyPartition G f
