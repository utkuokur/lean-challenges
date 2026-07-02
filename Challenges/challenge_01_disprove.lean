import Challenges.challenge_01

/-!
# The Hadwiger Conjecture (Universal) — Disprove direction
-/

open SimpleGraph

theorem challenge_1_disprove :
    ¬ ∀ {V : Type*} [Fintype V] (G : SimpleGraph V),
      ∀ r, hadwigerNumber G ≤ r → G.Colorable r := sorry
