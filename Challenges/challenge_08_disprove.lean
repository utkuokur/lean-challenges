import Challenges.challenge_08_univ

/-!
# Ryser's Hypergraph Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r ≥ 4` and an `r`-partite `r`-uniform
hypergraph with vertex-cover number `τ` and matching number `ν`
violating `τ ≤ (r-1)·ν`.  (The cases `r = 2, 3` are theorems, so any
counterexample must have `r ≥ 4`.)
-/

universe u

theorem challenge_8_disprove : ¬ RyserHypergraphConjecture.{u} := sorry
