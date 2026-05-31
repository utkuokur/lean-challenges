import Challenges.challenge_04_univ

/-!
# Sidorenko's Conjecture for Half-Graphs (Universal) — Disprove direction

To win this slot, exhibit an `r` and a graph `G` for which the
Sidorenko-type density inequality for the half-graph `H_r` fails.
-/

open SimpleGraph

namespace Disprove

theorem challenge_4 :
    ¬ ∀ {V : Type*} [Fintype V], ∀ r, ∀ (G : SimpleGraph V),
      SidorenkoFor (halfGraph r) G := sorry

end Disprove
