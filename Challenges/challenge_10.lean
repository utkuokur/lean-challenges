import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Countable.Defs
import Mathlib.SetTheory.Ordinal.Basic
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

/-- A partial partition is unfriendly at `x` when `x` has at least as many
neighbours mapped to the opposite partition class as neighbours mapped to its
own class, with cardinalities compared by injections (so vertices of infinite
degree are handled correctly). -/
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

/-- The Unfriendly Partition Conjecture (Cowan and Emerson):
every countable graph has an unfriendly partition. -/
def UnfriendlyPartitionConjecture : Prop :=
  forall {V : Type u}, CountableType V -> forall G : SimpleGraph V,
    exists f : PartialPartition V, IsUnfriendlyPartition G f

/-! ## The `r`-partitioning game

The game is played between two players, Challenger and Partitioner. A
position is a pair `(f, alpha)` consisting of a partial partition `f` and an
ordinal `alpha`; the initial position of the `r`-partitioning game is
`(emptyPartialPartition V, r)`. In each turn, beginning in position
`(f, alpha)`, Challenger must name a vertex `v` and an ordinal `beta < alpha`,
and Partitioner must then name a finite partial partition `g` extending `f`
which is defined at `v` and unfriendly at `v`; the new position is `(g, beta)`.
If at any point some player is unable to move, the other player wins.
Since there are no infinite decreasing sequences of ordinals, the game ends
after finitely many turns. -/

/-- A legal response by Partitioner from position `f` to the challenged
vertex `v`: a finite partial partition `g` extending `f` which is defined at
`v` and unfriendly at `v`. -/
def IsLegalResponse {V : Type u} (G : SimpleGraph V)
    (f g : PartialPartition V) (v : V) : Prop :=
  Extends f g /\ HasFiniteDomain g /\ g v ≠ none /\ UnfriendlyAt G g v

/-- Partitioner has a winning strategy in the partitioning game from position
`(f, alpha)`. Because every play of the game is finite, having a winning
strategy is equivalent to this backward-induction characterization: to every
Challenger move `(v, beta)` with `beta < alpha`, Partitioner has a legal
response from which Partitioner again has a winning strategy. The recursion
is well-founded because the ordinal strictly decreases. -/
def PartitionerWins {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) (alpha : Ordinal.{v}) : Prop :=
  forall v : V, forall beta : Ordinal.{v}, beta < alpha ->
    exists g : PartialPartition V,
      IsLegalResponse G f g v /\ PartitionerWins G g beta
termination_by alpha

/-- The defining recurrence of `PartitionerWins`, as an `iff`. -/
theorem partitionerWins_iff {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) (alpha : Ordinal.{v}) :
    PartitionerWins G f alpha <->
      forall v : V, forall beta : Ordinal.{v}, beta < alpha ->
        exists g : PartialPartition V,
          IsLegalResponse G f g v /\ PartitionerWins G g beta := by
  rw [PartitionerWins]

/-- When the clock is `0`, Challenger cannot move, so Partitioner wins. -/
theorem partitionerWins_zero {V : Type u} (G : SimpleGraph V)
    (f : PartialPartition V) :
    PartitionerWins G f (0 : Ordinal.{v}) := by
  rw [partitionerWins_iff]
  intro v beta hbeta
  exact absurd hbeta not_lt_zero

/-- A winning position stays winning when the clock is lowered. -/
theorem PartitionerWins.mono {V : Type u} {G : SimpleGraph V}
    {f : PartialPartition V} {alpha beta : Ordinal.{v}}
    (hle : beta <= alpha) (h : PartitionerWins G f alpha) :
    PartitionerWins G f beta := by
  rw [partitionerWins_iff] at h ⊢
  intro v gamma hgamma
  exact h v gamma (lt_of_lt_of_le hgamma hle)

/-- Partitioner survives one turn from the empty position by assigning only
the challenged vertex: its assigned neighbourhood is then empty, so the
unfriendliness bound holds vacuously. -/
theorem partitionerWins_one {V : Type u} (G : SimpleGraph V) :
    PartitionerWins G (emptyPartialPartition V) (1 : Ordinal.{v}) := by
  classical
  rw [partitionerWins_iff]
  intro v beta hbeta
  refine ⟨fun w => if w = v then some true else none, ⟨?_, ?_, ?_, ?_⟩, ?_⟩
  · intro w b hw
    simp [emptyPartialPartition] at hw
  · refine ⟨1, fun _ => 0, ?_⟩
    intro x y _
    have hx : x.val = v := by
      by_contra hne
      exact x.property (if_neg hne)
    have hy : y.val = v := by
      by_contra hne
      exact y.property (if_neg hne)
    exact Subtype.ext (hx.trans hy.symm)
  · simp
  · refine ⟨true, by simp, ?_⟩
    have hempty : forall y : neighboursInSide G
        (fun w => if w = v then some true else none) v true, False := by
      rintro ⟨y, hadj, hyval⟩
      by_cases hyv : y = v
      · exact G.irrefl (hyv ▸ hadj)
      · simp [hyv] at hyval
    exact ⟨fun y => (hempty y).elim, fun y _ _ => (hempty y).elim⟩
  · have hzero : beta = 0 := Order.lt_one_iff.mp hbeta
    rw [hzero]
    exact partitionerWins_zero G _

/-- The scaled conjecture at a fixed ordinal `rho`: on every countable graph,
Partitioner has a winning strategy in the `rho`-partitioning game, starting
from the empty partial partition. -/
def ScaledUnfriendlyPartitionConjectureFor (rho : Ordinal.{v}) : Prop :=
  forall {V : Type u}, CountableType V -> forall G : SimpleGraph V,
    PartitionerWins G (emptyPartialPartition V) rho

/-- The Scaled Unfriendly Partition Conjecture: for every ordinal `rho`,
Partitioner has a winning strategy in the `rho`-partitioning game on every
countable graph. -/
def ScaledUnfriendlyPartitionConjecture : Prop :=
  forall rho : Ordinal.{v}, ScaledUnfriendlyPartitionConjectureFor.{u, v} rho

/-- The scaled conjecture gets weaker as the ordinal decreases. -/
theorem scaledFor_mono {rho sigma : Ordinal.{v}} (hle : sigma <= rho)
    (h : ScaledUnfriendlyPartitionConjectureFor.{u, v} rho) :
    ScaledUnfriendlyPartitionConjectureFor.{u, v} sigma := by
  intro V hV G
  exact (h hV G).mono hle

/-- The scaled conjecture holds outright at `rho = 0`. -/
theorem scaledFor_zero : ScaledUnfriendlyPartitionConjectureFor.{u, v} 0 := by
  intro V hV G
  exact partitionerWins_zero G _

/-- The scaled conjecture holds outright at `rho = 1`. -/
theorem scaledFor_one : ScaledUnfriendlyPartitionConjectureFor.{u, v} 1 := by
  intro V hV G
  exact partitionerWins_one G

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
unfriendly partition conjecture. -/
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

universe u v

/-- The challenge parameter. -/
def r : ℕ := sorry

/--
Scaled Unfriendly Partition Conjecture for the chosen `r`: on every countable
graph, Partitioner has a winning strategy in the `r`-partitioning game.
-/
theorem challenge_10 :
    UnfriendlyPartition.ScaledUnfriendlyPartitionConjectureFor.{u, v}
      (r : Ordinal.{v}) := by
  sorry
