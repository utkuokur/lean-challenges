import Challenges.challenge_08

/-!
# Ryser's Hypergraph Conjecture — Universal Statement

In every `r`-partite `r`-uniform hypergraph, the vertex-cover number `τ` is at
most `(r-1)` times the matching number `ν`.

For `r = 2` this is König's theorem. For `r = 3` it was proved by Aharoni
(2001). The general case (`r ≥ 4`) remains open.

This universal version asks you to prove or disprove the conjecture for ALL
`r ≥ 2` at once — the ∀r form of `challenge_08`, over the same `Hypergraph`
definitions (imported from `Challenges/challenge_08.lean`).
-/

universe u

/-- Ryser's hypergraph conjecture for all `r ≥ 2`.

The bound `τ ≤ (r - 1) · ν` is false for the degenerate small cases: at `r = 1`
it reads `τ ≤ 0`, which fails for a one-vertex one-edge hypergraph
(`τ = ν = 1`). The classical conjecture is therefore stated for `r ≥ 2`
(König at `r = 2`, Aharoni at `r = 3`, open for `r ≥ 4`). -/
def RyserHypergraphConjecture : Prop :=
  ∀ r : ℕ, 2 ≤ r → Hypergraph.RyserConjectureFor.{u} r

/-- The universal challenge: prove or disprove Ryser's conjecture for all
`r ≥ 2`. -/
theorem challenge_8_univ : RyserHypergraphConjecture.{u} := sorry
