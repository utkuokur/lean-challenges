import Challenges.challenge_05_univ

/-!
# Erdős–Hajnal Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r` for which the Erdős–Hajnal
conjecture fails for the path graph `P_r`.
-/

open SimpleGraph

namespace Disprove

theorem challenge_5 :
    ¬ ∀ r : ℕ, ErdosHajnalConjectureFor (pathGraph r) := sorry

end Disprove
