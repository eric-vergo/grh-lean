/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import New.Determinant.Twist.LongForms

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem C. The cost of a nearly full family" =>

%%%
tag := "guide-longforms"
%%%

The volume of a lifted basis is measured by its Gram determinant. For a linear map $`u`, this is `det(u* u)`, the square of the usual volume factor. A change of basis acts twice in this expression, which accounts for the coefficient two on the finite-place index.

# A different twist at each finite place

Let $`Z` be the Gram determinant of the chain on target forms. The complex norms in the final inequality are measured for the untwisted chain. At a finite place over a prime $`ℓ`, one may instead measure integrality after applying a character twist whose modulus is prime to $`ℓ`. To compare these different measurements one needs a height bound for `Z(1)/Z(ξᵢ)`, the ratio of the two determinants. A height bound controls a sum of logarithmic local contributions. Applying the number-field product formula to a basis Gram determinant is the step that joins the complex and finite estimates. Auxiliary forms complete a nearly full independent family to such a basis. The small codimension limits the total cost of those extra vectors. [Twisted lattice argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/Lattices/TwistedLattice.lean).

# Replacing a chain by single lifts

An exchange identity relates integrals for complementary ranks. Applied to a square of lifts and transposed lifts it moves one path of integration across that square, with a scalar involving partial Hecke L-values. Moving between the two extreme paths takes `m²` squares. Rallis norm identities relate the resulting operators to single-lift Gram determinants. Comparing the twisted and untwisted formulas removes common normalizations. Positivity and injectivity are needed before determinants can be divided. [Chain comparison and positivity](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Determinant/Chain/NormOfChain.lean).

For one lift, an auxiliary comparison operator is built from a gluing map and its adjoint. A frame decomposes the operator into rank-one terms, yielding an integrality estimate and a complex size estimate. Its image is orthogonal to the false lifts, forms which pass a local Hecke-polynomial test while lying in the orthogonal complement of the lifts. On projecting to the genuine lifts, a determinant identity relates the operator to the desired single-lift volume through Hecke values. The denominator of that projection must still be paid. [Single-lift estimate](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/OneLift/LiftVolumeHeight.lean).

# Paying for congruences

Congruences between eigensystems can make a projection onto just some eigensystems nonintegral. The first-order congruence argument bounds denominators using Galois extension classes. A Selmer group collects such classes subject to specified local conditions. At each prime a tame character is chosen so its first $`m` powers simultaneously control Selmer lengths and valuations of critical Hecke-value ratios. Applying the denominator bound and summing local losses gives a regular family of twists. Its bounds are precisely what the determinant comparison consumes. [Regular families](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Congruences/FitTwistsExist.lean).

:::theorem "grh-guide-twists" (lean := "New.exists_isRegularFamily, New.Data.exists_hasSmallRatios_heightLe_liftDeterminant_div, New.Data.heightLe_chainDeterminant_one_div")
For each admissible datum there is a regular family indexed by the prime and its chosen complex-to-adic identification. It supplies small inverse Hecke-value ratios and a bound for the heights of the single-lift determinant ratios. The chain comparison turns these into the height bound for the full determinant ratio.
:::

The intermediate projection bound is an operator statement. On the relevant space the operator preserves Hecke eigenspaces and its eigenvalues have bounded valuation. Applying it to the projection of an integral form orthogonal to the false lifts restores integrality. The bound on those valuations uses the lengths of the twisted Selmer groups. The twisting theorem chooses one character for the finite family of main summands and critical pairs at the given prime. Controlling its first powers together lets it serve all stages of one chain. [Denominator bound](https://eric-vergo.github.io/grh-lean/source/New.Congruences.FirstOrder.DenominatorBound.html) and [twisting theorem](https://eric-vergo.github.io/grh-lean/source/New.Congruences.Selmer.TwistingTheorem.html).

:::theorem "grh-guide-long" (lean := "New.Data.integral_forms_long") (uses := "grh-guide-twists")
For an independent family of at least `(1 − 4/b²) d` target vectors, let $`c` bound the logarithm of the untwisted lift’s squared Gram volume uniformly over every field automorphism of the complex numbers. Let $`δ` bound its index, with losses weighted by logarithms of primes. For each adic identification a single correcting matrix must give integrality across all allowed twists. Then `d (mainAmount − 3 f a (log b)⁴) ≤ c + 2δ`.
:::
