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

def r : ℕ := sorry  -- The challenge parameter

theorem challenge_3 : ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.9 : ℝ)^r ∧
 ∀ᶠ t in atTop, d₁ ^ t ≤ ramseyNumber t ∧ ramseyNumber t ≤ d₂ ^ t := sorry


/-
theorem ramsey_bounds : ∃ d₁ d₂ : ℝ, |d₁ - d₂| ≤ (4 - √2) * (0.9)^r ∧
 ∃ t : ℕ, ∀ t' ≥ t, (d₁^(t') ≤ ramseyNumber t ) ∧ (ramseyNumber t ≤ d₂^(t')) := sorry
-/


--------------unusued

-- /- A set is an independent set in `G` iff it is a clique in the complement graph. -/
-- lemma independent_set_iff_complement_clique {V : Type*}
--     (G : SimpleGraph V) (t : ℕ) (s : Finset V) :
--     (Gᶜ).IsNClique t s ↔
--       (∀ a ∈ s, ∀ b ∈ s, a ≠ b → ¬ G.Adj a b) ∧ s.card = t := by
--   constructor
--   · intro h
--     refine ⟨?_, h.card_eq⟩
--     intro a ha b hb hne
--     exact (SimpleGraph.compl_adj G a b).mp (h.isClique ha hb hne) |>.2
--   · intro h
--     refine ⟨?_, h.2⟩
--     intro a ha b hb hne
--     exact (SimpleGraph.compl_adj G a b).mpr ⟨hne, h.1 a ha b hb hne⟩


/- Ramsey's theorem with the classical exponential upper bound. -/
-- theorem ramsey_finite (t : ℕ) (ht : 0 < t) :
--   ramseyNumber t ≤ 4 ^ t := sorry
