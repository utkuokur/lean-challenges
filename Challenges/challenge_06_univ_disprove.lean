import Challenges.challenge_06_univ

/-!
# BQO of Finite Graphs (Universal) — Disprove direction

To win this slot, exhibit an `r` for which the class of simple graphs
on `Fin r` vertices is NOT BQO under the minor relation.
-/

open SimpleGraph

namespace Disprove

theorem challenge_6 :
    ¬ ∀ r, IsBQO (fun (G H : SimpleGraph (Fin r)) => IsMinor H G) := sorry

end Disprove
