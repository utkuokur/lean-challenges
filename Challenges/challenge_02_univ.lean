import Matroid.Representation.Basic
import Matroid.Minor.Iso
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# Excluded Minors of GF(pᵐ)-representable Matroids — Universal Statement (Rota's conjecture)

For every prime power `r = pᵐ`, a complete finite list of excluded minors for
representability over the finite field `GF(pᵐ)` exists.

NOTE: This is **not an open problem**. The statement is Rota's excluded-minor
conjecture — that the excluded-minor set is finite for every finite field —
**proved** by Geelen, Gerards, and Whittle. Unlike the parametrized, genuinely
open `challenge_02.lean` (which asks for the *explicit* list at a fixed `r`,
unknown for `r ≥ 5`), the universal *existence* claim is a settled theorem. This
slot is therefore a **formalization target** — discharge it by formalizing /
citing GGW — rather than a prove-or-disprove open challenge. There is
deliberately no `_disprove` counterpart: the negation is false, so that slot
would be unwinnable.

For `r = 2` (binary matroids), the only excluded minor is `U₂,₄` (Tutte 1958).
For `r = 3` (ternary matroids), the excluded minors are `U₂,₅`, `U₃,₅`, `F₇`,
and `F₇*` (Reid; Bixby; Seymour).
-/

open Function Matroid

universe u

variable {α : Type u}

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

/--
`L` is a complete list of excluded minors for GF(pᵐ)-representability:

* `L` is finite;
* every member of `L` is a finite matroid which is an excluded minor for
  GF(pᵐ)-representability;
* no two distinct members of `L` are isomorphic; and
* every finite matroid that is not GF(pᵐ)-representable has a minor
  isomorphic to a member of `L` (`≤i` is the iso-minor relation).

Members of `L` are matroids with ground sets in `ℕ`; matroids over an
arbitrary type are compared against `L` up to isomorphism.
-/
def CompleteExcludedMinorList (p m : ℕ) [Fact p.Prime]
    (L : Set (Matroid ℕ)) : Prop :=
  L.Finite ∧
    (∀ N ∈ L, N.Finite ∧ IsExcludedMinorFor (IsGFRepresentable p m) N) ∧
      (∀ N₁ ∈ L, ∀ N₂ ∈ L, N₁ ≠ N₂ → IsEmpty (N₁ ≂ N₂)) ∧
        (∀ {β : Type u} (M : Matroid β), M.Finite →
          ¬ IsGFRepresentable p m M → ∃ N ∈ L, Nonempty (N ≤i M))

/- **Rota's conjecture (Geelen–Gerards–Whittle), as a formalization target.**
For every prime-power field size `r = pᵐ` (witnessed by a prime `p` and positive
exponent `m`), a complete finite list of excluded minors for
GF(pᵐ)-representability exists. This is a proved theorem, not an open problem;
the task in this slot is to formalize it. -/
theorem challenge_2_univ (r p m : ℕ) [Fact p.Prime] (hm : 0 < m) (hr : r = p ^ m) :
    ∃ L : Set (Matroid ℕ), CompleteExcludedMinorList p m L := sorry
