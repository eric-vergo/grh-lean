/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import New.Reduction.ShortAndEnough
import Lib.Adelic.AutomorphicForms.Cuspidality
import Lib.Adelic.Reduction.FiniteVolume
import Lib.Adelic.TraceFormula.LineStabiliser
import Lib.Adelic.TraceFormula.TraceComparison
import Lib.DiscreteSeries.Bessel.UnipotentHaarMeasure
import Lib.DiscreteSeries.Bruhat.FourierKernels
import Lib.DiscreteSeries.Bruhat.QuadricBlocks
import Lib.DiscreteSeries.Bruhat.SphereFibres
import Lib.DiscreteSeries.FlenstedJensen.PsiKTypes
import Lib.LocalGL.Iwahori.ParahoricStructure
import New.Appendix.DiscreteSeries.Localization
import New.Appendix.DiscreteSeries.Periods
import New.Spanning.Bessel.CutTailBound
import New.Spanning.Bessel.FillingData
import New.Spanning.MainTerm.BadTypes
import New.Spanning.MainTerm.EnergyEstimate
import New.Spanning.MainTerm.GlobalSieve
import New.Spanning.Multiplicities.EqualMultiplicities
import New.Spanning.RemainingTerms.Sum
import New.Spanning.SecondMoment.SpanningTheorem
import New.Spanning.Unfolding.Climbing

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem B. Filling the target by translates" =>

%%%
htmlSplit := .never
tag := "guide-spanning"
%%%

Even when individual vectors are very short, many of them can point in the same direction. The second moment measures the overlap between the image of the Poincaré map and its translates. Write $`B` for the scaled map. An overlap is measured by the squared Hilbert–Schmidt norm of `B* s B`, the sum of the squared absolute values of its matrix entries in orthonormal bases.

For example, take the inclusion of one coordinate line into a two-dimensional Hilbert space. Its overlap with itself is the one-by-one identity matrix. Its overlap after a swap of the coordinates is zero. The two translates together span the plane. The argument below replaces exact orthogonality in this example by a quantitative bound on the sum of squared overlaps.

# Turning moments into dimension

The calculation needs a lower bound for the projected map in mean square and an upper bound for the sum of the overlaps. For this family of spaces, multiplicity comparison counts the target on a definite group with free level. Unfolding the Poincaré series expresses its matrix coefficients through local integrals. The identity contribution supplies the main term. The estimates for the other terms and for the bad local types control the loss when the two level projectors are applied. These are the inputs to `isSpread_of_second_moment`. [Moment hypotheses and their application](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/SpanningTheorem.lean).

For a subspace already spanned, the moment inequality finds a translate whose preimage of that subspace is small. The rest of the translate contributes new dimensions. Repeating the selection reduces the missing dimension and incurs a logarithmic factor in the number of translates. [Finite-dimensional covering argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Spanning/SecondMoment/FewTranslates.lean).

## A translate escapes a given subspace

:::lemma_ "grh-ab-18" (lean := "New.Data.isSpread_goodPoincare")
For any subspace occupying a fraction α of the target, one projected translate has preimage dimension at most $`(1+α+3/(8b²))/2` times the source dimension.
:::

:::proof "grh-ab-18" (uses := "grh-guide-moments, grh-ab-19, grh-ab-27")
Scale the Poincaré map so that its identity overlap is close to the identity. The near-isometry estimate after the good projector controls the average squared mass that remains. The second-moment bound controls concentration of that mass, with target dimension compared to the definite mass. Apply the finite-dimensional spreading inequality with error parameter one eighth of the inverse square of b. Passing back through source coordinates and multiplying by nonzero normalization factors preserve the dimension of the preimage.
:::

# Moving the trace to a definite space

Changing the signature at infinity changes the realization of the forms, while the finite group, level and chosen parameter agree for the lower-chain starting space and the single-lift source spaces. Compare traces of spherical Hecke operators away from the level using a test function cuspidal at one split place. Trace equality for the good parts passes to characteristic polynomials, determinants and eigensystem multiplicities. Applied to dimension, this identifies the target count with a count on a definite space. Applied to the operators in the Rallis norm identity, it enters the chain determinant in Theorem C as well. [Equality of multiplicities](/source/New.Spanning.Multiplicities.EqualMultiplicities.html).

## Integrating the number of lattice points

:::lemma_ "grh-ab-59" (lean := "New.Space.lintegral_encard_ne_top")
On the adelic unitary quotient the count of rational n-by-t matrices in a translated compact window is integrable in the range twice t less than n. Taking no columns gives finite covolume.
:::

:::proof "grh-ab-59"
Choose a rational basis whose successive sizes give an integer profile. For each profile compare two counts: the number of matrices that fit in the window and the number of bases realizing the profile. The rank inequality makes their ratio decay after the possible Gram matrices have been counted. Unfold the basis count and sum over the profiles: the Gram factor cancels and the remaining bounds are products of convergent geometric series. With zero columns the unique matrix always lies in a window containing zero, so the integral counts the volume itself.
:::

## A finite set of evaluations determines a cusp form

:::lemma_ "grh-ab-58" (lean := "New.Space.finite_levelSpace")
Forms selected by a sufficiently decaying cusp kernel and fixed by an open finite level form a finite-dimensional complex space.
:::

:::proof "grh-ab-58"
Cuspidality removes the constant terms in the directions where the height can grow. The resulting decay bounds the value of a normalized form by a constant divided by height; hence a value larger than half its supremum must occur inside a bounded-height set. Reduction theory puts that set in rational translates of a compact set. The smoothing convolution gives a common modulus of continuity there. Choose finitely many sample points: a form vanishing at all of them has sup norm at most half its own bound and is zero. Evaluation therefore embeds the space into a finite-dimensional coordinate space.
:::

## Why a root off the unit circle contributes zero

:::lemma_ "grh-ab-62" (lean := "New.Space.orbitalIntegral_eq_zero")
With $`B ≥ 13n³`, for a rational element with irreducible characteristic polynomial, a root off the unit circle at a real place forces the cusp-kernel orbital integral to vanish.
:::

:::proof "grh-ab-62"
Diagonalize the element at that place and take H to be the logarithm of the norm of the corresponding row after applying a variable group element. Translation by the rational element adds the logarithm of the modulus of the eigenvalue. Its centralizer also translates H by constants. The growth estimate for H permits inserting this difference into the orbital integral; the two translated integrals cancel. Thus the integral multiplied by the logarithm is zero. The off-circle assumption makes this multiplier nonzero.
:::

## Comparing traces across signatures

:::lemma_ "grh-ab-61" (lean := "New.trace_comparison")
With the stated gap, level, field and finite test-function hypotheses, the finite Hecke operator has the same trace on the two spaces of forms whose groups differ at the real places.
:::

:::proof "grh-ab-61" (uses := "grh-ab-62")
Multiply each trace by the level volume and express it as a geometric sum indexed by characteristic polynomials. The split cuspidal test function restricts the contributing classes, while the second support condition controls their reduction. For a polynomial with a root off the unit circle the relevant orbital contribution vanishes. For the elliptic terms the matching calculation compares the finite orbital integrals and counts the possible real sign assignments with their multiplicities. Equality for each polynomial yields equality of the traces.
:::

## Two Hecke moves through a residue line

:::lemma_ "grh-ab-60" (lean := "New.lineRaise_lineLower")
On vectors fixed by the stabilizer of a residue line, lowering and then raising sends y to `q^(n−2) (y + (q^n − 1) e_sph y)`, where the spherical mean averages over the full integral group.
:::

:::proof "grh-ab-60"
Parametrize the outer cosets by covectors whose distinguished coordinate is one. For a covector ξ, the inner sum runs over residue vectors z satisfying ξ applied to z equals one. Group by the line of z. For a line distinct from the distinguished line the two linear constraints on ξ leave the same number of choices. The distinguished line contributes the extra identity term. The remaining sum over nonzero vectors is invariant under the full integral group, so it is the spherical mean with its multiplicity.
:::

## Twisted conjugacy in a pro-Iwahori double coset

:::lemma_ "grh-ab-73" (lean := "New.exists_inv_mul_mul_map_eq_diagGL_mul")
For a diagonal t with strictly ordered valuations, every element g in its pro-Iwahori double coset can be moved by twisted conjugacy to t times a diagonal element of the pro-Iwahori, under the stated hypotheses on the field endomorphism.
:::

:::proof "grh-ab-73"
Write K for the pro-Iwahori and conjugate K by the integer powers of t. For each finite range of powers, solve the successive congruences to choose k so that the residual matrix `t⁻¹ k⁻¹ g σ(k)` lies in all the conjugated groups in that range. Compactness of K supplies a cluster point. The conditions are closed, so its residual matrix lies in every conjugate. Strict separation of the valuations forces each off-diagonal entry to vanish for some sufficiently large positive or negative power. The zeroth condition leaves diagonal entries congruent to one, as required.
:::

## Counting the target on a definite companion

:::lemma_ "grh-ab-19" (lean := "New.Data.targetDim_eq_finrank_goodForms_spaceW, New.Data.finrank_goodForms_inf_eigenPart_eq")
The good forms on the definite companion at each stage $`1 ≤ j ≤ m` have the same dimension as the good forms at its initial target. The trace comparison also identifies the multiplicities of the selected eigensystems.
:::

:::proof "grh-ab-19" (uses := "grh-ab-61")
Insert the same finite level and type projectors on both sides of the signature comparison. Applying the trace identity to suitable Hecke operators compares traces on the projected spaces. For an eigensystem one can further isolate its generalized eigenspace in the finite-dimensional Hecke module. For the dimension used here, take the identity on the good part: its trace is exactly the dimension. The definite side admits a mass and class count, which makes the equality available in the overlap estimate.
:::

# What enters the second moment

Organize the matrix of each overlap by two source classes and an element of the residual level group. After unfolding, a block is a sum of amplitudes indexed by rational elements with the prescribed reduction. Squaring makes *pairs* of such terms appear. Sorting pairs by whether their common lattice defines the same link allows different estimates. Different-link pairs contribute at most `b^(−kf)` times the identity second moment. For equal links an additional saving comes from the product of norms of the places where the blocks meet. On open reductions a Siegel-type estimate bounds the squared class sums by finite-place densities. A finite sieve then bounds those densities. [Remaining pairs](/source/New.Spanning.RemainingTerms.Sum.html) and [main-term estimate](/source/New.Spanning.MainTerm.EnergyEstimate.html).

## Projecting the discrete-series coefficient onto its lowest compact type

:::lemma_ "grh-ab-70" (lean := "New.integral_conj_weightMinors_lowestKType_mul_dsCoeff")
Averaging the coefficient at x k b against the conjugate lowest-weight minor on the compact unitary subgroup gives the product of its values at x and b times the squared norm of that compact coefficient.
:::

:::proof "grh-ab-70"
Write the coefficient using the Flensted–Jensen integral of products of principal minors. Decompose the compact torus action into weights: integrating over a circle kills every nonconstant character. In the lowest weight only the matching term remains and the two compact integrations separate. This yields the product formula near the identity; analytic continuation along a path extends it to b. The compact norm factor is precisely the integral of the squared absolute value of the weight minor.
:::

## Moving the stationary region to the identity

:::lemma_ "grh-ab-56" (lean := "New.DiscreteSeries.IsLaplaceDatum.exists_laplaceIntegrand_eq_and_norm_subOnePair_le")
If the sum of squares of the two noncompact parts is at most r squared, with r at most one sixth, one can preserve the Laplace integrand while moving both group components to within four times r of the identity.
:::

:::proof "grh-ab-56"
On the zero-weight subspace the first component is nearly unitary. Factor that block into a unitary matrix times a positive matrix and translate by the inverse unitary factor in the common compact subgroup. Its weight is zero, so the integrand keeps its value. The noncompact parts keep their norms as well. The off-block rows and columns are already controlled; the trace relation between the two components bounds what remains of the second matrix. Both deviations are now small in the same coordinates.
:::

## A lower bound for an oscillatory period

:::lemma_ "grh-ab-57" (lean := "New.DiscreteSeries.IsLaplaceDatum.laplace_method")
For the stated proper map, measure and sufficiently separated weights, the volume of the prescribed ball is bounded by an explicit power of the size parameter times the absolute value of the period.
:::

:::proof "grh-ab-57" (uses := "grh-ab-56")
Near the identity the linear phase has been removed. The quadratic estimate puts the integrand in a cone about the positive real axis; on a small ball its norm is at least one quarter. Localization allows the same estimate along the compact directions. Outside this region the large parameter gap gives integrable decay. Cover a large ball by translates of a smaller one to compare their volumes. Integrate the cone inequality with the tail bound: cancellation cannot erase the contribution required by the volume comparison.
:::

## Integrating on the Bessel unipotent group

:::lemma_ "grh-ab-66" (lean := "New.RealPlace.isUnimodularHaar_besselHaar₀, New.sigmaFinite_G₁")
The free-coordinate measure of the Bessel unipotent subgroup is invariant on the left and right. The ambient real unitary group has a sigma-finite Haar measure for the subsequent integrations.
:::

:::proof "grh-ab-66"
Order the free entries by level. Multiplication changes an entry by a translation depending on earlier levels, so repeated integration against additive Haar measure leaves their product unchanged. The defining equations recover the other matrix entries and the normalizer preserves the subgroup; the coordinate measure therefore gives the required two-sided Haar measure. Compact bounds on coordinates provide measurable cutoffs. Sigma-finiteness for the ambient group permits the successive integrations in the Bessel averages.
:::

## Cutting off a Bessel coefficient

:::lemma_ "grh-ab-20" (lean := "New.exists_isCutPair_besselAverage")
A suitable real multiple of the Bessel average has unit square-integral norm and is fixed by convolution with the discrete-series projector. Its truncated companion is close in square-integral norm.
:::

:::proof "grh-ab-20" (uses := "grh-ab-57, grh-ab-66, grh-ab-70")
Average the discrete-series coefficient against the Bessel subgroup character. The period lower bound gives a positive lower bound for its square-integral norm, so normalization is legitimate. A decay majorant bounds the average by a negative power of the Bessel length. Outside the cutoff the length is large, and integrating this power bounds the lost tail even after normalization. Convolution fixes the uncut function by the projector identity. This retains an exact eigenfunction and a localized approximation for separate uses.
:::

## Filling data at every real place

:::lemma_ "grh-ab-21" (lean := "New.Data.isDiscreteSeriesBessel_filling_besselSystem")
The admissible arithmetic data produce a Bessel system at each infinite place with the required discrete-series parameter and compact weight.
:::

:::proof "grh-ab-21" (uses := "grh-ab-20")
Use a frame that identifies the local Hermitian form with its sign matrix. The parameter gap and the bounds on the ranks and weights allow the local construction of a Bessel average, including the period lower bound and tail estimate. The lowest compact type determines the representation in which its values lie. Install the resulting normalized function, its cut and its majorant as the components of the filling. Its convolution law then identifies the discrete-series kernel used at this real place.
:::

## Polar coordinates supply the complex block measure

:::lemma_ "grh-ab-69" (lean := "New.Floors.exists_isDisintegration_le_sphereDensity")
In complex dimension k at least two, volume disintegrates over squared radius into invariant measures on spheres. The mass that each conditional sphere measure assigns to the coordinate box of radius R is at most the sphere density evaluated at k times R squared.
:::

:::proof "grh-ab-69"
For squared radius r, average a point of norm square r over the unitary group and multiply by the radial density, proportional to r to the power k minus one. Use zero measure on negative radii. Polar integration gives back Lebesgue volume with exactly the normalization required by the skew-valued parameter. A vector in the box has squared norm at most k times R squared, and the density is increasing in this range. Bounding the portion of each sphere by its full mass proves the box estimate used for solved quadrics.
:::

## Solving the quadric in a block

:::lemma_ "grh-ab-67" (lean := "New.Floors.Place.IsDisintegration.isSolvedIn_quadricMeasure")
An identity block of a Hermitian form turns its quadric measure into ordinary volume in the complementary chart coordinates followed by a block-fibre measure. A uniform box bound on those fibres survives the change of coordinates.
:::

:::proof "grh-ab-67"
Split the form into the chosen identity block and its orthogonal complement. In the hyperbolic-plane chart the block variables can first be integrated freely while the other variables satisfy a smaller quadric equation. Disintegrate the block volume by its norm, then exchange the two integrations by Tonelli. Rejoin the complementary variables and the block by a coordinate permutation, which preserves product Haar measure. The conditional block measure is the original fibre measure up to the prescribed shift, so its box bound still applies.
:::

## A Fourier estimate between two quadric fibres

:::lemma_ "grh-ab-68" (lean := "New.Floors.Place.IsSolvedIn.fourierSqNormLe")
For measures solved in disjoint blocks, with the specified identity rows in the pairing, the squared norm of the character-kernel integral is bounded in terms of the two block masses, box volumes and the Fourier scale.
:::

:::proof "grh-ab-68"
Write each measure in solved coordinates. The two block variables do not interact in the phase, because the two blocks and the inner coordinates have disjoint indices. Factors of absolute value one can therefore be absorbed into the functions on which the operator acts. Apply Cauchy–Schwarz to each remaining block integral, paying its mass. In the inner coordinates the operator is an ordinary Fourier transform; Plancherel gives the square-integral bound there. Fubini accounts for the remaining outer-coordinate box volumes.
:::

## A shared vector determines a cell

:::lemma_ "grh-ab-22" (lean := "New.Filling.CharsAgree.exists_hasCellRank")
For a rational term with matching characters and vanishing frame discriminant, the two flags share compatible coordinates beyond a first index, and the corresponding leading frame-product minor is nonzero.
:::

:::proof "grh-ab-22"
Vanishing of the discriminant produces a nonzero vector in the intersection of the two frame spans. Character agreement allows one to climb through the flags: the first surviving coordinates on both sides must agree up to a scalar of norm one. Take the least index from which a common scalar and the required coordinate pattern persist. If the leading minor at that index vanished, the same argument would extend the pattern one step farther back, contradicting minimality. Thus the term belongs to a specified cell rather than an unrestricted pair of flags.
:::

## Poisson summation removes the head coordinates

:::lemma_ "grh-ab-25" (lean := "New.Filling.sieve")
The one-sided sieve bounds the coupled sum of products of the local forms on two heads by the product of their mass bounds plus a controlled frequency error.
:::

:::proof "grh-ab-25"
Remove one entry of the two heads at a time. A Poisson bound for that coordinate splits the estimate into a zero frequency, which integrates the local form and contributes its mass factor, and nonzero frequencies controlled by decay. The global weight bounds the sum over all possible earlier head entries, so this error remains summable at each removal. Iterate until the heads are empty. The product of the Poisson normalization constants accounts for all changes of measure.
:::

## Open reductions fixing prescribed vectors

:::lemma_ "grh-ab-26" (lean := "New.Filling.linkSecondMoment_isOpenElement_le")
The same-link second moment over open reductions fixing prescribed nonzero vectors gains a factor of b to the power minus six times the block rank for each selected place, up to the stated relative error.
:::

:::proof "grh-ab-26" (uses := "grh-ab-25")
First bound finite families of blocks. Each block consists of two classes, one reduction and one link; this data maps injectively into the tuples used in the class-sum estimate. Unfold the squared sums, retaining the local restrictions from each fixed vector. The sieve for the resulting system bounds its densities; the vector restrictions give multiplicative savings at their separate places. Restore the Gram factor and the square of the unipotent covolume, then take the supremum over finite families.
:::

## Separating pairs that belong to different links

:::lemma_ "grh-ab-24" (lean := "New.Filling.secondMoment_remainingTerms_le")
After the contributions inside a common link have been bounded, the remaining part of the squared amplitude sum is controlled by a small different-link error and that common-link bound.
:::

:::proof "grh-ab-24"
Expand each squared norm into pairs of rational terms with the same reduction. A link records how a term and its inverse act on the complementary orthogonal data. For terms in different link classes, bound each amplitude by its size and sum over the pairs; their lattice constraints give the saving in the size parameter. Each pair determines its reduction, so this bound is paid only once. Keep the terms with the same link together as a squared class sum, preserving their cancellation for the global sieve.
:::

## Counting the bad part of a type projector

:::lemma_ "grh-ab-27" (lean := "New.re_coeff_one_sub_sum_tupleIdem_le")
The real coefficient at the identity of the complement of the good-type projector is at most the sum of the loss from forbidden roots and the loss from having no primitive polynomial in the tuple.
:::

:::proof "grh-ab-27"
A label is allowed when it avoids the prescribed roots of unity. Count the excluded polynomials by fixing such a root and dividing by its linear factor. Among allowed tuples, discard those with no primitive factor: primitive elements of the extension field give a lower count for the primitive irreducible labels after division by orbit length. The coefficient of each tuple idempotent at the identity is a product of normalized squared character degrees. Sum those lower bounds over the good tuples and subtract from one. Independence in this count is the product over residue fields.
:::

## The identity block and the total overlap

:::theorem "grh-guide-moments" (lean := "New.Filling.HasAmplitudeBlocks.hilbertSchmidtNorm_sub_one_sq_le, New.Filling.HasAmplitudeBlocks.sum_hilbertSchmidtNorm_sq_le, New.isSpread_of_second_moment")
For a map with the prescribed blocks and filling hypotheses, the squared Hilbert–Schmidt distance of its identity overlap from the identity is at most `b⁻¹²` times the source dimension. The full sum of squared overlaps is at most `(1 + 9 b⁻⁴)` times the model main second moment. The finite-dimensional spreading lemma uses the moment and near-isometry hypotheses to select a translate.
:::

:::proof "grh-guide-moments" (uses := "grh-ab-21, grh-ab-22, grh-ab-24, grh-ab-26, grh-ab-27")
For each translate expand the overlap in its amplitude blocks. Squaring the Hilbert–Schmidt norm sums the absolute squares of the block entries, so each entry contributes pairs of rational terms. At the identity subtract the prescribed diagonal contribution before squaring. For the full sum isolate the model main term, apply the open-reduction estimate to the same-link mass and bound the remaining pairs separately. Adding the allowances yields the factor in the statement. The dimension argument uses this upper bound together with the lower mean square surviving projection to the good part.
:::

The model main moment is the squared source dimension divided by the product of a Bessel degree and a mass. Counting the target on the definite companion relates that product to target dimension. The finite-group projectors are indexed by tuples of polynomials at the two level primes. Counting rare bad polynomials bounds the coefficient at the identity lost to the complementary projectors. This converts the moment of the unprojected map into a lower mean-square estimate on the good target. [Moment calculations](/source/New.Spanning.Unfolding.Moments.html) and [bad types](/source/New.Spanning.MainTerm.BadTypes.html).

## How many translates fill the target?

:::theorem "grh-guide-spanning" (lean := "New.Data.enough_forms") (uses := "grh-guide-moments")
Write $`d` for target dimension and $`h` for ramified source dimension. The target has positive dimension. There is a finite set of translates of cardinality $`u` such that `u h ≤ 5 d log(1 + 2 b²)` and the sum of their image spaces has dimension at least `(1 − 4/b²) d`.
:::

:::proof "grh-guide-spanning" (uses := "grh-ab-18, grh-guide-moments, grh-ab-27")
Apply the translate-selection inequality with defect parameter 1/(8b²). Iterating in the orthogonal complement fills all but at most 2/b² of the target dimension, with the logarithmic bound on the number of chosen translates. Restricting to the ramified source can lose at most its codimension per translate. The source codimension bound and the cardinality estimate together cost at most another 2/b² of the target dimension. Scaling each map by a nonzero scalar preserves its image. The resulting translates give the asserted dimension for the normalized maps.
:::

Restrict each translate to the spanning family of Theorem A and choose an independent subfamily of the joint image. Its cardinality meets the threshold for Theorem C. The bound on `u h` controls the index budget even if one image overlaps many others.
