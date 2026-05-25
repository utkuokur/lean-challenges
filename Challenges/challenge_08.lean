import Mathlib.Data.Finset.Card

universe u

structure Hypergraph (V : Type u) [DecidableEq V] where
  vertices : Finset V
  edges : Set (Finset V)
  edge_subset_vertices : ∀ ⦃e : Finset V⦄, e ∈ edges → e ⊆ vertices

namespace Hypergraph

variable {V : Type u} [DecidableEq V]

/- An r-uniform hypergraph has every edge of cardinality r. -/
def IsUniform (H : Hypergraph V) (r : ℕ) : Prop :=
  ∀ ⦃e : Finset V⦄, e ∈ H.edges → e.card = r

/- An r-partite hypergraph has its vertices partitioned into r parts,
with every edge meeting every part in exactly one vertex. -/
def IsPartite (H : Hypergraph V) (r : ℕ) : Prop :=
  ∃ parts : Fin r → Finset V,
    (∀ v : V, v ∈ H.vertices ↔ ∃ i : Fin r, v ∈ parts i) ∧
      (∀ i j : Fin r, i ≠ j → Disjoint (parts i) (parts j)) ∧
        (∀ ⦃e : Finset V⦄, e ∈ H.edges →
          ∀ i : Fin r, ((parts i) ∩ e).card = 1)

/-- A vertex cover is a set of vertices meeting every edge. -/
def IsVertexCover (H : Hypergraph V) (C : Finset V) : Prop :=
  C ⊆ H.vertices ∧
    ∀ ⦃e : Finset V⦄, e ∈ H.edges → ∃ v : V, v ∈ C ∧ v ∈ e

/-- A matching is a finite set of pairwise disjoint edges. -/
def IsMatching (H : Hypergraph V) (M : Finset (Finset V)) : Prop :=
  (∀ ⦃e : Finset V⦄, e ∈ M → e ∈ H.edges) ∧
    ∀ ⦃e₁ : Finset V⦄, e₁ ∈ M →
      ∀ ⦃e₂ : Finset V⦄, e₂ ∈ M → e₁ ≠ e₂ → Disjoint e₁ e₂

/-- tau is the cover number of H, stated relationally. -/
def IsCoverNumber (H : Hypergraph V) (tau : ℕ) : Prop :=
  (∃ C : Finset V, H.IsVertexCover C ∧ C.card = tau) ∧
    ∀ C : Finset V, H.IsVertexCover C → tau ≤ C.card

/-- nu is the matching number of H, stated relationally. -/
def IsMatchingNumber (H : Hypergraph V) (nu : ℕ) : Prop :=
  (∃ M : Finset (Finset V), H.IsMatching M ∧ M.card = nu) ∧
    ∀ M : Finset (Finset V), H.IsMatching M → M.card ≤ nu

/-- Ryser's hypergraph conjecture for a fixed value of r, without choosing τ or ν. -/
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

/-- The r = 2 case, classically König's theorem. -/
def KonigCase : Prop :=
  RyserConjectureFor.{u} (r := 2)

/-- The r = 3 case, proved by Aharoni. -/
def AharoniCase : Prop :=
  RyserConjectureFor.{u} (r := 3)

/-!
## Theorem sandwich
-/

/-- Any concrete vertex cover bounds a relational cover number from above. -/
theorem isCoverNumber_le_card_of_isVertexCover
    (H : Hypergraph V) {tau : ℕ} (htau : H.IsCoverNumber tau)
    {C : Finset V} (hC : H.IsVertexCover C) :
    tau ≤ C.card :=
  htau.2 C hC

/--
First layer of key lemmata for Ryser: every admissible hypergraph with relational
matching number nu has a vertex cover of size at most (r - 1) * nu.
-/
def RyserKeyLemmataFor (r : ℕ) : Prop :=
  ∀ (V : Type u) [DecidableEq V], ∀ H : Hypergraph V,
    H.IsUniform r →
      H.IsPartite r →
        ∀ nu : ℕ,
          H.IsMatchingNumber nu →
            ∃ C : Finset V,
              H.IsVertexCover C ∧ C.card ≤ (r - 1) * nu

/-- The key lemmata imply Ryser's conjectural inequality for fixed r. -/
theorem RyserConjectureFor_of_keyLemmata {r : ℕ}
    (hkey : RyserKeyLemmataFor.{u} r) :
    RyserConjectureFor.{u} r := by
  intro V _ H hUniform hPartite tau nu htau hnu
  rcases hkey V H hUniform hPartite nu hnu with ⟨C, hCover, hCard⟩
  exact (H.isCoverNumber_le_card_of_isVertexCover htau hCover).trans hCard

/-- If the key lemmata hold for every r, then the full Ryser conjecture follows. -/
theorem RyserHypergraphConjecture_of_keyLemmata
    (hkey : ∀ r : ℕ, RyserKeyLemmataFor.{u} r) :
    RyserHypergraphConjecture.{u} := by
  intro r
  exact RyserConjectureFor_of_keyLemmata (hkey r)

/-- A direct corollary: the full conjecture implies the König case. -/
theorem KonigCase_of_RyserHypergraphConjecture
    (hRyser : RyserHypergraphConjecture.{u}) :
    KonigCase.{u} :=
  hRyser 2

/-- A direct corollary: the full conjecture implies the Aharoni case. -/
theorem AharoniCase_of_RyserHypergraphConjecture
    (hRyser : RyserHypergraphConjecture.{u}) :
    AharoniCase.{u} :=
  hRyser 3

/-- The full conjecture specializes to any fixed value of r. -/
theorem RyserConjectureFor_of_RyserHypergraphConjecture
    (hRyser : RyserHypergraphConjecture.{u}) (r : ℕ) :
    RyserConjectureFor.{u} r :=
  hRyser r

end Hypergraph
