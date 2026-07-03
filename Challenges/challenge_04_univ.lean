import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Bipartite
import Mathlib.Data.Set.Card
import Defs_and_Lems.Sidorenko

/-!
# Sidorenko's Conjecture for Bipartite Graphs with Bounded Sides — Universal Statement

Sidorenko's conjecture states that for every bipartite graph `H` and every
graph `G`, the homomorphism-density inequality `t(H, G) ≥ t(K₂, G) ^ e(H)`
holds.

This is the ∀r form of `challenge_04`: for EVERY bound `r`, the conjecture
holds for every bipartite `H` whose bipartition sides both have at most `r`
vertices.  Since every finite bipartite graph has both sides bounded by some
`r`, this is equivalent to the full (open) Sidorenko conjecture.

The host graph is required to be nonempty for the same degenerate-case reason
as in `challenge_04`: on an empty host `homDensity` is `0 / 0 = 0` while for an
edgeless bipartite `H` the right-hand side is `0 ^ 0 = 1`.

`homDensity`, `SidorenkoFor`, and `BipartiteBoundedBy` live in
`Defs_and_Lems/Sidorenko.lean`, shared with `challenge_04`.
-/

open SimpleGraph

variable {W V : Type} [Fintype W] [Fintype V]

/-- The universal Sidorenko conjecture for bipartite graphs with bounded
sides: for every bound `r`, every bipartite graph with sides bounded by `r`
satisfies Sidorenko's inequality over every nonempty host. -/
theorem challenge_4_univ [Nonempty V] :
    ∀ r : ℕ, ∀ (H : SimpleGraph W) (G : SimpleGraph V),
      BipartiteBoundedBy H r → SidorenkoFor H G := sorry
