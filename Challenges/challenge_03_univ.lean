import Challenges.challenge_03

open Filter

/- # Diagonal Ramsey numbers and exponential bounds
-/

theorem challenge_3_univ : ∀ r : ℕ, ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.98 : ℝ)^r ∧
 ∀ᶠ t in atTop, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t := sorry
