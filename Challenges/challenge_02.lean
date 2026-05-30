import Matroid.Representation.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

open Function Matroid

variable {α : Type*} (M : Matroid α) (X : Set α)

/-- A matroid is GF(p^r)-representable if it can be represented over
the Galois field of order p^r. -/
def IsGFRepresentable
    (p r : ℕ) [Fact p.Prime] (M : Matroid α) : Prop :=
  ∃ (W : Type) (_ : AddCommGroup W) (_ : Module (GaloisField p r) W),
    Nonempty (M.Rep (GaloisField p r) W)

/-- N is an excluded minor for the property P if N does not have P,
but every proper minor of N does. -/
def IsExcludedMinorFor (P : Matroid α → Prop) (M : Matroid α) : Prop :=
  ¬ P M ∧ ∀ N : Matroid α, N <m M → P N

/-- L is a complete list of excluded minors for P if every matroid lacking
P has some element of L as a minor. -/
def CompleteExcludedMinorList (P : Matroid α → Prop) (L : Set (Matroid α)) : Prop :=
  ∀ M : Matroid α, ¬ P M → ∃ N ∈ L, N ≤m M

/-- The prime characteristic used in this challenge instance. By default
we fix `p = 2`; users targeting other primes can override this and
prove for their chosen `p`. -/
def p : ℕ := 2

instance : Fact p.Prime := ⟨by unfold p; decide⟩

/-- The challenge parameter: the exponent in the field size, so the
field is GF(p^r). -/
def r : ℕ := sorry

/-- **The challenge.** Provide a list `L` of matroids and prove it is a
complete list of excluded minors for GF(p^r)-representability.

For r = 1 this is the classical excluded-minor problem for representability
over the prime field GF(p); for r > 1 it remains broadly open. -/
theorem challenge_2 :
    ∃ L : Set (Matroid α), CompleteExcludedMinorList (IsGFRepresentable p r) L := sorry
