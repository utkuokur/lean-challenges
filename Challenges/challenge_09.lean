import Mathlib.Data.Finset.Card
import Mathlib.Algebra.Order.Field.Rat

universe u

namespace Challenge09

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

end Challenge09

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

/-- The challenge parameter. -/
def r : Nat := sorry

/--
Scaled union-closed sets conjecture:
for every nondegenerate finite union-closed family, some element has density at
least `1 / 2 - 1 / (r + 2)`.

At `r = 0` the bound is `0` and the statement is elementary; as `r` grows the
bound approaches `1 / 2`, recovering the full conjecture in the limit.
-/
theorem challenge_9 {U : Type u} [DecidableEq U]
    {F : Finset (Finset U)}
    (h_union_closed : Challenge09.IsUnionClosed F)
    (h_nontrivial : Challenge09.Nondegenerate F) :
    exists x, Challenge09.InGround F x /\
      Challenge09.density F x >= (1 / 2 : Rat) - 1 / ((r : Rat) + 2) := by
  sorry
