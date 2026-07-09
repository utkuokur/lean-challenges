import Challenges.challenge_04

/-!
# Sidorenko's Conjecture for Bipartite Graphs with Bounded Sides
# Universal Statement
-/

open SimpleGraph

/-- Bounded-side Sidorenko conjecture, universal in the parameter `r`. The single
named statement shared by the canonical theorem and the submission shim. -/
def SidorenkoBoundedUniv : Prop :=
  ∀ {W V : Type} [Fintype W] [Fintype V] [Nonempty V],
    ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
    BipartiteBoundedBy H r → SidorenkoFor H G

theorem challenge_4_univ : SidorenkoBoundedUniv := sorry
