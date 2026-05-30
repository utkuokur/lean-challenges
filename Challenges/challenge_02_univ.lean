import Matroid.Representation.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# Excluded Minors of GF(pʳ)-representable Matroids — Universal Statement

For every prime `p` and every `r ≥ 1`, characterize the excluded minors for
representability over the finite field `GF(pʳ)`.

For `pʳ = 2` (binary matroids), the only excluded minor is `U₂,₄` (Tutte 1958).
For `pʳ = 3` (ternary matroids), the excluded minors are `U₂,₅`, `U₃,₅`, `F₇`,
and `F₇*` (Rota's theorem). Beyond that, the problem remains broadly open.

This universal version asks for a complete list of excluded minors that works
for ALL choices of `p` and `r`.
-/

open Function Matroid

variable {α : Type*}

/-- A matroid is GF(pʳ)-representable if it can be represented over the Galois
field of order `pʳ`. -/
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

/-- The universal excluded-minors challenge: for ALL primes `p` and ALL
exponents `r`, provide a complete list of excluded minors for
GF(pʳ)-representability. -/
theorem challenge_2 : ∀ (p r : ℕ) [Fact p.Prime],
    ∃ L : Set (Matroid α), CompleteExcludedMinorList (IsGFRepresentable p r) L := sorry
