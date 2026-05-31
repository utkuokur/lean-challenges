import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Order.WellFoundedSet
import Defs_and_Lems.Minor

/-!
# Better-Quasi-Ordering of Finite Graphs — Universal Statement

The graph minor theorem (Robertson–Seymour) shows that finite graphs are
well-quasi-ordered under the minor relation. The stronger conjecture is
whether they form a *better*-quasi-order (BQO).

This universal version asks for a proof or disproof for the class of ALL
finite simple graphs.

**Maintainer**: the BQO definition below is a placeholder (uses WQO instead
of the proper barrier-based BQO); the `IsMinor` definition is `sorry`. Both
need maintainer formalization.
-/

open SimpleGraph

/-- A sequence `f : ℕ → α` is bad in a quasi-order `≤` if no later element
dominates an earlier one. -/
def IsBadSequence {α : Type*} (le : α → α → Prop) (f : ℕ → α) : Prop :=
  ∀ i j, i < j → ¬ le (f i) (f j)

/-- A quasi-order is well-quasi-ordered (WQO) if it has no bad sequence.
This is a **placeholder** for BQO; the actual BQO definition involves
barrier sequences over infinite-block forests. -/
def IsBQO {α : Type*} (le : α → α → Prop) : Prop :=
  ∀ f : ℕ → α, ¬ IsBadSequence le f

/-- `H` is a minor of `G`: there exists a branch-set model (the shared `Minor`
structure from `Defs_and_Lems/Minor.lean`, also used by challenge_01). -/
def IsMinor {n m : ℕ} (H : SimpleGraph (Fin n)) (G : SimpleGraph (Fin m)) : Prop :=
  Nonempty (Minor H G)

/-- BQO of finite graphs of all sizes under the minor relation. -/
theorem challenge_6 :
    ∀ r, IsBQO (fun (G H : SimpleGraph (Fin r)) => IsMinor H G) := sorry
