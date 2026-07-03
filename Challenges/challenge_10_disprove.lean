import Challenges.challenge_10_univ

/-!
# The Unfriendly Partition Conjecture (Universal) — Disprove direction

To win this slot, exhibit a countable simple graph admitting no unfriendly
partition into two parts (with neighbourhood cardinalities compared by
injections, as in `UnfriendlyPartition.UnfriendlyPartitionConjecture`).
Known counterexamples are uncountable, so this genuinely requires new
mathematics.
-/

universe u

theorem challenge_10_disprove :
    ¬ UnfriendlyPartition.UnfriendlyPartitionConjecture.{u} := sorry
