import Challenges.challenge_10

/-!
# The Unfriendly Partition Conjecture — Universal Statement

Does every countable graph admit a partition of its vertex set into two parts
such that every vertex has at least as many neighbours in the other part as
in its own?

This is known to hold for locally finite graphs and certain other classes,
but the general countable case remains open.  There are uncountable
counterexamples (hence the countability restriction).

This universal slot is the conjecture itself, formalized as
`UnfriendlyPartition.UnfriendlyPartitionConjecture` in
`Challenges/challenge_10.lean` (partial partitions as `V → Option Bool`,
neighbourhood cardinalities compared by injections, so vertices of infinite
degree are handled correctly).  The parametrized `challenge_10` is the
ordinal-clock game ladder derived from it.
-/

universe u

/-- The Unfriendly Partition Conjecture (Cowan and Emerson): every countable
graph has an unfriendly partition. -/
theorem challenge_10_univ :
    UnfriendlyPartition.UnfriendlyPartitionConjecture.{u} := sorry
