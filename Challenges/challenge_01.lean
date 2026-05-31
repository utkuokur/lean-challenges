/-
## Introduction
This file challenges you to prove a special case for `r` of the Hadwiger's Conjecture (1943).

## Instructions
1. Replace `sorry` in `parameter_1` with a natural number.
2. Replace `sorry` in `challenge_1` with a complete proof, without changing the statement.
You may produce more files and import them.
-/

import Mathlib.Combinatorics.SimpleGraph.Coloring.VertexColoring
import Mathlib.Order.Filter.Defs
import Defs_and_Lems.VertexConnected
import Defs_and_Lems.Minor

variable {V W : Type*} [Fintype V]

open SimpleGraph

-- The `Minor` structure lives in `Defs_and_Lems/Minor.lean` so it can be
-- shared with challenge_06 (the BQO-under-minor problem).

-- The Hadwiger number of a graph is the largest r such that K_r is a minor of G.
noncomputable def hadwigerNumber (G : SimpleGraph V) : ℕ := by
  classical
  exact Nat.findGreatest (fun r => Nonempty (Minor (completeGraph (Fin r)) G)) (Fintype.card V)

/- Do not modify above this line. -/

def r : ℕ := sorry -- The challenge parameter

theorem challenge_1 (G : SimpleGraph V) :
  hadwigerNumber G ≤ r → G.Colorable (r + 1) := sorry
  -- 0=0 := sorry -- The proof
