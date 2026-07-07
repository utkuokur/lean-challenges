import Challenges.challenge_08

/-!
# Ryser's Hypergraph Conjecture — Universal Statement
-/

open Hypergraph

theorem challenge_8_univ :
  ∀ {V : Type*} [DecidableEq V]
    (H : Hypergraph V) (r : ℕ),
    2 ≤ r → RyserConjectureFor H r := sorry
