import Challenges.challenge_08_univ

/-!
# Ryser's Hypergraph Conjecture (Universal) — Disprove direction

To win this slot, exhibit an `r ≥ 4` and an `r`-partite `r`-uniform
hypergraph with vertex-cover number `τ` and matching number `ν`
violating `τ ≤ (r-1)·ν`.
-/

namespace Disprove

theorem challenge_8 : ¬ Challenge08.RyserHypergraphConjecture.{u} := sorry

end Disprove
