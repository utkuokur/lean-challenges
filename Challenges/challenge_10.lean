import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs
/-===========================================================================-/
/-!# The Unfriendly Partition Conjecture -/
/-===========================================================================-/

namespace UnfriendlyPartition

universe u v

/-- A type is countable when it injects into `Nat`. -/
abbrev CountableType (V : Type u) : Prop :=
  Countable V

/-- Finite vertex types use mathlib's `Finite` predicate. -/
abbrev FiniteType (V : Type u) : Prop :=
  Finite V

theorem finiteType_countable {V : Type u} (h : FiniteType V) :
    CountableType V := by
  letI : Finite V := h
  infer_instance

/-- A partial partition of the vertices: an undefined vertex has value `none`. -/
abbrev PartialPartition (V : Type u) : Type u :=
  V -> Option Bool

/-- The empty partial partition. -/
def emptyPartialPartition (V : Type u) : PartialPartition V :=
  fun _ => none

/-- A partial partition is finite when its domain injects into some finite type. -/
def HasFiniteDomain {V : Type u} (f : PartialPartition V) : Prop :=
  exists n : Nat, exists encode : {v : V // f v ≠ none} -> Fin n,
    Function.Injective encode

theorem emptyPartialPartition_finite (V : Type u) :
    HasFiniteDomain (emptyPartialPartition V) := by
  refine ⟨0, (fun x => False.elim (x.property rfl)), ?_⟩
  intro x _ _
  exact False.elim (x.property rfl)

/-- A partial partition is total when every vertex is assigned a side. -/
def IsPartition {V : Type u} (f : PartialPartition V) : Prop :=
  forall v : V, exists b : Bool, f v = some b

/-- `g` extends `f` when all assignments already made by `f` are preserved. -/
def Extends {V : Type u} (f g : PartialPartition V) : Prop :=
  forall v b, f v = some b -> g v = some b

theorem extends_refl {V : Type u} (f : PartialPartition V) :
    Extends f f := by
  intro _ _ h
  exact h

theorem extends_trans {V : Type u} {f g h : PartialPartition V}
    (hfg : Extends f g) (hgh : Extends g h) :
    Extends f h := by
  intro v b hv
  exact hgh v b (hfg v b hv)

/-- An injection-based comparison of cardinalities. -/
def InjectsInto (A : Type u) (B : Type v) : Prop :=
  exists e : A -> B, Function.Injective e

/-- `A` has at least as many elements as `B`. -/
def AtLeastAsMany (A : Type u) (B : Type v) : Prop :=
  InjectsInto B A

theorem atLeastAsMany_refl (A : Type u) :
    AtLeastAsMany A A := by
  exact ⟨id, fun _ _ h => h⟩

/-- Neighbours of `x` currently mapped to side `b`. -/
def neighboursInSide {V : Type u} (G : SimpleGraph V) (f : PartialPartition V)
    (x : V) (b : Bool) : Type u :=
  {y : V // G.Adj x y /\ f y = some b}

/-- The formal bound in Definition 16: opposite-side neighbours dominate same-side
neighbours, both measured by injection/cardinality comparison. -/
def UnfriendlyAt {V : Type u} (G : SimpleGraph V) (f : PartialPartition V)
    (x : V) : Prop :=
  exists b : Bool,
    f x = some b /\
      AtLeastAsMany
        (neighboursInSide G f x (!b))
        (neighboursInSide G f x b)

/-- A total partition unfriendly at every vertex. -/
def IsUnfriendlyPartition {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) : Prop :=
  IsPartition f /\ forall x : V, UnfriendlyAt G f x

theorem unfriendlyAt_defined {V : Type u} {G : SimpleGraph V}
    {f : PartialPartition V} {x : V} (h : UnfriendlyAt G f x) :
    exists b : Bool, f x = some b := by
  rcases h with ⟨b, hb, _⟩
  exact ⟨b, hb⟩

theorem unfriendlyAt_same_to_opposite_bound {V : Type u} {G : SimpleGraph V}
    {f : PartialPartition V} {x : V} (h : UnfriendlyAt G f x) :
    exists b : Bool,
      f x = some b /\
        InjectsInto
          (neighboursInSide G f x b)
          (neighboursInSide G f x (!b)) := by
  rcases h with ⟨b, hb, hbound⟩
  exact ⟨b, hb, hbound⟩

/-! ## The target conjectures -/

/-- Conjecture 1.14: every countable graph has an unfriendly partition. -/
def UnfriendlyPartitionConjecture : Prop :=
  forall {V : Type u}, CountableType V -> forall G : SimpleGraph V,
    exists f : PartialPartition V, IsUnfriendlyPartition G f

/-- A game clock: an ordinal-like well-founded countdown with a top state. -/
structure GameClock where
  State : Type u
  lt : State -> State -> Prop
  top : State
  wf : WellFounded lt

/-- A finite legal response by Partitioner to a challenged vertex. -/
def PartitionerResponseAvailable {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) (x : V) : Prop :=
  exists g : PartialPartition V,
    Extends f g /\ HasFiniteDomain g /\ g x ≠ none /\ UnfriendlyAt G g x

/-- A conservative local formalization of having a strategy in the
`r`-partitioning game: at every live clock state and every Challenger move,
Partitioner has a legal finite response. -/
def PartitionerHasWinningStrategy {V : Type u} (clock : GameClock.{v})
    (G : SimpleGraph V) : Prop :=
  forall (f : PartialPartition V) (alpha beta : clock.State) (x : V),
    clock.lt beta alpha -> PartitionerResponseAvailable G f x

/-- Conjecture 1.15, with the ordinal parameter represented by a well-founded
game clock. -/
def ScaledUnfriendlyPartitionConjecture : Prop :=
  forall (clock : GameClock.{v}) {V : Type u}, CountableType V ->
    forall G : SimpleGraph V, PartitionerHasWinningStrategy clock G

/-! ## Upstream layer -/

/-- First upstream lemma: countable graph instances admit total partitions. -/
def CountableGraphsAdmitPartitions : Prop :=
  forall {V : Type u}, CountableType V -> forall _ : SimpleGraph V,
    exists f : PartialPartition V, IsPartition f

/-- Second upstream lemma: any total partition on a countable graph can be
replaced by an unfriendly total partition. -/
def CountablePartitionImprovement : Prop :=
  forall {V : Type u}, CountableType V -> forall G : SimpleGraph V,
    (exists f : PartialPartition V, IsPartition f) ->
      exists g : PartialPartition V, IsUnfriendlyPartition G g

theorem upstream_implies_unfriendlyPartitionConjecture
    (hpart : CountableGraphsAdmitPartitions.{u})
    (himprove : CountablePartitionImprovement.{u}) :
    UnfriendlyPartitionConjecture.{u} := by
  intro V hV G
  exact @himprove V hV G (@hpart V hV G)

/-- A single upstream statement equivalent to the target conjecture. -/
def CountableGraphsAdmitUnfriendlyPartitions : Prop :=
  forall {V : Type u}, CountableType V -> forall G : SimpleGraph V,
    exists f : PartialPartition V, IsUnfriendlyPartition G f

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
    (hV : CountableType V) (G : SimpleGraph V) :
    exists f : PartialPartition V, IsPartition f := by
  rcases h hV G with ⟨f, hf⟩
  exact ⟨f, hf.1⟩

theorem target_gives_unfriendly_at_each_vertex {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : CountableType V)
    (G : SimpleGraph V) :
    exists f : PartialPartition V, forall x : V, UnfriendlyAt G f x := by
  rcases h hV G with ⟨f, hf⟩
  exact ⟨f, hf.2⟩

theorem target_gives_finite_graph_case {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : FiniteType V)
    (G : SimpleGraph V) :
    exists f : PartialPartition V, IsUnfriendlyPartition G f := by
  exact h (finiteType_countable hV) G

theorem target_gives_neighbor_bound {V : Type u}
    (h : UnfriendlyPartitionConjecture.{u}) (hV : CountableType V)
    (G : SimpleGraph V) :
    exists f : PartialPartition V,
      forall x : V,
        exists b : Bool,
          f x = some b /\
            InjectsInto
              (neighboursInSide G f x b)
              (neighboursInSide G f x (!b)) := by
  rcases h hV G with ⟨f, hf⟩
  refine ⟨f, ?_⟩
  intro x
  exact unfriendlyAt_same_to_opposite_bound (hf.2 x)

/-! ## Conjectural extension, clearly conditional -/

/-- Conditional bridge: the scaled game conjecture entails the ordinary
unfriendly partition conjecture.  -/
def ScaledImpliesOrdinary : Prop :=
  ScaledUnfriendlyPartitionConjecture.{u, v} ->
    UnfriendlyPartitionConjecture.{u}

theorem scaled_conditional_implies_target
    (hscaled : ScaledUnfriendlyPartitionConjecture.{u, v})
    (hbridge : ScaledImpliesOrdinary.{u, v}) :
    UnfriendlyPartitionConjecture.{u} := by
  exact hbridge hscaled

theorem scaled_conditional_gives_finite_case
    (hscaled : ScaledUnfriendlyPartitionConjecture.{u, v})
    (hbridge : ScaledImpliesOrdinary.{u, v})
    {V : Type u} (hV : FiniteType V) (G : SimpleGraph V) :
    exists f : PartialPartition V, IsUnfriendlyPartition G f := by
  exact target_gives_finite_graph_case
    (scaled_conditional_implies_target hscaled hbridge) hV G

end UnfriendlyPartition

