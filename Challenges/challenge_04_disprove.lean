import Challenges.challenge_04

/-!
# Sidorenko for Bounded-Side Bipartite Graphs — Disprove direction
-/

open SimpleGraph

/-- Disprove direction: exhibit types `W V` (with no nonemptiness hypothesis on
`V`) on which the bounded-side Sidorenko statement fails for some parameter. The
single named statement shared by the canonical theorem and the submission shim. -/
def SidorenkoBoundedDisprove : Prop :=
  ∀ {W V : Type} [Fintype W] [Fintype V],
    ¬ ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
    BipartiteBoundedBy H r → SidorenkoFor H G

theorem challenge_4_disprove : SidorenkoBoundedDisprove := sorry
