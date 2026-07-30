import Defs_and_Lems.Sidorenko

/-!
# Sidorenko's Conjecture for Bipartite Graphs with Bounded Sides
-/

open SimpleGraph

variable {W V : Type} [Fintype W] [Fintype V] [Nonempty V]

/-- Bounded-side Sidorenko conjecture for parameter `r`: on every bipartite `H`
whose two sides are bounded by `r`, the Sidorenko density inequality holds against
every host `G`. The single named statement shared by the canonical theorem and the
submission signature-shim. -/
def statement_04 (r : ℕ) : Prop :=
  ∀ {W V : Type} [Fintype W] [Fintype V] [Nonempty V]
    (H : SimpleGraph W) (G : SimpleGraph V),
    BipartiteBoundedBy H r → SidorenkoFor H G

/- The challenge parameter -/
def r : ℕ := sorry

theorem challenge_4 : statement_04 r := sorry
