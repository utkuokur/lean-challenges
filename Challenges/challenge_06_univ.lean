import Mathlib.Combinatorics.SimpleGraph.Basic
import Defs_and_Lems.Minor
import Defs_and_Lems.BQO

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement

The graph minor theorem (Robertson–Seymour) shows that finite graphs are
well-quasi-ordered under the minor relation. The stronger conjecture is
whether they form a *better*-quasi-order (BQO).

This universal version asks for a proof or disproof for the class of ALL
finite simple graphs.

`IsBQO` is the Nash–Williams barrier-based definition from
`Defs_and_Lems/BQO.lean`.
-/

open SimpleGraph

/-- `H` is a minor of `G`: there exists a branch-set model (the shared `Minor`
structure from `Defs_and_Lems/Minor.lean`, also used by challenge_01). -/
def IsMinor {n m : ℕ} (H : SimpleGraph (Fin n)) (G : SimpleGraph (Fin m)) : Prop :=
  Nonempty (Minor H G)

/-- BQO of finite graphs of all sizes under the minor relation. -/
theorem challenge_6 :
    ∀ r, IsBQO (fun (G H : SimpleGraph (Fin r)) => IsMinor H G) := sorry
