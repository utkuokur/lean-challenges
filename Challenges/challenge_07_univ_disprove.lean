import Challenges.challenge_07_univ

/-!
# Sphere Packing (Universal) — Disprove direction

To win this slot, exhibit a dimension `d` in which no lattice packing attains the
sphere-packing constant — i.e. some packing of `ℝ^d` is strictly denser than
every lattice packing. This is widely believed to happen in high dimensions but
is unknown for any specific `d`.
-/

open MeasureTheory Metric Filter
open scoped ENNReal

namespace Disprove

theorem challenge_7 :
    ¬ ∀ (d : ℕ), spherePackingConstant d = latticePackingConstant d := sorry

end Disprove
