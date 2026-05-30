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

variable {V : Type} [Fintype V] [DecidableEq V]

/-- A partition (A, B) of a Finset V. -/
structure Partition where
  A : Finset V
  B : Finset V
  partition_property : A ∪ B = Finset.univ ∧ A ∩ B = ∅

/-- A partition is unfriendly if every vertex has at least as many neighbours
    in the opposite part as in its own part. -/
def IsUnfriendly (G : SimpleGraph V) (P : Partition) : Prop :=
  ∀ v : V,
    (Finset.filter (G.Adj v) (if v ∈ P.A then P.B else P.A)).card ≥
    (Finset.filter (G.Adj v) (if v ∈ P.A then P.A else P.B)).card

/-- The unfriendly partition conjecture: every graph has an unfriendly partition.
    This universal version asks you to prove or disprove it for ALL graphs
    (no parameter needed — it's a universal binary question). -/
theorem unfriendly_partition_conjecture :
    ∀ (G : SimpleGraph V), ∃ P : Partition, IsUnfriendly G P := by
  sorry

end Challenge10
