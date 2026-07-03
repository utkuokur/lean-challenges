import Challenges.challenge_04_univ

/-!
# Sidorenko for Bounded-Side Bipartite Graphs (Universal) — Disprove direction

To win this slot, exhibit a bound `r`, a bipartite graph `H` with both sides
of size at most `r`, and a nonempty host graph `G` for which the
Sidorenko-type density inequality fails — i.e. disprove Sidorenko's
conjecture.
-/

open SimpleGraph

theorem challenge_4_disprove :
    ¬ ∀ {W V : Type} [Fintype W] [Fintype V] [Nonempty V],
      ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
        BipartiteBoundedBy H r → SidorenkoFor H G := sorry
