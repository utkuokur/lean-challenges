import Mathlib.Data.Finset.Max
import Mathlib.Data.Finset.Powerset

universe u

structure Hypergraph (V : Type u) [DecidableEq V] where
  vertices : Finset V
  edges : Finset (Finset V)
  edge_subset_vertices : ∀ ⦃e : Finset V⦄, e ∈ edges → e ⊆ vertices

namespace Hypergraph

variable {V : Type u} [DecidableEq V]

noncomputable section

/-- An `r`-uniform hypergraph has every edge of cardinality `r`. -/
def IsUniform (H : Hypergraph V) (r : ℕ) : Prop :=
  ∀ ⦃e : Finset V⦄, e ∈ H.edges → e.card = r

/--
An `r`-partite hypergraph has its vertices partitioned into `r` parts,
with every edge meeting every part in exactly one vertex.
-/
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

/-- The finite search space of all vertex covers. -/
def vertexCovers (H : Hypergraph V) : Finset (Finset V) := by
  classical
  exact H.vertices.powerset.filter (fun C => H.IsVertexCover C)

@[simp]
theorem mem_vertexCovers (H : Hypergraph V) {C : Finset V} :
    C ∈ H.vertexCovers ↔ H.IsVertexCover C := by
  classical
  constructor
  · intro hC
    exact (Finset.mem_filter.mp hC).2
  · intro hC
    exact Finset.mem_filter.mpr
      ⟨Finset.mem_powerset.mpr hC.1, hC⟩

/-- The finite search space of all matchings. -/
def matchings (H : Hypergraph V) : Finset (Finset (Finset V)) := by
  classical
  exact H.edges.powerset.filter (fun M => H.IsMatching M)

@[simp]
theorem mem_matchings (H : Hypergraph V) {M : Finset (Finset V)} :
    M ∈ H.matchings ↔ H.IsMatching M := by
  classical
  constructor
  · intro hM
    exact (Finset.mem_filter.mp hM).2
  · intro hM
    refine Finset.mem_filter.mpr ?_
    refine ⟨?_, hM⟩
    refine Finset.mem_powerset.mpr ?_
    intro e heM
    exact hM.1 heM

@[simp]
theorem empty_isMatching (H : Hypergraph V) :
    H.IsMatching (∅ : Finset (Finset V)) := by
  simp [IsMatching]

@[simp]
theorem empty_mem_matchings (H : Hypergraph V) :
    (∅ : Finset (Finset V)) ∈ H.matchings := by
  classical
  exact (H.mem_matchings).2 (H.empty_isMatching)

/-- The finite set of cardinalities of vertex covers. -/
def coverSizes (H : Hypergraph V) : Finset ℕ :=
  H.vertexCovers.image Finset.card

/-- The finite set of cardinalities of matchings. -/
def matchingSizes (H : Hypergraph V) : Finset ℕ :=
  H.matchings.image Finset.card

/--
The vertex-cover number.

Convention: if no vertex cover exists, this returns `0`. For the usual Ryser range
`2 ≤ r`, this convention is harmless, since admissible hypergraphs have nonempty edges.
-/
def coverNumber (H : Hypergraph V) : ℕ :=
  if h : H.coverSizes.Nonempty then H.coverSizes.min' h else 0

theorem matchingSizes_nonempty (H : Hypergraph V) :
    H.matchingSizes.Nonempty := by
  classical
  refine ⟨0, ?_⟩
  exact Finset.mem_image.mpr
    ⟨(∅ : Finset (Finset V)), H.empty_mem_matchings, by simp⟩

/-- The matching number. -/
def matchingNumber (H : Hypergraph V) : ℕ :=
  H.matchingSizes.max' H.matchingSizes_nonempty

theorem coverSizes_nonempty_of_isVertexCover
    (H : Hypergraph V) {C : Finset V} (hC : H.IsVertexCover C) :
    H.coverSizes.Nonempty := by
  classical
  refine ⟨C.card, ?_⟩
  exact Finset.mem_image.mpr ⟨C, (H.mem_vertexCovers).2 hC, rfl⟩

/-- Any concrete vertex cover bounds the cover number from above. -/
theorem coverNumber_le_card_of_isVertexCover
    (H : Hypergraph V) {C : Finset V} (hC : H.IsVertexCover C) :
    H.coverNumber ≤ C.card := by
  classical
  have hne : H.coverSizes.Nonempty :=
    H.coverSizes_nonempty_of_isVertexCover hC
  have hmem : C.card ∈ H.coverSizes := by
    exact Finset.mem_image.mpr ⟨C, (H.mem_vertexCovers).2 hC, rfl⟩
  simpa [coverNumber, hne] using
    (Finset.min'_le H.coverSizes C.card hmem)

/-- Any concrete matching bounds the matching number from below. -/
theorem card_le_matchingNumber_of_isMatching
    (H : Hypergraph V) {M : Finset (Finset V)} (hM : H.IsMatching M) :
    M.card ≤ H.matchingNumber := by
  classical
  have hmem : M.card ∈ H.matchingSizes := by
    exact Finset.mem_image.mpr ⟨M, (H.mem_matchings).2 hM, rfl⟩
  simpa [matchingNumber] using
    (Finset.le_max' H.matchingSizes M.card hmem)

def r : ℕ := sorry

/-

-/
def RyserHypergraphConjecture (W : Type u) [DecidableEq W]
  {H : Hypergraph W} : H.IsUniform r ∧ H.IsPartite r →
      H.coverNumber ≤ (r - 1) * H.matchingNumber := sorry

end

end Hypergraph
