import Challenges.challenge_10

/-!
# The Unfriendly Partition Conjecture — Universal Statement

Does every countable graph admit a partition of its vertex set into two parts
such that every vertex has at least as many neighbours in the other part as in
its own? This is known for locally finite graphs and other classes, but the
general countable case is open. There are uncountable counterexamples
(Shelah–Milner 1990), hence the countability restriction.

This is the ∀r form of `challenge_10`, over the same `r`-partitioning game
(imported from `Challenges/challenge_10.lean`): for EVERY ordinal `r`, on every
countable graph Partitioner has a winning strategy in the `r`-partitioning
game.
-/

universe u v

/-- Unfriendly Partition Conjecture, universal in the ordinal parameter: for
EVERY ordinal `r`, on every countable graph Partitioner has a winning strategy
in the `r`-partitioning game. The single named statement shared by the
canonical theorem, the disprove slot, and the submission signature-shims. -/
def UnfriendlyPartitionConjecture : Prop :=
  ∀ r : Ordinal.{v}, ∀ {V : Type u}, Countable V → ∀ G : SimpleGraph V,
    PartitionerWins G (emptyPartialPartition V) r

theorem challenge_10_univ : UnfriendlyPartitionConjecture.{u, v} := sorry
