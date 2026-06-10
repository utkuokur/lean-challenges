import Challenges.challenge_06_univ

/-!
# BQO of Finite Graphs (Universal) — Disprove direction

To win this slot, show that the class of all finite simple graphs is NOT
better-quasi-ordered under the minor relation.
-/

namespace Disprove

theorem challenge_6 : ¬ IsBQO FiniteGraph.MinorLE := sorry

end Disprove
