import Mathlib.Combinatorics.SimpleGraph.Basic

/-!
# Shared definitions for the Unfriendly Partition Conjecture
-/

universe u v

/- An injection-based comparison of cardinalities. -/
def InjectsInto (A : Type u) (B : Type v) : Prop :=
  ∃ e : A → B, Function.Injective e

/- `A` has at least as many elements as `B`. -/
def AtLeastAsMany (A : Type u) (B : Type v) : Prop :=
  InjectsInto B A

theorem atLeastAsMany_refl (A : Type u) : AtLeastAsMany A A :=
  ⟨id, fun _ _ h => h⟩

/- Neighbours of `x` mapped to side `s` by the assignment `f : V → σ`. -/
def neighboursInSide {V : Type u} {σ : Type} (G : SimpleGraph V) (f : V → σ)
    (x : V) (s : σ) : Type u :=
  {y : V // G.Adj x y ∧ f y = s}

/- A partition is unfriendly at `x` when `x` has at least as many neighbours in
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

/- A partition that assigns every vertex a side and is unfriendly at every
vertex.  The first conjunct is totality: for `sideVal = id` (a total
`V → Bool` partition) it is automatic, and for `sideVal = some` (a partial
`V → Option Bool` partition) it is `IsPartition f`. -/
def IsUnfriendlyPartition {V : Type u} {σ : Type} (sideVal : Bool → σ)
    (G : SimpleGraph V) (f : V → σ) : Prop :=
  (∀ v : V, ∃ b : Bool, f v = sideVal b) ∧ ∀ x : V, UnfriendlyAt sideVal G f x
