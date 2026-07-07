import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs
import Mathlib.SetTheory.Ordinal.Basic
import Defs_and_Lems.UnfriendlyPartition

universe u v

/-- A partial partition of the vertices: an undefined vertex has value `none`. -/
abbrev PartialPartition (V : Type u) : Type u :=
  V -> Option Bool

/- The empty partial partition. -/
def emptyPartialPartition (V : Type u) : PartialPartition V :=
  fun _ => none

/-- A partial partition is finite when its domain injects into some finite type. -/
def HasFiniteDomain {V : Type u} (f : PartialPartition V) : Prop :=
  ∃ n : Nat, ∃ encode : {v : V // f v ≠ none} -> Fin n,
    Function.Injective encode

/-- `g` extends `f` when all assignments already made by `f` are preserved. -/
def Extends {V : Type u} (f g : PartialPartition V) : Prop :=
  ∀ v b, f v = some b -> g v = some b

/-! ## The `r`-partitioning game
The game is played between two players, Challenger and Partitioner. A
position is a pair `(f, α)` consisting of a partial partition `f` and an
ordinal `α`; the initial position of the `r`-partitioning game is
`(emptyPartialPartition V, r)`. In each turn, beginning in position
`(f, α)`, Challenger must name a vertex `v` and an ordinal `β < α`,
and Partitioner must then name a finite partial partition `g` extending `f`
which is defined at `v` and unfriendly at `v`; the new position is `(g, β)`.
If at any point some player is unable to move, the other player wins.
Since there are no infinite decreasing sequences of ordinals, the game ends
after finitely many turns.
-/

/- A legal response by Partitioner from position `f` to the challenged
vertex `v`: a finite partial partition `g` extending `f` which is defined at
`v` and unfriendly at `v`. -/
def IsLegalResponse {V : Type u} (G : SimpleGraph V)
    (f g : PartialPartition V) (v : V) : Prop :=
  Extends f g ∧ HasFiniteDomain g ∧ g v ≠ none ∧ UnfriendlyAt some G g v

/- Partitioner has a winning strategy in the partitioning game from position
`(f, α)`. Because every play of the game is finite, having a winning
strategy is equivalent to this backward-induction characterization: to every
Challenger move `(v, β)` with `β < α`, Partitioner has a legal
response from which Partitioner again has a winning strategy. The recursion
is well-founded because the ordinal strictly decreases. -/
def PartitionerWins {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) (α : Ordinal.{v}) : Prop :=
  ∀ v : V, ∀ β : Ordinal.{v}, β < α ->
    ∃ g : PartialPartition V,
      IsLegalResponse G f g v ∧ PartitionerWins G g β
termination_by α

/- The challenge parameter -/
def r : Ordinal.{v} := sorry

/-
Scaled Unfriendly Partition Conjecture for the chosen ordinal `r`: on every
countable graph, Partitioner has a winning strategy in the `r`-partitioning
game.
-/
theorem challenge_10 :
    ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    PartitionerWins G (emptyPartialPartition V) r := by
  sorry
