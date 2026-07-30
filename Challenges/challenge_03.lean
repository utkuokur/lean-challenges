import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Tactic

open Filter

noncomputable def ramseyNumber (t : ℕ) : ℕ :=
  sInf {n : ℕ | ∀ (G : SimpleGraph (Fin n)),
    (∃ s : Finset (Fin n), G.IsNClique t s) ∨
    (∃ s : Finset (Fin n), (Gᶜ).IsNClique t s)}

def statement_03 (r : ℕ) : Prop :=
  ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.96 : ℝ)^r ∧
    ∃ T, ∀ t ≥ T, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t

def r : ℕ := sorry

theorem challenge_3 : statement_03 r := sorry
