import Challenges.challenge_10_univ

/-!
# The Unfriendly Partition Conjecture (Universal) — Disprove direction

To win this slot, exhibit a finite simple graph `G` admitting no
unfriendly partition into two parts.
-/

namespace Disprove

theorem challenge_10 :
    ¬ ∀ {V : Type} [Fintype V] [DecidableEq V] (G : SimpleGraph V),
      ∃ P : Challenge10.Partition V, Challenge10.IsUnfriendly G P := sorry

end Disprove
