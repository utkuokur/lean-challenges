/-
## Introduction
This file challenges you to prove a special case for `r` of the Hadwiger's Conjecture (1943).

## How to submit
Don't edit or copy this file. In your own `Submission/Main.lean`, write
`import Challenges.challenge_01` to reuse the definitions below (such as
`hadwigerNumber`) instead of copying them, then state your `r` and
`theorem challenge_1` inside `namespace Submission`. See the submission guide
on the website for the full layout.
-/

import Mathlib.Combinatorics.SimpleGraph.Coloring.VertexColoring
import Mathlib.Order.Filter.Defs
import Defs_and_Lems.VertexConnected
import Defs_and_Lems.Minor

variable {V W : Type*} [Fintype V]

open SimpleGraph

-- The Hadwiger number of a graph is the largest r such that K_r is a minor of G.
noncomputable def hadwigerNumber (G : SimpleGraph V) : ℕ := by
  classical
  exact Nat.findGreatest (fun r => Nonempty (Minor (completeGraph (Fin r)) G)) (Fintype.card V)

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

def r : ℕ := sorry -- The challenge parameter

theorem challenge_1 (G : SimpleGraph V) :
  hadwigerNumber G ≤ r → G.Colorable r := sorry
