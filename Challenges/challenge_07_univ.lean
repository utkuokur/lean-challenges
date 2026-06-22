import Mathlib.MeasureTheory.Measure.Lebesgue.VolumeOfBalls
import Mathlib.Order.LiminfLimsup
import Mathlib.Order.Filter.AtTopBot.Basic

/-!
# Sphere Packing — Universal Statement

A *unit packing* of `ℝ^d` is a set of centres whose unit balls have pairwise
disjoint interiors (distinct centres are at distance `≥ 2`). The sphere-packing
problem asks for the largest possible (upper) density of such a packing — the
**sphere-packing constant** `Δ_d`.

`Δ_d` is known only for `d ∈ {1, 2, 3, 8, 24}` (the case `d = 3` is the Kepler
conjecture; `d = 8` and `d = 24` are Viazovska and Cohn–Kumar–Miller–Radchenko–
Viazovska); the largest solved case is `d = 24`. In every solved case the optimum
is attained by a lattice (e.g. `E₈`, the Leech lattice).

This universal version asks, for **all** `d`, whether the sphere-packing constant
is always attained by a lattice packing. It is open in general (and believed to
fail in high dimensions), so this slot is genuinely a prove-or-disprove problem.
-/

open MeasureTheory Metric Filter
open scoped ENNReal

variable {d : ℕ}

/-- A set of centres `C ⊆ ℝ^d` is a *unit packing* if distinct centres are at
distance at least `2` (the open unit balls around the centres are disjoint). -/
def IsUnitPacking (C : Set (EuclideanSpace ℝ (Fin d))) : Prop :=
  ∀ ⦃x⦄, x ∈ C → ∀ ⦃y⦄, y ∈ C → x ≠ y → 2 ≤ dist x y

/-- The (upper) density of a packing `C`: the `limsup` as `R → ∞` of the fraction
of the ball `B(0, R)` filled by the unit balls centred at the points of `C`. -/
noncomputable def upperDensity (C : Set (EuclideanSpace ℝ (Fin d))) : ℝ≥0∞ :=
  limsup (fun R : ℝ =>
    volume ((⋃ x ∈ C, ball x 1) ∩ ball 0 R)
      / volume (ball (0 : EuclideanSpace ℝ (Fin d)) R)) atTop

/-- The **sphere-packing constant** `Δ_d`: the supremum of densities over all unit
packings of `ℝ^d`. -/
noncomputable def spherePackingConstant (d : ℕ) : ℝ≥0∞ :=
  ⨆ (C : Set (EuclideanSpace ℝ (Fin d))) (_ : IsUnitPacking C), upperDensity C

/-- A *lattice packing*: a unit packing whose centre set is an additive subgroup
of `ℝ^d` (a lattice). -/
def IsLatticePacking (C : Set (EuclideanSpace ℝ (Fin d))) : Prop :=
  IsUnitPacking C ∧
    ∃ L : AddSubgroup (EuclideanSpace ℝ (Fin d)), C = (L : Set (EuclideanSpace ℝ (Fin d)))

/-- The **lattice** sphere-packing constant: the supremum of densities over unit
packings that are lattices. -/
noncomputable def latticePackingConstant (d : ℕ) : ℝ≥0∞ :=
  ⨆ (C : Set (EuclideanSpace ℝ (Fin d))) (_ : IsLatticePacking C), upperDensity C

/-- **Sphere packing (universal, lattice optimality).** In every dimension the
sphere-packing constant is achieved by a lattice packing. Open in general; known
in `d ∈ {1, 2, 3, 8, 24}`. -/
theorem challenge_7 : ∀ (d : ℕ), spherePackingConstant d = latticePackingConstant d := sorry
