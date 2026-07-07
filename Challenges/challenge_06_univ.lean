import Challenges.challenge_06

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement
-/
theorem challenge_6_univ :
    ∀ r : Ordinal.{1},
      if r % 2 = 0
      then IsAlphaWQO PlanarGraph.MinorLE (r / 2)
      else IsAlphaWQO FiniteGraph.MinorLE (r / 2) := sorry
