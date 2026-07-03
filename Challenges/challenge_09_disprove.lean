import Challenges.challenge_09_univ

/-!
# Union-Closed Sets Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r` and a nondegenerate finite union-closed
family `F` of subsets of some ground type, with no element of density
`≥ 1/2 − 1/(r + 2)` — i.e. disprove the union-closed sets conjecture.
-/

universe u

theorem challenge_9_disprove :
    ¬ ∀ r : ℕ, ∀ {U : Type u} [DecidableEq U] {F : Finset (Finset U)},
      IsUnionClosed F → Nondegenerate F →
        ∃ x, InGround F x ∧
          density F x ≥ (1 / 2 : Rat) - 1 / ((r : Rat) + 2) := sorry
