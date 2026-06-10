import Mathlib.Data.Finset.Card

universe u

namespace Challenge08

structure Hypergraph (V : Type u) [DecidableEq V] where
  vertices : Finset V
  edges : Finset (Finset V)
  edge_subset_vertices : forall {e : Finset V}, e ∈ edges -> e ⊆ vertices

namespace Hypergraph

variable {V : Type u} [DecidableEq V]

/-- An `r`-uniform hypergraph has every edge of cardinality `r`. -/
def IsUniform (H : Hypergraph V) (r : Nat) : Prop :=
  forall {e : Finset V}, e ∈ H.edges -> e.card = r

/--
An `r`-partite hypergraph has its vertices partitioned into `r` parts, and
every edge meets every part in exactly one vertex.
-/
def IsPartite (H : Hypergraph V) (r : Nat) : Prop :=
  exists parts : Fin r -> Finset V,
    (forall v : V, v ∈ H.vertices <-> exists i : Fin r, v ∈ parts i) /\
      (forall i j : Fin r, i ≠ j -> Disjoint (parts i) (parts j)) /\
        (forall {e : Finset V}, e ∈ H.edges ->
          forall i : Fin r, ((parts i) ∩ e).card = 1)

/-- A vertex cover is a set of vertices meeting every edge. -/
def IsVertexCover (H : Hypergraph V) (C : Finset V) : Prop :=
  C ⊆ H.vertices /\
    forall {e : Finset V}, e ∈ H.edges -> exists v : V, v ∈ C /\ v ∈ e

/-- A matching is a finite set of pairwise disjoint edges. -/
def IsMatching (H : Hypergraph V) (M : Finset (Finset V)) : Prop :=
  (forall {e : Finset V}, e ∈ M -> e ∈ H.edges) /\
    forall {e1 : Finset V}, e1 ∈ M ->
      forall {e2 : Finset V}, e2 ∈ M -> e1 ≠ e2 -> Disjoint e1 e2

/-- `tau` is the vertex-cover number of `H`, stated relationally. -/
def IsCoverNumber (H : Hypergraph V) (tau : Nat) : Prop :=
  (exists C : Finset V, H.IsVertexCover C /\ C.card = tau) /\
    forall C : Finset V, H.IsVertexCover C -> tau <= C.card

/-- `nu` is the matching number of `H`, stated relationally. -/
def IsMatchingNumber (H : Hypergraph V) (nu : Nat) : Prop :=
  (exists M : Finset (Finset V), H.IsMatching M /\ M.card = nu) /\
    forall M : Finset (Finset V), H.IsMatching M -> M.card <= nu

/-- Ryser's hypergraph conjecture for a fixed value of `r`. -/
def RyserConjectureFor (r : Nat) : Prop :=
  forall (V : Type u) [DecidableEq V], forall H : Hypergraph V,
    H.IsUniform r ->
      H.IsPartite r ->
        forall tau nu : Nat,
          H.IsCoverNumber tau ->
            H.IsMatchingNumber nu ->
              tau <= (r - 1) * nu

end Hypergraph

end Challenge08

/- Import this module from your submission to reuse the definitions above — don't copy them. -/

/-- The challenge parameter. -/
def r : ℕ := sorry

/--
Ryser's hypergraph conjecture for the chosen `r` (with `2 <= r`):
every `r`-partite `r`-uniform hypergraph satisfies `tau <= (r - 1) * nu`.

For `r = 2` this is a classical theorem of König, and for `r = 3` it was
proved by Aharoni. The hypothesis `2 <= r` is necessary: for `r = 1` the
bound reads `tau <= 0`, which already fails for the single-vertex
single-edge hypergraph (where `tau = nu = 1`).
-/
theorem challenge_8 (hr : 2 <= r) :
    Challenge08.Hypergraph.RyserConjectureFor.{u} r := by
  sorry
