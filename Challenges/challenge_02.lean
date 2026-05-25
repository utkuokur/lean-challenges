import Matroid.Representation.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

open Function Matroid

variable {α : Type*} (M : Matroid α) (X : Set α)

/- Complex-representable matroid -/
def IsGFRepresentable
    (p r : ℕ) [Fact p.Prime] (M : Matroid α) : Prop :=
  ∃ (W : Type) (_ : AddCommGroup W) (_ : Module (GaloisField p r) W),
    Nonempty (M.Rep (GaloisField p r) W)


------------------------------------------
def IsExcludedMinorFor (P : Matroid α → Prop) (M : Matroid α) : Prop :=
  ¬ P M ∧ ∀ N : Matroid α, N <m M → P N

def CompleteExcludedMinorList (P : Matroid α → Prop) (L : Set (Matroid α)) : Prop :=
  ∀ M : Matroid α, ¬ P M → ∃ N ∈ L, N ≤m M
