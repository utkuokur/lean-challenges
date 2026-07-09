import Mathlib.Data.Finset.Card

/-
Ryser's hypergraph conjecture for the chosen `r` (with `2 ≤ r`):
every `r`-partite `r`-uniform hypergraph satisfies `tau <= (r - 1) * nu`.

For `r = 2` this is a classical theorem of König, and for `r = 3` it was
proved by Aharoni. The hypothesis `2 <= r` is necessary: for `r = 1` the
bound reads `tau <= 0`, which already fails for the single-vertex
single-edge hypergraph (where `tau = nu = 1`).
-/

structure Hypergraph (α : Type*) where
  vertices : Finset α
  edges : Set (Finset α)
  edges_subset_vertices : ∀ e ∈ edges, e ⊆ vertices

variable {V : Type*} [DecidableEq V] (H : Hypergraph V)

namespace Hypergraph

/- An `r`-uniform hypergraph has every edge of cardinality `r`. -/
def IsUniform (r : ℕ) : Prop :=
  ∀ {e : Finset V}, e ∈ H.edges -> e.card = r

/-
An `r`-partite hypergraph has its vertices partitioned into `r` parts, and
every edge meets every part in exactly one vertex.
-/
def IsPartite (r : ℕ) [DecidableEq V] : Prop :=
  exists parts : Fin r -> Finset V,
    (∀ v : V, v ∈ H.vertices <-> exists i : Fin r, v ∈ parts i) ∧
      (∀ i j : Fin r, i ≠ j -> Disjoint (parts i) (parts j)) ∧
        (∀ {e : Finset V}, e ∈ H.edges ->
          ∀ i : Fin r, ((parts i) ∩ e).card = 1)

/- A vertex cover is a set of vertices meeting every edge. -/
def IsVertexCover (C : Finset V) : Prop :=
  C ⊆ H.vertices ∧
    ∀ {e : Finset V}, e ∈ H.edges -> exists v : V, v ∈ C ∧ v ∈ e

/- A matching is a finite set of pairwise disjoint edges. -/
def IsMatching (M : Finset (Finset V)) : Prop :=
  (∀ {e : Finset V}, e ∈ M -> e ∈ H.edges) ∧
    ∀ {e1 : Finset V}, e1 ∈ M ->
      ∀ {e2 : Finset V}, e2 ∈ M -> e1 ≠ e2 -> Disjoint e1 e2

/- `tau` is the vertex-cover number of `H`, stated relationally. -/
def IsCoverNumber (tau : ℕ) : Prop :=
  (exists C : Finset V, H.IsVertexCover C ∧ C.card = tau) ∧
    ∀ C : Finset V, H.IsVertexCover C -> tau <= C.card

/- `nu` is the matching number of `H`, stated relationally. -/
def IsMatchingNumber (nu : ℕ) : Prop :=
  (exists M : Finset (Finset V), H.IsMatching M ∧ M.card = nu) ∧
    ∀ M : Finset (Finset V), H.IsMatching M -> M.card <= nu

/- Ryser's hypergraph conjecture for a fixed value of `r`. -/
def RyserConjectureFor (r : ℕ) : Prop :=
  H.IsUniform r ->
    H.IsPartite r ->
      ∀ tau nu : ℕ,
        H.IsCoverNumber tau ->
          H.IsMatchingNumber nu ->
            tau <= (r - 1) * nu

end Hypergraph

universe u

/-- Ryser's hypergraph conjecture for a fixed parameter `r`, quantified over every
hypergraph (with the necessary `2 ≤ r` hypothesis). The single named statement
shared by the canonical theorem and the submission signature-shim. -/
def statement_08 (r : ℕ) : Prop :=
  ∀ {V : Type u} [DecidableEq V] (H : Hypergraph V),
    2 ≤ r → Hypergraph.RyserConjectureFor H r

/- The challenge parameter. -/
def r : ℕ := sorry

theorem challenge_8 : statement_08.{u} r := by
  sorry
