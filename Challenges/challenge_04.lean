import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Maps
import Defs_and_Lems.Sidorenko

/-!
# Sidorenko's Conjecture for Half-Graphs

For each `r`, the half-graph `H_r` is the bipartite graph on vertex set
`Fin r ⊕ Fin r` with `(Sum.inl i, Sum.inr j)` adjacent iff `i ≤ j`.

Sidorenko's conjecture for `H_r` states that for every graph `G`, the
homomorphism density `t(H_r, G)` is at least `t(K₂, G)^{|E(H_r)|}`.

`halfGraph`, `homDensity`, and `SidorenkoFor` live in
`Defs_and_Lems/Sidorenko.lean` so they are shared with `challenge_04_univ`.
-/

open SimpleGraph

variable {V : Type*} [Fintype V]

/-- The challenge parameter. -/
def r : ℕ := sorry

/-- Sidorenko's conjecture for the half-graph `H_r`. -/
theorem challenge_4 : ∀ (G : SimpleGraph V), SidorenkoFor (halfGraph r) G := sorry
