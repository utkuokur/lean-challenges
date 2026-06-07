/-
## Introduction
This file challenges you to prove Hadwiger's Conjecture (1943) for all `r`
(the universal form) — there is no single parameter to pick.

## How to submit
Don't edit or copy this file. In your own `Submission/Main.lean`, write
`import Challenges.challenge_01_univ` to reuse the definitions below instead of
copying them, then state your `theorem challenge_1` inside `namespace Submission`.
See the submission guide on the website for the full layout.
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

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

theorem challenge_1 (G : SimpleGraph V) :
  ∀ r, hadwigerNumber G ≤ r → G.Colorable (r + 1) := sorry
