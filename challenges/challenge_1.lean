/-
# Hadwiger Number Challenge

A Lean 4 formalization challenge. Fill in the sorries below.

## The Problem

The Hadwiger number `h(G)` of a graph `G` is the largest integer `t`
such that the complete graph `K_t` is a minor of `G`.

Hadwiger's Conjecture (1943): every graph with no `K_t` minor is `(t-1)`-colorable.

This file challenges you to prove a special case for `k = 2`.

## What you need to do

2. Replace `sorry` in `hadwiger_challenge` with a complete proof.

No other `sorry` tactics are permitted in your submission.
-/

import Mathlib.Combinatorics.SimpleGraph.Coloring.VertexColoring
import Mathlib.Order.Filter.Defs
import Defs_and_Lems.VertexConnected

variable {V W : Type*} [Fintype V]

open SimpleGraph

/-- The data witnessing that `H` is a minor of `G`, as simple graphs. -/
structure Minor (H : SimpleGraph W) (G : SimpleGraph V) where
  /-- The branch sets of the minor.

  Seeing the minor as a quotient graph, `branchSet w` is exactly the fiber of `w` under the quotient
  map. -/
  branchSet : W → Set V
  /-- The branch sets are pairwise disjoint. -/
  pairwise_disjoint_branchSet : Pairwise fun w₁ w₂ ↦ Disjoint (branchSet w₁) (branchSet w₂)
  /-- Each branch set is connected (in particular nonempty). -/
  connectedOn_branchSet (w : W) : G.ConnectedOn (branchSet w)
  /-- Adjacency in the minor induce adjacency between some points of the corresponding branch set.
  -/
  exists_mem_branchSet_of_adj ⦃w₁ w₂ : W⦄ :
    H.Adj w₁ w₂ → ∃ v₁ ∈ branchSet w₁, ∃ v₂ ∈ branchSet w₂, G.Adj v₁ v₂

-- The Hadwiger number of a graph is the largest r such that K_r is a minor of G.
noncomputable def hadwigerNumber (G : SimpleGraph V) : ℕ := by
  classical
  exact Nat.findGreatest (fun r => Nonempty (Minor (completeGraph (Fin r)) G)) (Fintype.card V)

/- Do not modify above this line. -/

-- The challenge parameter
def r : ℕ := 2

-- hadwigerNumber G ≤ r → G.Colorable (r + 1) := by
theorem challenge_1 (G : SimpleGraph V) :
  hadwigerNumber G ≤ r → G.Colorable (r + 1) := by
  sorry
