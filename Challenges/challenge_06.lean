import Defs_and_Lems.AlphaWQO

/-!
# Better-Quasi-Ordering of Finite Graphs under Minor Relation
-/

/-- `α`-well-quasi-ordering of finite (planar) graphs under minors, for the
chosen ordinal `r`: writing `r = 2 * α` (even) or `r = 2 * α + 1` (odd) with
`α = r / 2`, planar graphs are `α`-wqo when `r` is even, all finite graphs
are `α`-wqo when `r` is odd. The single named statement shared by the canonical
theorem and the submission signature-shim. -/
def statement_06 (r : Ordinal.{1}) : Prop :=
  if r % 2 = 0
  then IsAlphaWQO PlanarGraph.MinorLE (r / 2)
  else IsAlphaWQO FiniteGraph.MinorLE (r / 2)

def r : Ordinal.{1} := sorry

theorem challenge_6 : statement_06 r := sorry
