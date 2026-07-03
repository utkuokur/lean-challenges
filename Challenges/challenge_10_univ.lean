import Defs_and_Lems.UnfriendlyPartition

/-!
# The Unfriendly Partition Conjecture — Universal Statement

Does every countable graph admit a partition of its vertex set into two parts
such that every vertex has at least as many neighbours in the other part as
in its own?

This is known to hold for locally finite graphs and certain other classes,
but the general countable case remains open. There are uncountable
counterexamples (Shelah–Milner 1990), hence the countability restriction.

The vocabulary (`V → Bool` partitions, injection-compared neighbourhoods, and
`UnfriendlyPartitionConjecture` itself) lives in
`Defs_and_Lems/UnfriendlyPartition.lean`, shared with `challenge_10_disprove`
and — for the cardinality comparison — the parametrized game in
`Challenges/challenge_10.lean`.
-/

universe u

theorem challenge_10_univ : UnfriendlyPartitionConjecture.{u} := sorry
