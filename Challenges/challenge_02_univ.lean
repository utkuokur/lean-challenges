import Matroid.Representation.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# Excluded Minors of GF(pᵐ)-representable Matroids — Universal Statement

For every prime power `r = pᵐ`, characterize the excluded minors for
representability over the finite field `GF(pᵐ)`.

For `r = 2` (binary matroids), the only excluded minor is `U₂,₄` (Tutte 1958).
For `r = 3` (ternary matroids), the excluded minors are `U₂,₅`, `U₃,₅`, `F₇`,
and `F₇*` (Rota's theorem). Beyond that, the problem remains broadly open.

This universal version asks for a complete list of excluded minors that
works for ALL prime-power field sizes — i.e., for every `r` accompanied
by a witness `(p, m)` such that `p` is prime and `r = pᵐ`.
-/

open Function Matroid

variable {α : Type*}

/-- A matroid is GF(pᵐ)-representable if it can be represented over the
Galois field of order `p^m`. -/
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

/-- The universal challenge: for every field size `r` that is a prime
power (witnessed by some prime `p` and exponent `m` with `r = pᵐ`),
provide a complete list of excluded minors for GF(pᵐ)-representability. -/
theorem challenge_2 (r p m : ℕ) [Fact p.Prime] (hr : r = p ^ m) :
    ∃ L : Set (Matroid α), CompleteExcludedMinorList (IsGFRepresentable p m) L := sorry
