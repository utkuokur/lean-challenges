import Matroid.Representation.Basic
import Matroid.Minor.Iso
import Mathlib.Combinatorics.Matroid.IndepAxioms
import Mathlib.Data.Complex.Basic
import Mathlib.FieldTheory.Finite.GaloisField

/-!
# Challenge 2: Excluded minors of GF(pᵐ)-representable matroids (explicit-list form)

For a prime power `r = pᵐ`, exhibit the complete list of excluded minors for
GF(pᵐ)-representability and prove it complete.  The point of this challenge is to
force the solver to **exhibit a concrete list** of excluded minors and prove it
complete, rather than merely prove that *some* finite list exists.

Why an existence-only phrasing leaks: if the list were `L : Set (Matroid ℕ)` with a
clause `L.Finite`, that clause is *exactly* Rota's excluded-minor conjecture, proved
by Geelen–Gerards–Whittle.  Since that theorem is established, a solver could take
`L := {N | N is a canonical excluded minor}` and discharge `L.Finite` by citing GGW
— without ever naming a single matroid.  This challenge is meant to be *open* (the
explicit list is unknown for general `pᵐ`), so any clause that is itself a known
theorem must not be a proof goal.

The structure that prevents the GGW dodge:

* The list is concrete combinatorial **data** — a `Finset FinMatroid`, where a
  `FinMatroid` is a ground set and independent sets as `Finset`s.  Finiteness and
  duplicate-freeness now ride on the type (a `Finset` is a deduplicated finite
  collection); neither is ever a goal, so GGW cannot be used to manufacture them.
* The clause `∀ A ∈ L, IsMatroidData A` is **decidable** and is meant to be
  discharged by `decide`.  Kernel reduction only goes through genuinely computable
  data, so a `Classical.choice`/`noncomputable` definition of `L` (the GGW dodge)
  gets stuck and this goal fails to close.  This is the lock that forces `L` to be
  a real literal.  Design caveat: pushing a condition into the type makes it free
  *and* disarms it as a lock, so we keep at least this one decidable clause as an
  explicit goal — baking `IsMatroidData` into the type too would leave no lock.
* The remaining clauses are the genuine mathematics.  In particular, once `L` is
  pinned to a literal, **completeness** can no longer be closed by GGW: GGW yields
  *a* finite list, not that *your* specific `L` is complete.  Proving a concrete
  `L` complete is the open determination problem — which is the point.

`r` is left free (faithful to the parametrized TeX open problem), but the solver
must also exhibit the prime-power witnesses `p` and `m` and prove `r = p ^ m` as
part of the *conclusion*.  (An earlier draft took `hr : r = p ^ m` as a
hypothesis; that made every non-prime-power `r` — e.g. `r = 6` or any huge
composite — vacuously provable by refuting `hr`, a leaderboard exploit.)  Note
that the small cases `r = 2, 3, 4` are solved in the literature (Tutte;
Bixby–Seymour; Geelen–Gerards–Kapoor); the challenge is genuinely open only for
`r ≥ 5`.

NOTE: This file compiles cleanly (`lake build Challenges.challenge_02`); the only
`sorry`s are the three the solver must fill (`r`, `L`, `challenge_2`).  The data
model, `decode`, `decode_finite`, and the `challenge_2` statement are all verified.
-/

open Function Matroid

universe u

variable {α : Type u}

/-- A matroid is GF(pᵐ)-representable if it can be represented over the
Galois field of order `p^m` (where `p` is prime). -/
def IsGFRepresentable
    (p m : ℕ) [Fact p.Prime] (M : Matroid α) : Prop :=
  ∃ (W : Type) (_ : AddCommGroup W) (_ : Module (GaloisField p m) W),
    Nonempty (M.Rep (GaloisField p m) W)

/-- N is an excluded minor for the property P if N does not have P, but every
proper minor of N does. -/
def IsExcludedMinorFor (P : Matroid α → Prop) (M : Matroid α) : Prop :=
  ¬ P M ∧ ∀ N : Matroid α, N <m M → P N

/-! ## Concrete, decidable matroid data -/

/-- A finite matroid given by **explicit combinatorial data**: a ground set and a
collection of independent sets, both `Finset`s over `ℕ`.  Equality of `FinMatroid`s
is decidable (it only compares the two `Finset` fields), which is what lets `L` be
a `Finset` and the `IsMatroidData` lock be `decide`-able. -/
structure FinMatroid where
  ground : Finset ℕ
  indep : Finset (Finset ℕ)
deriving DecidableEq

namespace FinMatroid

/-- The independence predicate carried by the data. -/
def Indep (D : FinMatroid) : Finset ℕ → Prop := fun I => I ∈ D.indep

/-- The matroid axioms as a **decidable** check on the raw data.  Every quantifier
is bounded by `D.indep` or a `powerset`, so a solver discharges this by `decide`
for each concrete entry.  A `Classical.choice`-built `FinMatroid` would not reduce
here, so this doubles as part of the anti-dodge lock. -/
def IsMatroidData (D : FinMatroid) : Prop :=
  (∅ ∈ D.indep) ∧
    (∀ J ∈ D.indep, ∀ I ∈ J.powerset, I ∈ D.indep) ∧
      (∀ I ∈ D.indep, ∀ J ∈ D.indep, I.card < J.card →
          ∃ e ∈ J \ I, insert e I ∈ D.indep) ∧
        (∀ I ∈ D.indep, I ⊆ D.ground)

instance (D : FinMatroid) : Decidable (IsMatroidData D) := by
  unfold IsMatroidData; infer_instance

/-- Decode concrete data into the library's abstract `Matroid ℕ` via
`IndepMatroid.ofFinset`.  Total: invalid data decodes to the empty matroid, and
clause (1) of the challenge (`∀ A ∈ L, IsMatroidData A`) rules that case out for
listed entries.  `noncomputable` because it builds a `Matroid` (Prop-valued data);
this is harmless — `decode` is only ever used inside the Props of `challenge_2`,
never computed.  The data the solver supplies (`L`, `IsMatroidData`) stays
computable. -/
noncomputable def decode (D : FinMatroid) : Matroid ℕ :=
  if h : IsMatroidData D then
    (IndepMatroid.ofFinset (↑D.ground) D.Indep
      h.1
      (fun _ J hJ hIJ => h.2.1 J hJ _ (Finset.mem_powerset.2 hIJ))
      (fun _ J _ hJ hlt => by
        obtain ⟨e, he, hins⟩ := h.2.2.1 _ ‹_› J hJ hlt
        exact ⟨e, (Finset.mem_sdiff.1 he).1, (Finset.mem_sdiff.1 he).2, hins⟩)
      (fun _ hI => Finset.coe_subset.2 (h.2.2.2 _ hI))).matroid
  else emptyOn ℕ

/-- Decoded data is always a finite matroid (its ground set is a `Finset`).  This
is elementary finiteness of a single matroid — *not* GGW — so it is fine as a
lemma.  Routine; verify on compile. -/
lemma decode_finite (D : FinMatroid) : D.decode.Finite := by
  unfold decode
  split
  · exact ⟨by simp [IndepMatroid.ofFinset_E, D.ground.finite_toSet]⟩
  · exact ⟨by simp⟩

end FinMatroid

/-! ## The challenge -/

/- Import this module from your submission to reuse the definitions above — don't
copy them. -/

/-- The challenge parameter: the field size.  Must be a prime power — the
solver also supplies the witnesses `p` and `m` below, and `challenge_2` demands
`r = p ^ m` as a conclusion, so a non-prime-power `r` is unprovable rather than
vacuous. -/
def r : ℕ := sorry

/-- The prime `p` witnessing that `r` is a prime power. -/
def p : ℕ := sorry

/-- The positive exponent `m` with `r = p ^ m`. -/
def m : ℕ := sorry

/-- Primality of `p`, registered as an instance so that `GaloisField p m` (and
hence `IsGFRepresentable p m`) elaborates.  The solver replaces the `sorry`
with a genuine proof, e.g. `⟨by norm_num⟩`; a sorried instance is caught by the
axiom gate because it appears in the elaborated statement of `challenge_2`. -/
instance fact_p_prime : Fact p.Prime := sorry

/-- **The excluded-minor list, as concrete data.**  The solver must fill this with
an actual literal, e.g. `{U₂₄}` for `r = 2`.  It cannot be a `Set`, a
`Classical.choice` term, or a `noncomputable` definition: the `IsMatroidData`
clause of `challenge_2` is discharged by `decide`, which only reduces on genuine
data.  Using `Finset` rather than `List` makes duplicate-freeness automatic. -/
def L : Finset FinMatroid := sorry

open FinMatroid in
/-- **The challenge.**  For the chosen field size `r` and the exhibited prime
power decomposition `r = p ^ m` (with `0 < m`), the chosen concrete list `L`:

1. consists of genuine matroid data **(decidable lock — `by decide`)**;
2. lists only excluded minors for GF(pᵐ)-representability;
3. is an antichain: its members are pairwise non-isomorphic; and
4. is **complete**: every finite non-GF(pᵐ)-representable matroid has a minor
   isomorphic to a member of `L`.

The prime-power facts are *conclusions*, not hypotheses: there is nothing to
refute, so a non-prime-power `r` cannot be won vacuously.  Duplicate-freeness is
automatic — `L` is a `Finset`.  Clause (1) forces `L` to be an explicit literal;
clauses (2)–(4) are the genuine mathematics, and (4) is the open determination
that GGW does not settle for a fixed `L`. -/
theorem challenge_2 :
    0 < m ∧ r = p ^ m ∧
    (∀ A ∈ L, IsMatroidData A) ∧
    (∀ A ∈ L, IsExcludedMinorFor (IsGFRepresentable p m) A.decode) ∧
    (∀ A ∈ L, ∀ B ∈ L, A ≠ B → IsEmpty (A.decode ≂ B.decode)) ∧
    (∀ {β : Type u} (M : Matroid β), M.Finite →
        ¬ IsGFRepresentable p m M → ∃ A ∈ L, Nonempty (A.decode ≤i M)) := sorry
