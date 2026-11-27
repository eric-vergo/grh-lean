/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import New.Reduction.ShortAndEnough
import Lib.GLn.Branching.IntegralMap
import New.Derivatives.Divisibility.Count
import New.Derivatives.Sharpness.BoundAttained
import New.Derivatives.Vacuum.TightFrames
import New.UpperBound.Divisibility.LocalDivisibility
import New.UpperBound.Divisibility.MarkOperator
import New.UpperBound.Divisibility.ValuationAtLevel
import New.UpperBound.ElementaryDivisors.AveragingMap
import New.UpperBound.ElementaryDivisors.DefectCount
import New.UpperBound.ElementaryDivisors.RootLemma
import New.UpperBound.Kernels.JetConjugatesAndBounds
import New.UpperBound.Seesaw.GluedLevel
import New.UpperBound.Size.Estimates

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem A. Short lifts and their denominators" =>

%%%
htmlSplit := .never
tag := "guide-shortforms"
%%%

A short lift has small squared norm at every complex conjugate. An integral source form satisfies the local gauge bound at every finite place. Both conditions matter because dividing by a large integer improves the complex estimate while risking large denominators.

For example, differentiating the monomial of degree four four times gives 24 at zero. Two of the factors in 4! are divisible by 2 and one is divisible by 4, giving three powers of 2. A derivative in several variables introduces such counts together with a cost for substituting linear forms. The difference determines how much one can divide out without destroying integrality.

# Counting prime powers inside a theta jet

A jet evaluates a polynomial differential operator on a theta function at zero. The operators are organized by products of minors. After a linear substitution the relevant coefficients are integral in the required degree. Factorial valuations then give a lower bound for the prime divisibility of the jet. The chain rule charges back the valuation of the substitution. The shape of the minors specifies how many times this happens. At marked places the count omits certain height-one columns and uses additional row divisibility to pay for them. Thus the estimate can be summed across primes even though the sharp local count varies by place. [Formal divisibility count](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Derivatives/Divisibility/Count.lean).

## What a derivative counts

:::lemma_ "grh-ab-5" (lean := "New.Parameters.norm_jet_minorProd_le_of_hasNormalForm")
For a nonsplit prime, the normal form gives a lower bound on the valuation of every jet taken along the prescribed product of minors. Its leading term depends on the column heights at each embedding and at its Frobenius partner; the error grows only logarithmically in the number of boxes below full height.
:::

:::proof "grh-ab-5"
Expand the differential operator into monomials. Evaluating a monomial derivative at zero multiplies the matching Taylor coefficient by the product of its factorials. At depth e, count the multiples of the e-th power of the prime in those factorials. The normal form permits integral substitutions together with terms whose degree at one embedding is charged to its partner. A column determinant restricts the possible exponents in each monomial. The excess that the partner cannot absorb contributes positively at that depth. Add the depth bounds and use the nonarchimedean triangle inequality when the monomials are added back. Taking all column charges equal to one recovers the unmarked count.
:::

## The root subgroup detects excessive defect

The depth and defect are weighted sums of the exponents of a monomial. The defect weights measure the imbalance between designated blocks. A parahoric here is the subgroup preserving a flag after reduction modulo the maximal ideal.

:::lemma_ "grh-ab-15" (lean := "New.FrobeniusCycle.mem_gaussFiltration_sub_defect_div_three")
If every rank-two root-group translate satisfies the lower bound on order plus depth, then a coefficient with positive defect must satisfy a stronger bound, gaining one third of its defect.
:::

:::proof "grh-ab-15"
Vary a root-subgroup parameter, so coefficients become polynomials on the residue field. Stepanov's count bounds how many high-order zeros a nonzero polynomial of the allowed degree can have. Applied to the extremal terms after merging exponents, it forces nonpositive defect for an offending least term. To use this, order terms by valuation plus depth minus one third of defect. A counterexample has a least term in a translate; nonpositive defect there would already violate the original depth bound. Thus the changed weights define a valid filtration on all the translates.
:::

## Simultaneously removing high-defect coefficients

:::lemma_ "grh-ab-16" (lean := "New.FrobeniusCycle.exists_average_mem_defectConditions_and_dvd_sub")
There is one averaging operator whose output has divisible high-defect coefficients in every block-diagonal translate. Its pairing with an admissible test vector agrees, modulo the prescribed power, with a fixed multiple of the original pairing.
:::

:::proof "grh-ab-16" (uses := "grh-ab-15")
Build partial averages indexed by subsets of the tensor copies. Inserting a new copy changes the pairing by a multiple of the required power: the contraction against the other copies and the root-subgroup bound control the coefficients that could survive. The degree restriction guarantees enough evaluations over the residue field for the averages. Telescope these differences from the empty subset to all copies. The first pairing is the explicit scalar multiple and the last average satisfies the defect condition uniformly under the Levi subgroup.
:::

## Counting the surviving polynomial space

:::lemma_ "grh-ab-17" (lean := "New.FrobeniusCycle.index_mul_finrank_defectConditions_le")
For small allowed defect relative to degree, the parahoric index times the dimension of the bounded-defect space is at most one plus the specified relative error times the full monomial count.
:::

:::proof "grh-ab-17"
Use a leading monomial after translating the flag. Its exponent lies in a cone cut out by the defect inequalities and in a slab cut out by the degrees. Bound the number of distinct leading exponents using the volume of a slightly enlarged slab. The cone occupies only a share of that slab; counting translates of flags cancels the parahoric and Levi indices against this share. The enlargement costs an exponential in the ratio of boundary width to degree. The assumed bound on that ratio converts the exponential into the advertised relative error.
:::

## The elementary divisors at a marked place

:::lemma_ "grh-ab-11" (lean := "New.Data.IsMarked.isOntoUpToColength_scaledHeckeOperator")
After multiplication by its prescribed prime power, a marked Hecke operator preserves the integral source lattice. Its failure to cover that lattice to a specified depth has bounded colength.
:::

:::proof "grh-ab-11" (uses := "grh-ab-15, grh-ab-16, grh-ab-17")
Group the embeddings inducing the marked place or its conjugate into a Frobenius orbit. This gives the letter cycle for the polynomial representation of the local Hecke operator, with the scaling exponent determined by how many marked embeddings lie above the place. Apply the elementary-divisor bound for that cycle to the reduction of the operator. The dimension estimate for the exceptional polynomial space controls the number of elementary divisors above each depth. Summing those counts over the depths yields the colength estimate.
:::

# Building a theta vector with integral values

A tight frame reconstructs a vector from its inner products with the frame elements, up to a fixed scalar. Powers of a primitive root of unity supply such a frame in the chosen CM lattice. Pull back one-variable theta sections along the corresponding linear forms and take their product. The result is the theta function of a finite adelic vector whose values are integral. Normalizing the Taylor variables by the CM period makes its derivative bounds comparable at complex and finite places. The integral vacuum is a particular such vector. Translating it by the finite Heisenberg and Weil actions yields the modules of standard data. [Tight frames](/source/New.Derivatives.Vacuum.TightFrames.html) and [integral vacuum](/source/New.Derivatives.Vacuum.IntegralVacuum.html).

## A tight frame constructs an integral theta vector

:::lemma_ "grh-ab-6" (lean := "New.Parameters.exists_isResolutionProduct_of_isTightFrame")
A tight frame and a compatible CM lattice realize a product of one-variable theta sections as the theta function of a finite vector with integral values. The resulting theta function satisfies the prescribed signed translation law.
:::

:::proof "grh-ab-6"
Pull each section back along its frame linear form and multiply. The tight-frame identity says that the sum of the pulled-back Hermitian forms has the required scale; the area of the one-variable lattice fixes the constant. The linear forms carry the period lattice to periods, so the product has the prescribed translation law. Fourier inversion on the finite quotient reconstructs its vector. The inversion formula here expresses its entries through integral torsion values. The lattice translations of the reconstructed vector have the sign prescribed by the theta transformation law.
:::

## A reverse bound for a local coefficient

:::lemma_ "grh-ab-7" (lean := "New.Data.exists_rpow_neg_localPrimeSumTotal_le_norm_coeff")
In the specified window of degrees there is a single nonzero normalization, small at every complex conjugate, such that at each finite place some coefficient of a residue-class indicator datum has valuation at most the predicted gain plus the valuation of that normalization.
:::

:::proof "grh-ab-7" (uses := "grh-ab-6")
Choose a tight frame with sufficiently repeated vectors and with a unit linear form available at every prime. Copies of a theta function with a chosen coefficient are inserted into a product; separating the variables prevents other choices from cancelling that coefficient. Express the resulting finite vector in the basis of residue-class indicators. An ultrametric sum can have large norm only if one of its summands does. Extract that indicator and compare its scaled Taylor coefficient, keeping the factorials, the nonzero vacuum value and the frame denominators in the common normalization. The successful indicator can depend on the finite place.
:::

## Bounding every conjugate of a Schur jet

:::lemma_ "grh-ab-8" (lean := "New.Parameters.sqrt_weylNormSq_schurJet_le_of_isVacuumCombination")
A finite combination of vacuum translates with bounded sums of absolute coefficients at every conjugate has a uniform archimedean bound for the Weyl norm of its Schur jet.
:::

:::proof "grh-ab-8"
Pair the jet with a covector of norm at most one. Its matrix coefficient is now an ordinary polynomial differential operator. The conjugation law for the normalized theta vector identifies the conjugate jet with an operator on the conjugate datum, so one estimates actual translated vacua. The growth bound for the Schur coefficient polynomial and the scalar jet estimate apply term by term. Sum with the absolute coefficients, then take the supremum over the unit covectors to recover the original norm.
:::

## Branching with an integral matrix of controlled norm

:::lemma_ "grh-ab-71" (lean := "New.exists_branching_matrix")
For the prescribed pair of interlacing diagrams there is an integral branching matrix. It intertwines the block action with the required determinant twist, obeys an explicit squared norm bound and spans the complex equivariant maps.
:::

:::proof "grh-ab-71"
Separate columns that lose a box on restriction from those that keep one. The latter columns of full height contribute determinant factors. Construct the branching polynomial with those minors and clear the denominator of its Weyl-kernel realization, keeping the bound on the multiple used. Evaluating gives an integral matrix with the required transformation law. For uniqueness, scale this matrix to match any other equivariant map on one highest-weight coefficient. Their difference vanishes there; cyclicity under the triangular group and equivariance then force it to vanish everywhere.
:::

## The integral vacuum and its charged jets

:::theorem "grh-guide-vacuum" (lean := "New.Parameters.norm_intVacuum_le_one, New.Parameters.norm_schurJet_jetSeries_le_of_charges")
The values of the normalized vacuum at the specified finite vectors satisfy the integral norm bound. For standard data the charged Schur-jet estimate converts the shape calculation into a valuation bound for the derivatives used by the chain.
:::

:::proof "grh-guide-vacuum" (uses := "grh-ab-5, grh-ab-6")
The tight frame realizes the vacuum as a product of one-variable theta sections. Their integral Fourier coefficients survive translation in the prescribed finite module. For a jet, write its differential operator as a sum of products of minors, apply the prime-power count to each term, and use the ultrametric triangle inequality. The recorded charges subtract the powers consumed by changing variables.
:::

At a given prime this estimate can require passing to a submodule of the integral ramified source. The local theorem records both the power of the prime that bounds its colength and the gain on that submodule. Its quantifiers fix the submodule before the prime-to-that-prime twist and its chain datum vary. Thus it can supply one index estimate across those choices. [Local theorem](/source/New.UpperBound.Divisibility.LocalDivisibility.html).

# Normalizing the Poincaré map

Expand a composite chain on the definite side in translates of the integral vacuum, the basic theta vector. Bounds for its derivatives give the complex size and the local divisibility estimates for this same chain. The seesaw transfers them to the target side up to a common nonzero scalar. The normalization removes this scalar, applies the good projection with a group-order factor to control its denominators, and divides by powers of primes. At each prime the exponent is the floor of the predicted gain less its allowed error. The sum of local errors, weighted by logarithms of primes, costs at most `errorUnit = f a (log b)³`. At primes different from the level prime the error vanishes if the prime splits in the quadratic field or lies beyond the second cutoff.

## Which translations preserve the glued level?

:::lemma_ "grh-ab-9" (lean := "New.Grading.inclXFin_mem_levelOf")
The congruence conditions on the smaller unitary group suffice to put its embedded element in the level of the glued lattice, with the required reductions at the auxiliary places.
:::

:::proof "grh-ab-9"
Write the difference of the embedded element from the identity in a frame adapted to the glued lattice. The problematic column of the basis change has a uniformizer in its denominator. The congruence on the last row supplies the factor needed to cancel it; the unitary relation controls the conjugate column. The remaining basis changes have integral entries and hence preserve the entrywise congruences under multiplication. At the auxiliary places the gluing parameter is a unit, so reading the reduction in this frame gives the stated level condition.
:::

## The level prime in the composite lift

:::lemma_ "grh-ab-12" (lean := "New.Data.gaugeLe_compositeLift_at_N")
At the distinguished level prime, a ramified source form satisfying the up-integrality condition has composite lift of gauge at most $`N^{2 m f b}` at the identity, uniformly in the permitted twists and chain data.
:::

:::proof "grh-ab-12"
Two consecutive glued lifts can be rewritten as direct lifts after changing the source and extracting an explicit scalar. Repeat this through the chain and keep the scalar at each stage. At the level prime one direct step loses at most the number of infinite places times the weight in the valuation estimate. Add these losses over the chain. The estimate is initially made at a diagonal lattice representative; translating back to the restriction point cancels the denominator built into the restriction.
:::

## Why summing the prime losses is affordable

:::lemma_ "grh-ab-14" (lean := "New.Data.sum_allowedLoss_mul_log_le")
For every finite set of natural indices, only exceptional primes contribute to the sum of allowed losses weighted by logarithms. The sum is bounded by the prescribed error unit.
:::

:::proof "grh-ab-14"
Assign an exceptional prime to a positive integer c at most the second cutoff. For each c there are at most four possibilities: the distinguished level prime, c itself, and the two integers one away from m times c. The individual logarithmically weighted bound is at most a common constant divided by c. Summation now costs at most four copies of a harmonic sum. The size inequalities on the parameters absorb its logarithm into the error unit.
:::

## One exceptional submodule works for every twist of level prime to p

:::lemma_ "grh-ab-13" (lean := "New.Data.exists_err_gaugeLe_compositeLift")
For each prime and each embedding into its completed algebraic closure, there is a submodule of the integral ramified source on which all composite lifts for admissible twists of level prime to that prime satisfy the local gauge estimate. The logarithmically weighted sum of the local errors is at most the error budget.
:::

:::proof "grh-ab-13" (uses := "grh-ab-5, grh-ab-11, grh-ab-12, grh-ab-14")
At small nonsplit primes use the product of scaled Hecke operators to move to forms satisfying the full marked jet estimate. Restrict to their controlled image and pay its colength once, before choosing a twist. At the level prime use the direct-lift calculation. At the other primes the integral datum already satisfies the required bound. Choose the explicit allowed loss as the error function; it vanishes at split primes and beyond the second cutoff away from the level prime. Summing the allowed losses gives the global budget.
:::

## Transposing the theta lifts

:::theorem "grh-guide-seesaw" (lean := "New.Data.seesaw_identity, New.Data.exists_err_gaugeLe_compositeLift") (uses := "grh-guide-vacuum")
Fix the real point and evaluation functional for the Poincaré map. There is a nonzero scalar common to the twists. For each twist there is a finitely supported chain datum for which the lower chain of every ramified source image equals that scalar times its composite lift. The local theorem bounds the gauge of these composite lifts after the controlled restriction of the integral source.
:::

:::proof "grh-guide-seesaw" (uses := "grh-ab-9")
Pair the lower chain against a test vector and move each theta kernel across the pairing in reverse order. Unfolding gives a weighted sum over finite classes together with the real evaluation integral. The translated finite data descend at the glued level, so that the expansion defines an admissible chain datum. The common nonzero proportionality factor comes from the real evaluation and the fixed measures. The finite translates and their coefficients may vary with the twist. This distinction permits one normalization for the entire family.
:::

To see why the same map appears on both sides, pair a lower-chain lift with a test form at its endpoint. Transpose the last lift across the pairing and unfold the resulting period. Its outer integral splits into a real integral and a weighted sum of finite classes. Repeating the operation exposes the whole upper-chain tensor. At the definite endpoint the remaining pairing is the inner product with the restricted form. This identity alone allows a zero image. The dimension estimate in Theorem B supplies the necessary nonvanishing in aggregate. [Seesaw unfolding](/source/New.UpperBound.Seesaw.SeesawIdentity.html).

## The short-vector and index bounds

:::theorem "grh-guide-short" (lean := "New.Data.span_short_integralRamified_eq_top, New.Data.indexLe_normalizedPoincare") (uses := "grh-guide-seesaw")
The ramified source is spanned over the complex numbers by integral forms whose normalized images, for every translate, have untwisted lifts of squared norm at every conjugate at most `exp(mainAmount − m totalRemainder + f a (log b)⁴)`. For images of integral forms from a finite set of translates, the index bound is twice the error unit times the number of translates times the dimension of the ramified source.
:::

:::proof "grh-guide-short" (uses := "grh-ab-8, grh-guide-seesaw, grh-ab-13, grh-ab-14")
Take the spanning family of integral ramified forms with the archimedean estimate. Apply the seesaw to its lifts and divide out the common scalar. The logarithm of the rational normalization subtracts the local gains from the archimedean cost. The floor errors and the cost of the good projector fit within the remaining logarithmic allowance. At a finite prime, restriction to the controlled submodule makes the normalized image integral. For a sum of images, take one copy of this restriction for each translate. Adding their logarithmic indices gives the asserted factor of the translate count times the source dimension.
:::

The index estimate charges each translate for at most one source dimension of denominators. This explains why the next step counts how many translates are used, as well as how many independent images they produce. [Assembly of the local and archimedean bounds](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/ShortAndEnough.lean).
