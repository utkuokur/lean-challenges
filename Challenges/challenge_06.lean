import Mathlib.Combinatorics.SimpleGraph.Basic
import Defs_and_Lems.Minor
import Defs_and_Lems.BQO

/-!
# Better-Quasi-Ordering of Finite Graphs under Minor Relation

The graph minor theorem of Robertson and Seymour shows that finite graphs
are well-quasi-ordered under the minor relation. The stronger conjecture
asks whether they form a *better*-quasi-order (BQO).

`IsBQO` is the Nash–Williams barrier-based definition from
`Defs_and_Lems/BQO.lean`: every array from a barrier into the quasi-order is
good (no bad array along the shift relation). This is strictly stronger than
the WQO formulation it replaces.
-/

open SimpleGraph

variable {V : Type*}

/-- `H` is a minor of `G`: there exists a branch-set model (the shared `Minor`
structure from `Defs_and_Lems/Minor.lean`, also used by challenge_01). -/
def IsMinor {n m : ℕ} (H : SimpleGraph (Fin n)) (G : SimpleGraph (Fin m)) : Prop :=
  Nonempty (Minor H G)

/-- The challenge parameter (intended use: vertex-count bound). -/
def r : ℕ := sorry

/-- BQO of finite graphs of vertex count up to `r` under the minor relation. -/
theorem challenge_6 :
    IsBQO (fun (G H : SimpleGraph (Fin r)) => IsMinor H G) := sorry
