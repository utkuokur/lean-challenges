import Challenges.challenge_06_univ

/-!
# BQO of Finite Graphs (Universal) — Disprove direction

To win this slot, show that the class of all finite simple graphs is NOT
better-quasi-ordered under the minor relation.
-/

theorem challenge_6_disprove : ¬ IsBQO FiniteGraph.MinorLE := sorry
