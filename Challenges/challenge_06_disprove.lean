import Challenges.challenge_06

/-!
# α-WQO of Finite Graphs
# Disprove direction
-/

theorem challenge_6_disprove :
    ¬ ∀ r : Ordinal.{1},
    if r % 2 = 0
    then IsAlphaWQO PlanarGraph.MinorLE (r / 2)
    else IsAlphaWQO FiniteGraph.MinorLE (r / 2) := sorry
