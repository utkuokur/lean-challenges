import Challenges.challenge_10_univ

/-!
# The Unfriendly Partition Conjecture (Universal) — Disprove direction

To win this slot, exhibit an ordinal `r` and a countable graph on which
Partitioner has no winning strategy in the `r`-partitioning game — i.e.
disprove the scaled unfriendly partition conjecture. Known counterexamples to
the plain conjecture are uncountable, so this genuinely requires new
mathematics.
-/

universe u v

theorem challenge_10_disprove : ¬ UnfriendlyPartitionConjecture.{u, v} := sorry
