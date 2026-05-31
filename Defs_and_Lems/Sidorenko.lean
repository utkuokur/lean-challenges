import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Maps
import Mathlib.Data.Real.Basic
import Mathlib.SetTheory.Cardinal.Finite

/-!
# Shared definitions for Sidorenko's conjecture (half-graphs)

Used by both `challenge_04` (specific `r`) and `challenge_04_univ` (∀r), so
the half-graph, homomorphism density, and the Sidorenko inequality live here.
-/

open SimpleGraph

/-- The half-graph `H_r` on `Fin r ⊕ Fin r`: `Sum.inl i` and `Sum.inr j` are
adjacent iff `i ≤ j`, with no other edges. Built with `fromRel`, which
symmetrizes the relation and removes self-loops. -/
noncomputable def halfGraph (r : ℕ) : SimpleGraph (Sum (Fin r) (Fin r)) :=
  SimpleGraph.fromRel fun a b =>
    ∃ i j : Fin r, a = Sum.inl i ∧ b = Sum.inr j ∧ i ≤ j

/-- The homomorphism density `t(H, G)`: the number of graph homomorphisms
`H → G` (adjacency-preserving maps), divided by `|V(G)| ^ |V(H)|`. -/
noncomputable def homDensity {W V : Type*} [Fintype W] [Fintype V]
    (H : SimpleGraph W) (G : SimpleGraph V) : ℝ :=
  (Nat.card {f : W → V // ∀ ⦃a b : W⦄, H.Adj a b → G.Adj (f a) (f b)} : ℝ) /
    (Fintype.card V : ℝ) ^ Fintype.card W

/-- Sidorenko's inequality for a (bipartite) graph `H` over `G`, in normalized
homomorphism-density form: `t(H, G) ≥ t(K₂, G) ^ e(H)`, where `t(K₂, G)` is the
edge density (the homomorphism density of the single edge `K₂`) and `e(H)` is
the number of edges of `H`. -/
def SidorenkoFor {W V : Type*} [Fintype W] [Fintype V]
    (H : SimpleGraph W) (G : SimpleGraph V) : Prop :=
  homDensity H G ≥ homDensity (completeGraph (Fin 2)) G ^ Nat.card H.edgeSet
