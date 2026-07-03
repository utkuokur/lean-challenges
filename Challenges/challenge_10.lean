import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs
import Mathlib.SetTheory.Ordinal.Basic
import Defs_and_Lems.UnfriendlyPartition
/-===========================================================================-/
/-!# The Unfriendly Partition Conjecture -/
/-===========================================================================-/

namespace UnfriendlyPartition

universe u v


theorem finiteType_countable {V : Type u} (h : Finite V) :
    Countable V := by
  letI : Finite V := h
  infer_instance

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

theorem emptyPartialPartition_finite (V : Type u) :
    HasFiniteDomain (emptyPartialPartition V) := by
  refine ⟨0, (fun x => False.elim (x.property rfl)), ?_⟩
  intro x _ _
  exact False.elim (x.property rfl)

/-- A partial partition is total when every vertex is assigned a side. -/
def IsPartition {V : Type u} (f : PartialPartition V) : Prop :=
  ∀ v : V, ∃ b : Bool, f v = some b

/-- `g` extends `f` when all assignments already made by `f` are preserved. -/
def Extends {V : Type u} (f g : PartialPartition V) : Prop :=
  ∀ v b, f v = some b -> g v = some b

/- `neighboursInSide`, `UnfriendlyAt`, `InjectsInto`, `AtLeastAsMany`, and
`atLeastAsMany_refl` are shared with the plain conjecture
(`challenge_10_univ`/`challenge_10_disprove`) via
`Defs_and_Lems.UnfriendlyPartition`.  They are generic over the assignment
codomain; the game instantiates them at partial partitions
`f : V → Option Bool` with `sideVal = some`, so `neighboursInSide G f x (some b)`
is the set of neighbours on side `b` and `UnfriendlyAt some G f x` unfolds to
`∃ b, f x = some b ∧ …` (the `some b` also witnessing that `x` is assigned). -/

/-- A partial partition that is total and unfriendly at every vertex. -/
def IsUnfriendlyPartition {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) : Prop :=
  IsPartition f ∧ ∀ x : V, UnfriendlyAt some G f x

theorem unfriendlyAt_defined {V : Type u} {G : SimpleGraph V}
    {f : PartialPartition V} {x : V} (h : UnfriendlyAt some G f x) :
    ∃ b : Bool, f x = some b := by
  rcases h with ⟨b, hb, _⟩
  exact ⟨b, hb⟩

theorem unfriendlyAt_same_to_opposite_bound {V : Type u} {G : SimpleGraph V}
    {f : PartialPartition V} {x : V} (h : UnfriendlyAt some G f x) :
    ∃ b : Bool,
      f x = some b ∧
        InjectsInto
          (neighboursInSide G f x (some b))
          (neighboursInSide G f x (some !b)) := by
  rcases h with ⟨b, hb, hbound⟩
  exact ⟨b, hb, hbound⟩

/-! ## The target conjectures -/

/-- The Unfriendly Partition Conjecture (Cowan and Emerson):
every countable graph has an unfriendly partition. -/
def UnfriendlyPartitionConjecture : Prop :=
  ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    ∃ f : PartialPartition V, IsUnfriendlyPartition G f

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

/-- Partitioner has a winning strategy in the partitioning game from position
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

/-- The defining recurrence of `PartitionerWins`, as an `iff`. -/
theorem partitionerWins_iff {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) (α : Ordinal.{v}) :
    PartitionerWins G f α <->
      ∀ v : V, ∀ β : Ordinal.{v}, β < α ->
        ∃ g : PartialPartition V,
          IsLegalResponse G f g v ∧ PartitionerWins G g β := by
  rw [PartitionerWins]

/-- The scaled conjecture at a fixed ordinal `rho`: on every countable graph,
Partitioner has a winning strategy in the `rho`-partitioning game, starting
from the empty partial partition. -/
def ScaledUnfriendlyPartitionConjectureFor (r : Ordinal.{v}) : Prop :=
  ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    PartitionerWins G (emptyPartialPartition V) r

/-- The Scaled Unfriendly Partition Conjecture: for every ordinal `rho`,
Partitioner has a winning strategy in the `rho`-partitioning game on every
countable graph. -/
def ScaledUnfriendlyPartitionConjecture : Prop :=
  ∀ r : Ordinal.{v}, ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    PartitionerWins G (emptyPartialPartition V) r

/-! ## Upstream layer -/

/-- First upstream lemma: countable graph instances admit total partitions. -/
def CountableGraphsAdmitPartitions : Prop :=
  ∀ {V : Type u}, Countable V -> ∀ _ : SimpleGraph V,
    ∃ f : PartialPartition V, IsPartition f

/-- Second upstream lemma: any total partition on a countable graph can be
replaced by an unfriendly total partition. -/
def CountablePartitionImprovement : Prop :=
  ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    (∃ f : PartialPartition V, IsPartition f) ->
      ∃ g : PartialPartition V, IsUnfriendlyPartition G g

theorem upstream_implies_unfriendlyPartitionConjecture
    (hpart : CountableGraphsAdmitPartitions.{u})
    (himprove : CountablePartitionImprovement.{u}) :
    UnfriendlyPartitionConjecture.{u} := by
  intro V hV G
  exact @himprove V hV G (@hpart V hV G)

/-- A single upstream statement equivalent to the target conjecture. -/
def CountableGraphsAdmitUnfriendlyPartitions : Prop :=
  ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    ∃ f : PartialPartition V, IsUnfriendlyPartition G f

theorem firstLayer_implies_target
    (h : CountableGraphsAdmitUnfriendlyPartitions.{u}) :
    UnfriendlyPartitionConjecture.{u} := by
  intro V hV G
  exact h hV G

theorem target_implies_firstLayer
    (h : UnfriendlyPartitionConjecture.{u}) :
    CountableGraphsAdmitUnfriendlyPartitions.{u} := by
  intro V hV G
  exact h hV G

theorem firstLayer_iff_target :
    CountableGraphsAdmitUnfriendlyPartitions.{u} <->
      UnfriendlyPartitionConjecture.{u} := by
  constructor
  · exact firstLayer_implies_target
  · exact target_implies_firstLayer

/-! ## Downstream layer -/

theorem target_gives_partition {V : Type u} (h : UnfriendlyPartitionConjecture.{u})
    (hV : Countable V) (G : SimpleGraph V) :
    ∃ f : PartialPartition V, IsPartition f := by
  rcases h hV G with ⟨f, hf⟩
  exact ⟨f, hf.1⟩

theorem target_gives_unfriendly_at_each_vertex {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : Countable V)
    (G : SimpleGraph V) :
    ∃ f : PartialPartition V, ∀ x : V, UnfriendlyAt some G f x := by
  rcases h hV G with ⟨f, hf⟩
  exact ⟨f, hf.2⟩

theorem target_gives_finite_graph_case {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : Finite V)
    (G : SimpleGraph V) :
    ∃ f : PartialPartition V, IsUnfriendlyPartition G f := by
  exact h (finiteType_countable hV) G

theorem target_gives_neighbor_bound {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : Countable V)
    (G : SimpleGraph V) :
    ∃ f : PartialPartition V,
      ∀ x : V,
        ∃ b : Bool,
          f x = some b ∧
            InjectsInto
              (neighboursInSide G f x (some b))
              (neighboursInSide G f x (some !b)) := by
  rcases h hV G with ⟨f, hf⟩
  refine ⟨f, ?_⟩
  intro x
  exact unfriendlyAt_same_to_opposite_bound (hf.2 x)

/-! ## Conjectural extension, clearly conditional -/

end UnfriendlyPartition

universe u v

/-- The challenge parameter: an ordinal clock for the `r`-partitioning game.
Taking `r : Ordinal` (rather than `ℕ`) lets submissions reach the interesting
regime `r ≥ ω`, where Partitioner's strategy genuinely encodes the difficulty
of the conjecture; the finite rungs `r < ω` are elementary. -/
def r : Ordinal.{v} := sorry

/-
Scaled Unfriendly Partition Conjecture for the chosen ordinal `r`: on every
countable graph, Partitioner has a winning strategy in the `r`-partitioning
game.
-/
theorem challenge_10 :
    ∀ {V : Type u}, Countable V -> ∀ G : SimpleGraph V,
    UnfriendlyPartition.PartitionerWins G (UnfriendlyPartition.emptyPartialPartition V) r := by
  sorry
