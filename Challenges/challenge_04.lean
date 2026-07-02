import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Bipartite
import Mathlib.Data.Set.Card
import Defs_and_Lems.Sidorenko

/-!
# Sidorenko's Conjecture for Bipartite Graphs with Bounded Sides — Universal Statement

Sidorenko's conjecture states that for every bipartite graph `H` and every
graph `G`, the homomorphism-density inequality `t(H, G) ≥ t(K₂, G) ^ e(H)`
holds.

This challenge is the scaled weakening that bounds the two sides of the
bipartition: for a parameter `k`, we restrict to bipartite graphs `H` admitting
a bipartition `V(H) = X ∪ Y` with `|X| ≤ k` and `|Y| ≤ k`. As `k → ∞` this
class exhausts all finite bipartite graphs, so the family interpolates between
small, tractable cases and the full conjecture. The universal version below
asks for a proof or disproof for every `k`.

`homDensity` and `SidorenkoFor` live in `Defs_and_Lems/Sidorenko.lean`.
-/

open SimpleGraph

variable {W V : Type} [Fintype W] [Fintype V] (H : SimpleGraph W) (G : SimpleGraph V)

/-
`H` is *bipartite with sides bounded by `k`*: it admits a bipartition
`V(H) = X ∪ Y` (Mathlib's `IsBipartiteWith`, i.e. `X`, `Y` disjoint and every
edge runs between them) covering all vertices, with `|X| ≤ k` and `|Y| ≤ k`.
-/
def BipartiteBoundedBy {W : Type*} (H : SimpleGraph W) (k : ℕ) : Prop :=
  ∃ X Y : Set W,
    H.IsBipartiteWith X Y ∧ X ∪ Y = Set.univ ∧ X.ncard ≤ k ∧ Y.ncard ≤ k

def r : ℕ := sorry

/-- The universal Sidorenko conjecture for bipartite graphs with bounded sides:
for every bound `r`, the conjecture holds for every such graph.

The host graph is required to be nonempty: on an empty host `homDensity`
degenerates to `0 / 0 = 0` while for an edgeless (still bipartite, e.g. a
single vertex with sides `{0}, ∅`) graph `H` the right-hand side is
`0 ^ 0 = 1`, so the unguarded statement would be false for degenerate
reasons whenever `r ≥ 1`. -/
theorem challenge_4 [Nonempty V] : BipartiteBoundedBy H r → SidorenkoFor H G := sorry
