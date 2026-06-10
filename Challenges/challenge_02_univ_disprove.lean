import Challenges.challenge_02_univ

/-!
# GF(pᵐ)-representable Matroids (Universal) — Disprove direction

To win this slot, exhibit a prime power `r = pᵐ` for which no
complete excluded-minor list for GF(pᵐ)-representability exists.
-/

open Function Matroid

namespace Disprove

theorem challenge_2 :
    ¬ ∀ (r p m : ℕ) [Fact p.Prime], 0 < m → r = p ^ m →
      ∃ L : Set (Matroid ℕ), CompleteExcludedMinorList p m L := sorry

end Disprove
