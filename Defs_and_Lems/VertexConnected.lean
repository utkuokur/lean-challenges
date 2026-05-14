
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Data.Set.Card
import Mathlib.Combinatorics.SimpleGraph.Paths

namespace SimpleGraph

variable {V : Type*} (G : SimpleGraph V) (s : Set V)

/-- Two vertices `u` and `v` are reachable in a graph `G` on `s` if there exists a walk from `u` to
`v` in `G` whose vertices all lie within `s`. -/
def ReachableOn (u v : V) : Prop := ∃ w : G.Walk u v, ∀ ⦃x⦄, x ∈ w.support → x ∈ s

def PreconnectedOn : Prop := ∀ ⦃x⦄, x ∈ s → ∀ ⦃y⦄, y ∈ s → G.ReachableOn s x y

/-- A graph `G` is connected on a set `s` if `s` is nonempty and any two vertices of `s` are
reachable on `s`. -/
def ConnectedOn : Prop := s.Nonempty ∧ G.PreconnectedOn s

def IsVertexConnected (k : ℕ) (G : SimpleGraph V) : Prop :=
  k < ENat.card V ∧ ∀ ⦃s : Set V⦄, s.encard < k → G.ConnectedOn sᶜ

end SimpleGraph
