import Mathlib.Combinatorics.Matroid.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Archimedean

open Function Matroid

variable {α : Type*} {n : ℕ}

/-- A family of `n` bases of `M` that are pairwise disjoint -/
def IsFamilyOfDisjointBases (M : Matroid α) (B : Fin n → Set α) : Prop :=
  (∀ i, M.IsBase (B i)) ∧ (Pairwise (Disjoint on B))

/-- **Rota's Basis Conjecture**

Given a finite matroid `M` with `n` disjoint bases `B₁,…,Bₙ`,
there exist `n` disjoint bases `C₁,…,Cₙ` such that each `Bᵢ ∩ Cⱼ`
is a singleton. -/
theorem rotas_basis_conjecture {M : Matroid α} {B : Fin n → Set α}
    (hB : IsFamilyOfDisjointBases M B) :
    ∃ C : Fin n → Set α,
      IsFamilyOfDisjointBases M C ∧
      ∀ (i j : Fin n), (B i ∩ C j).ncard = 1 := by
  sorry

/-- **Scaled weakening of Rota's Basis Conjecture**

For any `r ∈ ℕ`, there exists `n₀` such that for all `n ≥ n₀`,
for any finite matroid `M` with `n` disjoint bases `B₁,…,Bₙ`,
and for any `ε > 0`, there exist `⌈(1 - 1/r - ε)·n⌉` disjoint bases
`C₁,…,C_{⌈(1-1/r-ε)·n⌉}` such that each `Bᵢ ∩ Cⱼ` is a singleton.

The conjecture predicts that as `r → ∞` (i.e. as we allow the fraction
to approach 1), we recover the original Rota conjecture in the limit. -/
theorem scaled_weakening_rotas_conjecture (r : ℕ) (hr : r > 0) :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ {M : Matroid α} {B : Fin n → Set α},
      IsFamilyOfDisjointBases M B →
      ∀ (ε : ℝ), ε > 0 →
        let m := Nat.ceil ((1 - 1 / (r : ℝ) - ε) * (n : ℝ))
        ∃ C : Fin m → Set α,
          IsFamilyOfDisjointBases M C ∧
          ∀ (i : Fin n) (j : Fin m), (B i ∩ C j).ncard = 1 := by
  sorry

/-- Bucić, Kwan, Pokrovskiy and Sudakov (2020) proved the scaled weakening
for `r = 2`, i.e. one can find `⌈(1/2 - ε)·n⌉` disjoint bases. -/
theorem scaled_weakening_r_eq_two :
    ∃ n₀ : ℕ, ∀ n ≥ n₀, ∀ {M : Matroid α} {B : Fin n → Set α},
      IsFamilyOfDisjointBases M B →
      ∀ (ε : ℝ), ε > 0 →
        let m := Nat.ceil ((1 / 2 - ε) * (n : ℝ))
        ∃ C : Fin m → Set α,
          IsFamilyOfDisjointBases M C ∧
          ∀ (i : Fin n) (j : Fin m), (B i ∩ C j).ncard = 1 := by
  sorry
