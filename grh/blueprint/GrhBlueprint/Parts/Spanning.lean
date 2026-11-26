/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import New.Reduction.ShortAndEnough

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem B. Filling the target by translates" =>

%%%
tag := "guide-spanning"
%%%

Even when individual vectors are very short, many of them can point in the same direction. The second moment measures the overlap between the image of the Poincaré map and its translates. Write $`B` for the scaled map. An overlap is measured by the squared Hilbert–Schmidt norm of `B* s B`, the sum of the squared absolute values of its matrix entries in orthonormal bases.

# Turning moments into dimension

The calculation needs a lower bound for the projected map in mean square and an upper bound for the sum of the overlaps. For this family of spaces, multiplicity comparison counts the target on a definite group with free level. Unfolding the Poincaré series expresses its matrix coefficients through local integrals. The identity contribution supplies the main term. The estimates for the other terms and for the bad local types control the loss when the two level projectors are applied. These are the inputs to `isSpread_of_second_moment`. [Moment hypotheses and their application](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/SpanningTheorem.lean).

For a subspace already spanned, the moment inequality finds a translate whose preimage of that subspace is small. The rest of the translate contributes new dimensions. Repeating the selection reduces the missing dimension and incurs a logarithmic factor in the number of translates. [Finite-dimensional covering argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/FewTranslates.lean).

# What enters the second moment

Organize the matrix of each overlap by two source classes and an element of the residual level group. After unfolding, a block is a sum of amplitudes indexed by rational elements with the prescribed reduction. Squaring makes *pairs* of such terms appear. Sorting pairs by whether their common lattice defines the same link allows different estimates. Different-link pairs contribute at most `b^(−kf)` times the identity second moment. For equal links an additional saving comes from the product of norms of the places where the blocks meet. On open reductions a Siegel-type estimate bounds the squared class sums by finite-place densities. A finite sieve then bounds those densities. [Remaining pairs](https://eric-vergo.github.io/grh-lean/source/New.Spanning.RemainingTerms.Sum.html) and [main-term estimate](https://eric-vergo.github.io/grh-lean/source/New.Spanning.MainTerm.EnergyEstimate.html).

:::theorem "grh-guide-moments" (lean := "New.Filling.HasAmplitudeBlocks.hilbertSchmidtNorm_sub_one_sq_le, New.Filling.HasAmplitudeBlocks.sum_hilbertSchmidtNorm_sq_le, New.isSpread_of_second_moment")
For a map with the prescribed blocks and filling hypotheses, the squared Hilbert–Schmidt distance of its identity overlap from the identity is at most `b⁻¹²` times the source dimension. The full sum of squared overlaps is at most `(1 + 9 b⁻⁴)` times the model main second moment. The finite-dimensional spreading lemma uses the moment and near-isometry hypotheses to select a translate.
:::

The model main moment is the squared source dimension divided by the product of a Bessel degree and a mass. Counting the target on the definite companion relates that product to target dimension. The finite-group projectors are indexed by tuples of polynomials at the two level primes. Counting rare bad polynomials bounds the coefficient at the identity lost to the complementary projectors. This converts the moment of the unprojected map into a lower mean-square estimate on the good target. [Moment calculations](https://eric-vergo.github.io/grh-lean/source/New.Spanning.Unfolding.Moments.html) and [bad types](https://eric-vergo.github.io/grh-lean/source/New.Spanning.MainTerm.BadTypes.html).

:::theorem "grh-guide-spanning" (lean := "New.Data.enough_forms") (uses := "grh-guide-moments")
Write $`d` for target dimension and $`h` for ramified source dimension. The target has positive dimension. There is a finite set of translates of cardinality $`u` such that `u h ≤ 5 d log(1 + 2 b²)` and the sum of their image spaces has dimension at least `(1 − 4/b²) d`.
:::

Restrict each translate to the spanning family of Theorem A and choose an independent subfamily of the joint image. Its cardinality meets the threshold for Theorem C. The bound on `u h` controls the index budget even if one image overlaps many others.
