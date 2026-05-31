import Challenges.challenge_07_univ

/-!
# Rota's Basis Conjecture (Universal) — Disprove direction

To win this slot, exhibit `n`, a rank-`n` matroid `M`, and a family
of `n` disjoint bases for which no system of `n` disjoint rainbow
bases (each meeting every original basis in a singleton) exists.

`α` is a free file-level variable, mirroring the univ partner's
structure. The disprove user picks a concrete `α` (e.g. `Fin r`,
`ℕ`, …) when they construct their counterexample.
-/

open Function Matroid

variable {α : Type} [Fintype α]

namespace Disprove

theorem challenge_7 :
    ¬ ∀ (n : ℕ), ∀ {M : Matroid α} (_ : M.eRank = (n : ℕ∞))
      {B : Fin n → Set α},
      IsFamilyOfDisjointBases M B →
      ∃ C : Fin n → Set α, IsFamilyOfDisjointBases M C ∧
        ∀ (i j : Fin n), (B i ∩ C j).ncard = 1 := sorry

end Disprove
