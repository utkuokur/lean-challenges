import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Order.WellFoundedSet
import Defs_and_Lems.Minor

/-!
# Better-Quasi-Ordering of Finite Graphs under Minor Relation

The graph minor theorem of Robertson and Seymour shows that finite graphs
are well-quasi-ordered under the minor relation. The stronger conjecture
asks whether they form a *better*-quasi-order (BQO).

BQO is a strengthening of WQO defined via barrier sequences on the
infinite-block forest. **Maintainer: the full BQO definition is
nontrivial; the placeholder below uses the standard WQO formulation as
a stand-in. Please replace `IsBQO` with the proper BQO definition.**
-/

open SimpleGraph

variable {V : Type*}

/-- A sequence `f : ℕ → α` is bad in a quasi-order `≤` if no later element
dominates an earlier one. -/
def IsBadSequence {α : Type*} (le : α → α → Prop) (f : ℕ → α) : Prop :=
  ∀ i j, i < j → ¬ le (f i) (f j)

/-- A quasi-order is well-quasi-ordered (WQO) if it has no bad sequence.

This is a placeholder. The full **BQO** definition is stronger and
involves barrier sequences indexed by infinite-block forests.
-/
def IsBQO {α : Type*} (le : α → α → Prop) : Prop :=
  -- TODO(maintainer): replace with the proper barrier-based BQO definition.
  ∀ f : ℕ → α, ¬ IsBadSequence le f

/-- `H` is a minor of `G`: there exists a branch-set model (the shared `Minor`
structure from `Defs_and_Lems/Minor.lean`, also used by challenge_01). -/
def IsMinor {n m : ℕ} (H : SimpleGraph (Fin n)) (G : SimpleGraph (Fin m)) : Prop :=
  Nonempty (Minor H G)

/-- The challenge parameter (intended use: vertex-count bound). -/
def r : ℕ := sorry

/-- BQO of finite graphs of vertex count up to `r` under the minor relation. -/
theorem challenge_6 :
    IsBQO (fun (G H : SimpleGraph (Fin r)) => IsMinor H G) := sorry
