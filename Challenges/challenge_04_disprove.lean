import Challenges.challenge_04

/-!
# Sidorenko for Bounded-Side Bipartite Graphs — Disprove direction
-/

open SimpleGraph

variable {W V : Type} [Fintype W] [Fintype V]

theorem challenge_4_disprove :
    ¬ ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
    BipartiteBoundedBy H r → SidorenkoFor H G := sorry
