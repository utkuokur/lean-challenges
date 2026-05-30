import Mathlib

/-!
# Union-Closed Sets Conjecture — Universal Statement

In any finite union-closed family of sets, there exists an element that
belongs to at least half of the sets.

The conjecture has been verified for families up to certain sizes. A general
proof or counterexample would be a major result in extremal combinatorics.

This universal version asks you to prove or disprove for ALL r: there exists
an element with density at least 1/2 - 1/r in every nondegenerate union-closed
family.
-/

namespace Challenge09

open Finset

variable (U : Type) [Fintype U] [DecidableEq U]

/-- A family F over universe U. -/
def InGround (F : Finset (Finset U)) (x : U) : Prop :=
  ∃ s ∈ F, x ∈ s

/-- The density of element x in family F. -/
def density (F : Finset (Finset U)) (x : U) : Rat :=
  ((F.filter fun s => x ∈ s).card : Rat) / (max 1 F.card : Rat)

/-- F is union-closed if the union of any two members is in F. -/
def IsUnionClosed (F : Finset (Finset U)) : Prop :=
  ∀ ⦃s t : Finset U⦄, s ∈ F → t ∈ F → s ∪ t ∈ F

/-- The two degenerate families excluded from the union-closed sets conjecture. -/
def Nondegenerate (F : Finset (Finset U)) : Prop :=
  F ≠ ∅ ∧ F ≠ {∅}

/-- The universal union-closed sets conjecture:
    for every r > 2, every nondegenerate finite union-closed family
    has an element with density at least 1/2 - 1/r. -/
theorem challenge_9 :
    ∀ (r : Nat) (_ : 2 < r) {F : Finset (Finset U)}
    (_ : IsUnionClosed F) (_ : Nondegenerate F),
    ∃ x, InGround F x ∧ density F x ≥ (1 / 2 : Rat) - 1 / (r : Rat) := by
  sorry

end Challenge09
