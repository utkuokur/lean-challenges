import Matroid.Representation.Basic
import Matroid.Minor.Iso
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

open Function Matroid

universe u

variable {α : Type u}

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

/--
`L` is a complete list of excluded minors for GF(pᵐ)-representability:

* `L` is finite;
* every member of `L` is a finite matroid which is an excluded minor for
  GF(pᵐ)-representability;
* no two distinct members of `L` are isomorphic; and
* every finite matroid that is not GF(pᵐ)-representable has a minor
  isomorphic to a member of `L` (`≤i` is the iso-minor relation).

Members of `L` are matroids with ground sets in `ℕ`; matroids over an
arbitrary type are compared against `L` up to isomorphism. Together with
minimality, completeness forces `L` to contain exactly one representative of
each isomorphism class of excluded minors, so its cardinality is determined.
-/
def CompleteExcludedMinorList (p m : ℕ) [Fact p.Prime]
    (L : Set (Matroid ℕ)) : Prop :=
  L.Finite ∧
    (∀ N ∈ L, N.Finite ∧ IsExcludedMinorFor (IsGFRepresentable p m) N) ∧
      (∀ N₁ ∈ L, ∀ N₂ ∈ L, N₁ ≠ N₂ → IsEmpty (N₁ ≂ N₂)) ∧
        (∀ {β : Type u} (M : Matroid β), M.Finite →
          ¬ IsGFRepresentable p m M → ∃ N ∈ L, Nonempty (N ≤i M))

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

/-- The challenge parameter: the field size. Must be a prime power for
the conclusion to make sense — that requirement is part of the
theorem's hypothesis, not encoded into `r` itself. -/
def r : ℕ := sorry

/-- The number of excluded minors in the list, up to isomorphism. -/
def k : ℕ := sorry

/-- The excluded-minor list itself: finitely many matroids on ground sets
in `ℕ`. -/
def L : Set (Matroid ℕ) := sorry

/-- **The challenge.** For the chosen field size `r`, given any prime `p`
and positive exponent `m` with `r = pᵐ`, the chosen `L` is a complete list
of excluded minors for GF(pᵐ)-representability, and it has exactly `k`
members. -/
theorem challenge_2 (p m : ℕ) [Fact p.Prime] (hm : 0 < m) (hr : r = p ^ m) :
    CompleteExcludedMinorList p m L ∧ L.ncard = k := sorry
