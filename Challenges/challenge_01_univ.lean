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
import Defs_and_Lems.VertexConnected
import Defs_and_Lems.Minor

variable {V W : Type*} [Fintype V]

open SimpleGraph

/- The Hadwiger number of a graph is the largest r such that K_r is a minor of G. -/
noncomputable def hadwigerNumber (G : SimpleGraph V) : ℕ := by
  classical
  exact Nat.findGreatest (fun r => Nonempty (Minor (completeGraph (Fin r)) G)) (Fintype.card V)

theorem challenge_1_univ (G : SimpleGraph V) :
  ∀ r, hadwigerNumber G ≤ r → G.Colorable r := sorry
