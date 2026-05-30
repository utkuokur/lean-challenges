import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Maps

/-!
# Sidorenko's Conjecture for Half-Graphs

For each `r`, the half-graph `H_r` is the bipartite graph on vertex set
`Fin r ⊕ Fin r` with `(Sum.inl i, Sum.inr j)` adjacent iff `i ≤ j`.

Sidorenko's conjecture for `H_r` states that for every graph `G`, the
number of homomorphisms `H_r → G` is at least the random-graph baseline
`(2 · |E(G)| / |V(G)|²)^{|E(H_r)|} · |V(G)|^{|V(H_r)|}`.

This file provides the canonical structure. **Maintainer: please
review and tighten the Sidorenko formulation below. The current
definitions are placeholders so the file compiles; the actual
mathematical content needs to be written.**
-/

open SimpleGraph

variable {V : Type*} [Fintype V]

/-- The half-graph `H_r` on `Fin r ⊕ Fin r`. **Placeholder** — needs proper
    adjacency definition matching the standard `(Sum.inl i, Sum.inr j)
    adjacent iff i ≤ j` formulation. -/
noncomputable def halfGraph (r : ℕ) : SimpleGraph (Sum (Fin r) (Fin r)) :=
  sorry

/-- Sidorenko's inequality for a bipartite graph `H` and target graph `G`.

    **Placeholder** — the proper statement is the normalized
    homomorphism-density inequality
    `t(H, G) ≥ t(K₂, G)^{|E(H)|}`. -/
def SidorenkoFor {W : Type*} (H : SimpleGraph W) (G : SimpleGraph V) : Prop :=
  sorry

/-- The challenge parameter. -/
def r : ℕ := sorry

/-- Sidorenko's conjecture for the half-graph `H_r`. -/
theorem challenge_4 : ∀ (G : SimpleGraph V), SidorenkoFor (halfGraph r) G := sorry
