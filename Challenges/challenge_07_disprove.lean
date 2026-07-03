import Challenges.challenge_07_univ

/-!
# Sphere Packing (Universal) — Disprove direction

To win this slot, exhibit a dimension `r` in which no lattice packing attains the
sphere-packing constant — i.e. some packing of `ℝ^r` is strictly denser than
every lattice packing. This is widely believed to happen in high dimensions but
is unknown for any specific `r`.
-/

open MeasureTheory Metric Filter
open scoped ENNReal

theorem challenge_7_disprove :
    ¬ ∀ (r : ℕ), spherePackingConstant r = latticePackingConstant r := sorry
