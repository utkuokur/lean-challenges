import Mathlib.Data.Finset.Card
import Mathlib.Algebra.Order.Field.Rat

universe u

variable {U : Type u} [DecidableEq U]

/-- A finite family of finite sets is union-closed. -/
def IsUnionClosed (F : Finset (Finset U)) : Prop :=
  forall A, A ∈ F -> forall B, B ∈ F -> A ∪ B ∈ F

/-- An element belongs to the ground set covered by the family. -/
def InGround (F : Finset (Finset U)) (x : U) : Prop :=
  exists A, A ∈ F ∧ x ∈ A

/-- The number of members of the family containing `x`. -/
def occurrences (F : Finset (Finset U)) (x : U) : Nat :=
  (F.filter fun A => x ∈ A).card

/-- The density of an element with respect to a finite family. -/
def density (F : Finset (Finset U)) (x : U) : Rat :=
  (occurrences F x : Rat) / F.card

/-- The two degenerate families excluded from the union-closed sets conjecture. -/
def Nondegenerate (F : Finset (Finset U)) : Prop :=
  F ≠ ∅ /\ F ≠ {∅}

/-- Scaled union-closed sets conjecture for parameter `r`: every nondegenerate
finite union-closed family has an element of density at least `1/2 - 1/(r + 2)`.
The single named statement shared by the canonical theorem and the submission
signature-shim. -/
def statement_09 (r : ℕ) : Prop :=
  ∀ {U : Type u} [DecidableEq U] {F : Finset (Finset U)},
    IsUnionClosed F → Nondegenerate F →
      ∃ x, InGround F x ∧ density F x ≥ (1 / 2 : Rat) - 1 / ((r : Rat) + 2)

/- The challenge parameter. -/
def r : Nat := sorry

theorem challenge_9 : statement_09.{u} r := by
  sorry
