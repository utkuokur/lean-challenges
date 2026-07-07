import Challenges.challenge_03

/-!
# Ramsey Numbers  — Disprove direction
-/

open Filter

theorem challenge_3_disprove :
    ¬ ∀ r : ℕ, ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.98 : ℝ)^r ∧
      ∀ᶠ t in atTop, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t := sorry
