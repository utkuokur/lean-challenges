/-
## How to submit
Do not edit or copy this file. In your own `Submission/Main.lean`, write
`import Challenges.challenge_01` to reuse the definitions below (such as
`hadwigerNumber`) instead of copying them, then state your `r` and
`theorem challenge_1` inside `namespace Submission`. See the submission guide
on the website for the full layout.
-/

import Mathlib.Combinatorics.SimpleGraph.Coloring.VertexColoring
import Defs_and_Lems.Minor

variable {V : Type*} [Fintype V]

open SimpleGraph

/- The Hadwiger number of a graph is the
largest r such that K_r is a minor of G. -/
noncomputable def hadwigerNumber (G : SimpleGraph V) : ℕ := by
  classical
  exact Nat.findGreatest (fun r =>
  Nonempty (Minor (completeGraph (Fin r)) G)) (Fintype.card V)

/-- Hadwiger's conjecture for parameter `r`: every graph whose Hadwiger number is
at most `r` is `r`-colorable. The single named statement shared by the canonical
theorem and the submission signature-shim. -/
def HadwigerColoringFor (r : ℕ) : Prop :=
  ∀ {V : Type*} [Fintype V] (G : SimpleGraph V),
    hadwigerNumber G ≤ r → G.Colorable r

/-- Hadwiger's conjecture, universal in the colour bound `r`. The single named
statement shared by the canonical theorem, the disprove slot, and the shims. -/
def HadwigerColoringUniv : Prop :=
  ∀ {V : Type*} [Fintype V] (G : SimpleGraph V),
    ∀ r : ℕ, hadwigerNumber G ≤ r → G.Colorable r

def r : ℕ := sorry -- The challenge parameter

theorem challenge_1 : HadwigerColoringFor r := sorry
