import Mathlib

/-!
# Ryser's Hypergraph Conjecture — Universal Statement

In every r-partite r-uniform hypergraph, the vertex cover number τ is at most
(r-1) times the matching number ν.

For r=2 this is König's theorem. For r=3 it was proved by Aharoni (2001).
The general case remains open.

This universal version asks you to prove or disprove the conjecture for ALL r.
-/

universe u

variable {V : Type u}

namespace Challenge08

open Finset

/-- An r-uniform hypergraph: every edge has cardinality r. -/
structure Hypergraph (V : Type u) where
  vertices : Finset V
  edges : Finset (Finset V)
  edge_subset_vertices : ∀ ⦃e : Finset V⦄, e ∈ edges → e ⊆ vertices

variable (H : Hypergraph V)

/-- H is r-uniform if every edge has cardinality r. -/
def Hypergraph.IsUniform (r : ℕ) : Prop :=
  ∀ ⦃e : Finset V⦄, e ∈ H.edges → e.card = r

/-- H is r-partite if vertices can be partitioned into r parts,
    each edge containing exactly one vertex from each part. -/
def Hypergraph.IsPartite (r : ℕ) : Prop :=
  ∃ parts : Fin r → Finset V,
    (∀ v : V, v ∈ H.vertices ↔ ∃ i : Fin r, v ∈ parts i) ∧
      (∀ i j : Fin r, i ≠ j → Disjoint (parts i) (parts j)) ∧
        (∀ ⦃e : Finset V⦄, e ∈ H.edges →
          ∀ i : Fin r, ((parts i) ∩ e).card = 1)

/-- C is a vertex cover if every edge contains a vertex in C. -/
def Hypergraph.IsVertexCover (C : Finset V) : Prop :=
  C ⊆ H.vertices ∧
    ∀ ⦃e : Finset V⦄, e ∈ H.edges → ∃ v : V, v ∈ C ∧ v ∈ e

/-- M is a matching if its edges are pairwise disjoint. -/
def Hypergraph.IsMatching (M : Finset (Finset V)) : Prop :=
  (∀ ⦃e : Finset V⦄, e ∈ M → e ∈ H.edges) ∧
    ∀ ⦃e₁ : Finset V⦄, e₁ ∈ M →
      ∀ ⦃e₂ : Finset V⦄, e₂ ∈ M → e₁ ≠ e₂ → Disjoint e₁ e₂

/-- τ is the cover number: the minimum cardinality of a vertex cover. -/
def Hypergraph.IsCoverNumber (tau : ℕ) : Prop :=
  (∃ C : Finset V, H.IsVertexCover C ∧ C.card = tau) ∧
    ∀ C : Finset V, H.IsVertexCover C → tau ≤ C.card

/-- ν is the matching number: the maximum cardinality of a matching. -/
def Hypergraph.IsMatchingNumber (nu : ℕ) : Prop :=
  (∃ M : Finset (Finset V), H.IsMatching M ∧ M.card = nu) ∧
    ∀ M : Finset (Finset V), H.IsMatching M → M.card ≤ nu

/-- Ryser's conjecture for a fixed r. -/
def RyserConjectureFor (r : ℕ) : Prop :=
  ∀ (V : Type u) [DecidableEq V], ∀ H : Hypergraph V,
    H.IsUniform r →
      H.IsPartite r →
        ∀ tau nu : ℕ,
          H.IsCoverNumber tau →
            H.IsMatchingNumber nu →
              tau ≤ (r - 1) * nu

/-- Ryser's hypergraph conjecture for all natural numbers r. -/
def RyserHypergraphConjecture : Prop :=
  ∀ r : ℕ, RyserConjectureFor.{u} (r := r)

/-- The universal challenge: prove or disprove Ryser's conjecture for ALL r. -/
theorem challenge_8 : RyserHypergraphConjecture.{u} := by
  sorry

end Challenge08
