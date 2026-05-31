import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Maps
import Defs_and_Lems.Sidorenko

/-!
# Sidorenko's Conjecture for Half-Graphs — Universal Statement

For every `r`, the half-graph `H_r` is the bipartite graph on
`Fin r ⊕ Fin r` with `(Sum.inl i, Sum.inr j)` adjacent iff `i ≤ j`.

Sidorenko's conjecture states that for every bipartite `H` and every `G`,
`t(H, G) ≥ t(K₂, G)^{|E(H)|}` (homomorphism-density inequality).

This universal version asks for a proof or disproof for ALL r.

`halfGraph`, `homDensity`, and `SidorenkoFor` live in
`Defs_and_Lems/Sidorenko.lean`, shared with `challenge_04`.
-/

open SimpleGraph

variable {V : Type*} [Fintype V]

/-- Sidorenko's conjecture for all half-graphs. -/
theorem challenge_4 : ∀ r, ∀ (G : SimpleGraph V), SidorenkoFor (halfGraph r) G := sorry
