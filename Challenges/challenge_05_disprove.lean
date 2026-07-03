import Challenges.challenge_05_univ

/-!
# Erdős–Hajnal Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r` for which the Erdős–Hajnal
conjecture fails for the path graph `P_r`.
-/

open SimpleGraph

theorem challenge_5_disprove :
    ¬ ∀ r : ℕ, ErdosHajnalConjectureFor (pathGraph r) := sorry
