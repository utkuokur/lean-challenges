import Challenges.challenge_06

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement
-/
/-- α-WQO minor ladder, universal in the ordinal parameter `r`. The single named
statement shared by the canonical theorem, the disprove slot, and the shims. -/
def AlphaWQOMinorLadderUniv : Prop :=
  ∀ r : Ordinal.{1}, AlphaWQOMinorLadderFor r

theorem challenge_6_univ : AlphaWQOMinorLadderUniv := sorry
