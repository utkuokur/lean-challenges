import Challenges.challenge_10_univ

/-!
# The Unfriendly Partition Conjecture (Universal) — Disprove direction

To win this slot, exhibit a countable simple graph admitting no unfriendly
partition into two parts (with neighbourhood cardinalities compared by
injections, as in `challenge_10_univ`).  Known counterexamples are
uncountable, so this genuinely requires new mathematics.
-/

universe u

theorem challenge_10_disprove :
    ¬ ∀ {V : Type u}, Countable V → ∀ G : SimpleGraph V,
      ∃ f : V -> Bool, IsUnfriendlyPartition G f := sorry
