import Challenges.challenge_03_univ

/-!
# Ramsey Numbers (Universal) — Disprove direction

To win this slot, exhibit an `r` for which no pair of real constants
`d₁, d₂` with `|d₁ - d₂| ≤ (4 - √2) · (0.9)^r` satisfies the
exponential Ramsey-number sandwich.
-/

open Filter

namespace Disprove

theorem challenge_3 :
    ¬ ∀ r : ℕ, ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.9 : ℝ)^r ∧
      ∀ᶠ t in atTop, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t := sorry

end Disprove
