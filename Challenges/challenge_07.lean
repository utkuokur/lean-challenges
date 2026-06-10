import Mathlib.Combinatorics.Matroid.Basic
import Mathlib.Combinatorics.Matroid.Rank.ENat
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Archimedean

open Function Matroid

variable {α : Type*} {n : ℕ}

/-- A family of `n` bases of `M` that are pairwise disjoint -/
def IsFamilyOfDisjointBases (M : Matroid α) (B : Fin n → Set α) : Prop :=
  (∀ i, M.IsBase (B i)) ∧ (Pairwise (Disjoint on B))

/-- **Rota's Basis Conjecture (original form)**

Given a finite matroid `M` of rank `n` with `n` disjoint bases `B₁,…,Bₙ`,
there exist `n` disjoint bases `C₁,…,Cₙ` such that each `Bᵢ ∩ Cⱼ` is a
singleton. -/
theorem rotas_basis_conjecture {M : Matroid α} (hfin : M.Finite)
    (hrank : M.eRank = (n : ℕ∞)) {B : Fin n → Set α}
    (hB : IsFamilyOfDisjointBases M B) :
    ∃ C : Fin n → Set α,
      IsFamilyOfDisjointBases M C ∧
      ∀ (i j : Fin n), (B i ∩ C j).ncard = 1 := by
  sorry

/-- Bucić, Kwan, Pokrovskiy and Sudakov (2020) proved a scaled weakening
for the special case `r = 2`. -/
theorem scaled_weakening_r_eq_two :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ {M : Matroid α} (_ : M.Finite)
      (_ : M.eRank = (n : ℕ∞)) {B : Fin n → Set α},
      IsFamilyOfDisjointBases M B →
      ∀ (ε : ℝ), ε > 0 →
        let m := Nat.ceil ((1 / 2 - ε) * (n : ℝ))
        ∃ C : Fin m → Set α,
          IsFamilyOfDisjointBases M C ∧
          ∀ (i : Fin n) (j : Fin m), (B i ∩ C j).ncard = 1 := by
  sorry

/-- The challenge parameter. -/
def r : ℕ := sorry

/-- **Scaled weakening of Rota's Basis Conjecture for the chosen `r`**

For the parameter `r > 0`, there exists `n₀` such that for all `n ≥ n₀`,
for any finite matroid `M` of rank `n` with `n` disjoint bases `B₁,…,Bₙ`,
and for any `ε > 0`, there exist `⌈(1 - 1/r - ε)·n⌉` disjoint bases
`C₁,…,C_m` such that each `Bᵢ ∩ Cⱼ` is a singleton.

As `r → ∞`, the fraction `1 - 1/r` approaches 1 and the statement
recovers the original Rota conjecture in the limit. -/
theorem challenge_7 (hr : r > 0) :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ {M : Matroid α} (_ : M.Finite)
      (_ : M.eRank = (n : ℕ∞)) {B : Fin n → Set α},
      IsFamilyOfDisjointBases M B →
      ∀ (ε : ℝ), ε > 0 →
        let m := Nat.ceil ((1 - 1 / (r : ℝ) - ε) * (n : ℝ))
        ∃ C : Fin m → Set α,
          IsFamilyOfDisjointBases M C ∧
          ∀ (i : Fin n) (j : Fin m), (B i ∩ C j).ncard = 1 := by
  sorry
