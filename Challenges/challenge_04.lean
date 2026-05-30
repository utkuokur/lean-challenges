import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Hom

/-!
# Sidorenko's Conjecture for Half-Graphs

For each `r`, the half-graph `H_r` is the bipartite graph on vertex set
`Fin r ⊕ Fin r` with `(Sum.inl i, Sum.inr j)` adjacent iff `i ≤ j`.

Sidorenko's conjecture for `H_r` states that for every graph `G`, the
number of homomorphisms `H_r → G` is at least the random-graph baseline
`(2 · |E(G)| / |V(G)|²)^{|E(H_r)|} · |V(G)|^{|V(H_r)|}`.

This file provides the canonical structure. **Maintainer: please
review and tighten the Sidorenko formulation below; the current
definition is a placeholder that uses a literal homomorphism count
inequality without normalizing constants.**
-/

open SimpleGraph

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- The half-graph `H_r` on `Fin r ⊕ Fin r`: an edge from the left side `i`
to the right side `j` iff `i ≤ j`. -/
def halfGraph (r : ℕ) : SimpleGraph (Sum (Fin r) (Fin r)) where
  Adj a b := match a, b with
    | Sum.inl i, Sum.inr j => i.val ≤ j.val
    | Sum.inr j, Sum.inl i => i.val ≤ j.val
    | _, _ => False
  symm := by
    intro a b h
    cases a <;> cases b <;> simp_all
  loopless := by
    intro a h
    cases a <;> simp_all

/-- Sidorenko's inequality for a forbidden bipartite graph `H` over `G`:
the homomorphism count from `H` to `G` is at least the random-graph baseline.

This is a placeholder formulation. The standard statement involves
homomorphism density `t(H, G) ≥ t(K₂, G)^{|E(H)|}`; encoding that
faithfully requires Mathlib's homomorphism-counting infrastructure. -/
def SidorenkoFor {W : Type*} [Fintype W] (H : SimpleGraph W)
    (G : SimpleGraph V) : Prop :=
  -- TODO(maintainer): replace this placeholder with the proper
  -- normalized homomorphism density inequality.
  Nonempty (H →g G)

/-- The challenge parameter. -/
def r : ℕ := sorry

/-- Sidorenko's conjecture for the half-graph `H_r`. -/
theorem challenge_4 : ∀ (G : SimpleGraph V), SidorenkoFor (halfGraph r) G := sorry
