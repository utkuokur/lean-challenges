import Challenges.challenge_08

/-!
# Ryser's Hypergraph Conjecture
# Disprove option
-/

open Hypergraph

theorem challenge_8_disprove :
  ¬ ∀ {V : Type*} [DecidableEq V]
  (H : Hypergraph V) (r : ℕ),
    2 ≤ r → RyserConjectureFor H r := sorry
