import Challenges.challenge_09_univ

/-!
# Union-Closed Sets Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r > 2` and a nondegenerate finite
union-closed family `F` of subsets of some ground type, with no
element of density ≥ 1/2 − 1/r.
-/

namespace Disprove

theorem challenge_9 :
    ¬ ∀ {U : Type} [Fintype U] [DecidableEq U]
      (r : Nat) (_ : 2 < r) {F : Finset (Finset U)}
      (_ : Challenge09.IsUnionClosed F) (_ : Challenge09.Nondegenerate F),
      ∃ x, Challenge09.InGround F x ∧
        Challenge09.density F x ≥ (1 / 2 : Rat) - 1 / (r : Rat) := sorry

end Disprove
