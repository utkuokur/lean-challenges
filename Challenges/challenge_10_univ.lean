import Mathlib

/-!
# The Unfriendly Partition Conjecture — Universal Statement

Does every countable graph admit a partition of its vertex set into two parts
such that every vertex has at least as many neighbours in the other part as
in its own?

This is known to hold for locally finite graphs and certain other classes,
but the general countable case remains open. The uncountable case is
independent of ZFC.

This universal version asks you to prove or disprove the conjecture for
all graphs — no parameter needed, because the conjecture is a yes/no
question about ALL countable graphs.
-/

namespace Challenge10

open Finset

/-- A partition (A, B) of `Finset.univ : Finset V`. -/
structure Partition (V : Type) [Fintype V] [DecidableEq V] where
  A : Finset V
  B : Finset V
  partition_property : A ∪ B = Finset.univ ∧ A ∩ B = ∅

/-- A partition is unfriendly if every vertex has at least as many neighbours
    in the opposite part as in its own part. -/
noncomputable def IsUnfriendly {V : Type} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) (P : Partition V) : Prop :=
  letI := Classical.decRel G.Adj
  ∀ v : V,
    (Finset.filter (G.Adj v) (if v ∈ P.A then P.B else P.A)).card ≥
    (Finset.filter (G.Adj v) (if v ∈ P.A then P.A else P.B)).card

/-- The unfriendly partition conjecture: every graph has an unfriendly partition.
    This universal version asks you to prove or disprove it for ALL graphs
    (no parameter needed — it's a universal binary question). -/
theorem challenge_10 :
    ∀ {V : Type} [Fintype V] [DecidableEq V] (G : SimpleGraph V),
      ∃ P : Partition V, IsUnfriendly G P := by
  sorry

end Challenge10
