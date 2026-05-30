import Matroid.Representation.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

open Function Matroid

variable {α : Type*}

/-- A matroid is GF(pᵐ)-representable if it can be represented over the
Galois field of order `p^m` (where `p` is prime). -/
def IsGFRepresentable
    (p m : ℕ) [Fact p.Prime] (M : Matroid α) : Prop :=
  ∃ (W : Type) (_ : AddCommGroup W) (_ : Module (GaloisField p m) W),
    Nonempty (M.Rep (GaloisField p m) W)

/-- N is an excluded minor for the property P if N does not have P,
but every proper minor of N does. -/
def IsExcludedMinorFor (P : Matroid α → Prop) (M : Matroid α) : Prop :=
  ¬ P M ∧ ∀ N : Matroid α, N <m M → P N

/-- L is a complete list of excluded minors for P if every matroid lacking
P has some element of L as a minor. -/
def CompleteExcludedMinorList (P : Matroid α → Prop) (L : Set (Matroid α)) : Prop :=
  ∀ M : Matroid α, ¬ P M → ∃ N ∈ L, N ≤m M

/-- The challenge parameter: the field size. Must be a prime power for
the conclusion to make sense — that requirement is part of the
theorem's hypothesis, not encoded into `r` itself. -/
def r : ℕ := sorry

/-- **The challenge.** For the chosen field size `r`, given any prime `p`
and exponent `m` with `r = pᵐ`, provide a complete list of excluded
minors for GF(pᵐ)-representability. -/
theorem challenge_2 (p m : ℕ) [Fact p.Prime] (hr : r = p ^ m) :
    ∃ L : Set (Matroid α), CompleteExcludedMinorList (IsGFRepresentable p m) L := sorry
