import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Tactic

open Filter

/- --------------------------------------------------------------- -/
/- # Diagonal Ramsey numbers and exponential bounds
 The diagonal Ramsey number `R(t)`: the smallest `n` such that every simple graph
on `n` vertices contains either a `t`-clique or a `t`-independent set.
An independent set in `G` is represented as a clique in `Gᶜ`. -/
/- --------------------------------------------------------------- -/

noncomputable def ramseyNumber (t : ℕ) : ℕ :=
  sInf {n : ℕ | ∀ (G : SimpleGraph (Fin n)),
    (∃ s : Finset (Fin n), G.IsNClique t s) ∨
    (∃ s : Finset (Fin n), (Gᶜ).IsNClique t s)}

/-- Exponential two-sided bound on the diagonal Ramsey numbers, with the gap
between the bases decaying like `(0.98)^r` in the parameter `r`. The single named
statement shared by the canonical theorem and the submission signature-shim. -/
def statement_03 (r : ℕ) : Prop :=
  ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.98 : ℝ)^r ∧
    ∀ᶠ t in atTop, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t

def r : ℕ := sorry

theorem challenge_3 : statement_03 r := sorry
