import Challenges.challenge_04

/-!
# Sidorenko's Conjecture for Bipartite Graphs with Bounded Sides
# Universal Statement
-/

open SimpleGraph

variable {W V : Type} [Fintype W] [Fintype V] [Nonempty V]

theorem challenge_4_univ :
    ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
    BipartiteBoundedBy H r → SidorenkoFor H G := sorry
