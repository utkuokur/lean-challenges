import Mathlib

/-!
# Rota's Basis Conjecture — Universal Statement

For every `n` and every matroid of rank `n`, given `n` bases `B₁, …, Bₙ`,
can we always partition their union into `n` disjoint rainbow bases?

The conjecture is known for `n ≤ 3` and for several other special cases,
but the general statement remains open. This universal version asks for
a proof or disproof for all `n`.
-/

variable {α : Type} [Fintype α]

/-- `IsFamilyOfDisjointBases M B` witnesses that `B` is a family of `Fin n → Set α`
    where each `B i` is a basis of `M`. -/
def IsFamilyOfDisjointBases (M : Matroid α) (B : Fin n → Set α) : Prop :=
  (∀ i, M.IsBase (B i)) ∧ (Pairwise (Disjoint on B))

/--
Rota's basis conjecture (universal):
for all n, given n disjoint bases in a rank-n matroid, there exist n disjoint
rainbow bases.
-/
theorem challenge_7 : ∀ (n : ℕ), ∀ {M : Matroid α} (hrank : M.rank = n) {B : Fin n → Set α},
    IsFamilyOfDisjointBases M B →
    ∃ C : Fin n → Set α, IsFamilyOfDisjointBases M C ∧
      ∀ (i j : Fin n), (B i ∩ C j).ncard = 1 := by
  sorry
