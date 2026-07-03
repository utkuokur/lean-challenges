import Challenges.challenge_09

/-!
# Union-Closed Sets Conjecture — Universal Statement

In any finite union-closed family of sets (other than `∅` and `{∅}`), there
exists an element that belongs to at least half of the sets.

This universal version is the ∀r form of `challenge_09`, over the same
definitions (imported from `Challenges/challenge_09.lean`): for EVERY `r`,
every nondegenerate finite union-closed family has an element of density at
least `1/2 - 1/(r + 2)`.  As `r → ∞` the bound tends to `1/2`, so this is
equivalent to the full union-closed sets (Frankl) conjecture.
-/

universe u

/-- The universal scaled union-closed sets conjecture: for every `r`, every
nondegenerate finite union-closed family has an element of density at least
`1/2 - 1/(r + 2)`.  Equivalent to the full union-closed sets conjecture. -/
theorem challenge_9_univ :
    ∀ r : ℕ, ∀ {U : Type u} [DecidableEq U] {F : Finset (Finset U)},
      IsUnionClosed F → Nondegenerate F →
        ∃ x, InGround F x ∧
          density F x ≥ (1 / 2 : Rat) - 1 / ((r : Rat) + 2) := sorry
