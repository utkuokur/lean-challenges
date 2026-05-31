import Challenges.challenge_01_univ

/-!
# The Hadwiger Conjecture (Universal) — Disprove direction

To win this slot, exhibit a graph `G` and a witness `r` such that
`G` has Hadwiger number ≤ r but is not (r+1)-colorable.

The canonical here is `Disprove.challenge_1`; it sits in its own
namespace so root-level `challenge_1` (the prove direction) is not
shadowed.
-/

open SimpleGraph

namespace Disprove

theorem challenge_1 :
    ¬ ∀ {V : Type*} [Fintype V] (G : SimpleGraph V),
      ∀ r, hadwigerNumber G ≤ r → G.Colorable (r + 1) := sorry

end Disprove
