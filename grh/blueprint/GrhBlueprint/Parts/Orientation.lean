/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Lib.CM.FormalGroup.IntegralParameter
import Lib.General.Algebra.ResidueSums
import Lib.Shimura.ComplexTheta.DimensionFormula
import Lib.Weil.Construction.WeilOperators
import Lib.Weil.DualPair.KernelDecay
import Lib.Weil.Periods.Unfolding

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "From zeros to a comparison of volumes" =>

%%%
htmlSplit := .never
tag := "guide-orientation"
%%%

A Dirichlet character assigns periodic multiplicative weights to integers. Its L-function initially sums those weights divided by powers of the integers. The question concerns the zeros of its continuation. How can the lengths of vectors in an auxiliary space say anything about a zero? The link is a weighted count of prime powers. A hypothetical zero contributes a pole to a transform of the error in that count. The geometric argument limits how positive the error can be. The analytic argument shows that a zero strictly to the right of the critical line is incompatible with this limit.

# The arithmetic encoded in a derivative

Fix an auxiliary modulus divisible by 18480 and a prime in the prescribed residue class. Write the smoothing weight at an integer $`n` as `1/n − 1/x` for $`n` at most $`x`. Here and below the letters designate the quantities in the readable edition. Multiply this weight by the von Mangoldt weight (logarithm of the underlying prime at prime powers, zero otherwise), by `1 − χ_K(n)`, and by the indicator of the class 1 modulo the modulus. Removing an explicit logarithm and a constant gives the remainder. For an unramified inert prime the quadratic character on its odd powers is −1. The same distinction between splitting and inertia enters the divisibility of derivatives of theta functions. This is where a count of prime powers becomes visible inside an estimate of sizes.

# The two routes through the spaces

The data choose a CM field (a totally imaginary quadratic extension of a totally real field), weights at its infinite places and levels for the automorphic forms. The source consists of ramified forms on a definite unitary group of rank $`k`. A Poincaré series sends source forms to forms on a space of rank $`r`. A projection, denoted by `e₀`, keeps the good part at the level primes. Its image in the principal-level forms is the target. A chain of $`m` theta lifts then maps the target into forms of rank `r + mt`. On a second route a source form travels through definite spaces, with a final restriction to the space of that same rank. A seesaw identity relates these routes. It permits estimates on definite spaces to control lifts from the target.

Theorem A constructs integral generators whose normalized images have short lifts. Theorem B supplies enough independent images to approach the full target dimension. Theorem C limits how small the volume of so many lifted vectors can be if their finite-place denominators are controlled. Both estimates contain a large deterministic contribution. Subtraction leaves a multiple of the arithmetic remainder. The number of lifts lies between the square root of $`x` and twice that square root, producing the exponent needed in the analytic criterion.

# A dictionary for the comparison

* `q₀, d, K, E`. The fixed modulus and auxiliary prime determine the imaginary quadratic field `K = ℚ(√−d)`. Adjoining a root of unity of a data-dependent order gives the CM field `E`. Its number of infinite places is `f`.
* `x, x₁, b, a`. The prime remainder is evaluated at `x` and at a much larger cutoff `x₁`. The weight parameter `b` is larger still. In the readable edition `a = x b`. The sets `aPlaces` and `bPlaces` carry these two distinguished weights.
* `k, r, t, m`. The definite source has rank `k = r + 1 − m`, the initial target group rank `r`, and each step increases rank by `t = 5r`. The chain has `m` steps. These ranks belong to hermitian spaces. The dimension of the vector space of target forms is the separate quantity `targetDim`.

:::table +header
*
  * Map
  * Group ranks at the endpoints
  * Role in the proof
*
  * `X₀ → Xₘ → Yₘ`
  * `k → r + mt + 1 → r + mt`
  * Lift on definite spaces, then restrict. A chain datum specifies a finite combination of upper chains.
*
  * `X₀ → Y₀ → Yₘ`
  * `k → r → r + mt`
  * Form the Poincaré series. Translates of its good projection lie in the target, where the lower chain is `Θ ξ`.
*
  * `Wⱼ → Vⱼ`
  * `r → r + t`
  * Use the j-th power of the twist. The determinant factorization reduces a question about the whole chain to these individual lifts.
:::

[Field and rank data](/source/New.Reduction.Data.AdmissibleData.html), [lower chain](/source/New.UpperBound.Objects.RowChain.html), and [single-lift determinants](/source/New.Determinant.Chain.NormOfChain.html).

# Local calculations behind the two routes

The two routes use the same theta kernel. Three questions arise before one can integrate it. Do the operators compose as the group elements do? Does the integral converge when the group quotient is noncompact? Which terms of the kernel remain after taking the period, an integral weighted by a prescribed character or coefficient? The following results address those questions in order.

:::theorem "grh-weil-product" (lean := "New.Heisenberg.IsVacuum.weilOp_mul")
For a normalized multiplier action the product of the operators at $`g,h` is the operator at $`gh` times a scalar $`c(g,h)`. Normalization here means $`c(g,1)=1` for every $`g`.
:::

:::proof "grh-weil-product"
Compose the two operators with the operator at the inverse of $`gh`. The integral identity for three vacuum functions makes this triple product scalar. Apply the same identity with the identity element to obtain the inverse relation, then multiply back to get the displayed law. Constructing a genuine representation also requires showing that the scalar is one. The product calculation supplies the multiplicativity field when the proof constructs the group representation `weilRep`. That representation acts on the kernel in the two routes. The local calculations use a Gaussian determinant at real places, positivity at split places and a Gauss sum at inert places. [Operator product and local inputs](/source/Lib.Weil.Construction.WeilOperators.html).
:::

:::theorem "grh-kernel-decay" (lean := "New.pairTheta_decay_of_onto, New.pairTheta_decay_of_injective")
A full-rank support condition at the chosen finite places gives rapid decay in one group variable. In the onto case, multiplying the kernel by any chosen natural power of the target height leaves a bound by a constant, a finite moment of the archimedean vector, and a fixed power of the source height. The injective case interchanges the roles.
:::

:::proof "grh-kernel-decay"
Choose a short isotropic vector on the side whose height is large, and a short basis on the other side. Together they give rank-one directions in the matrix space. Translation invariance along these directions would force a contribution of insufficient rank on the support. The support hypothesis excludes this possibility. The quantitative estimate for the remaining terms trades moments of the vector at infinity for the desired power of decay. The other height is still present in the bound, a distinction that matters when integrating. In the construction of theta integrals the onto estimate at exponent zero gives boundedness on the target side for the chosen local datum. [Bounded target data](/source/Lib.Weil.DualPair.ThetaIntegrals.html). [Short pairs and the two height estimates](/source/Lib.Weil.DualPair.KernelDecay.html).
:::

:::theorem "grh-unfold-step" (lean := "New.Grading.hasSum_unfoldStep")
For the adjacent gradings and an equivariant coefficient function, the period of the theta kernel at a fixed group element is a convergent sum of translates of one unfolded function. Its index set is the rational group modulo the rational Bessel subgroup.
:::

:::proof "grh-unfold-step"
Expand the kernel into classes of rational maps and integrate each class against the coefficient function. For a class that fails the required compatibility, translation preserves the integral but multiplies its value by a nontrivial character. Its contribution therefore vanishes. The surviving classes are translates of those agreeing with the prescribed map between the two strings of the grading. Group these translates by the stabilizer of that map. Each resulting coset contributes exactly one evaluation of the unfolded function. Absolute summability justifies the regrouping. The integrated version is used at each unfolding stage of the seesaw in [Theorem A](/Theorem-A___-Short-lifts-and-their-denominators/), moving from one Bessel subgroup to the next. [Use in the upper chain](/source/New.UpperBound.Seesaw.UnfoldingStages.html). [Class sums and unfolding](/source/Lib.Weil.Periods.Unfolding.html).
:::

# Three finite calculations used along the way

:::theorem "grh-integral-parameter" (lean := "New.CMLattice.taylorVia_translatedX_mem_integralSeriesRing")
On the CM curve, the translated coordinate $`x` has a power series in the translated coordinate $`y` whose coefficients lie in the valuation ring. The coefficient ring consists of the elements of $`\mathbb{C}_p` of absolute value at most one, where $`\mathbb{C}_p` is the completed algebraic closure of the p-adic field.
:::

:::proof "grh-integral-parameter"
Regard the curve equation as a cubic in an unknown $`U` with parameter $`T`. It reads $`U^3+(1-a_1T)U-T^2=0`. At $`T=0` the root zero has derivative one. Because $`a_1` is integral, Hensel lifting gives a unique formal root through zero with integral coefficients. Substitution of $`y` is legitimate since its constant term is zero. The resulting series and the geometric coordinate $`x` solve the same cubic through the same simple root, so they agree. In [Theorem A](/Theorem-A___-Short-lifts-and-their-denominators/) the jet-integrality proof expresses the scaled second derivative of the negative logarithm of theta as an integral constant plus a multiple of this coordinate. Both summands now lie in the same integral series ring. [Use in the jet calculation](/source/New.Derivatives.Vacuum.JetIntegrality.html). [Integral series of the CM curve](/source/Lib.CM.FormalGroup.IntegralParameter.html).
:::

:::theorem "grh-theta-dimension" (lean := "New.IsAppellHumbert.finrank_sq_eq_relIndex, New.IsAppellHumbert.thetaSpace_le_of_thetaShift_mem")
For positive Appell–Humbert data, the dimension of the theta space is positive and its square is the index of the lattice inside its dual lattice. The twisted lattice translations of any nonzero theta function span the theta space.
:::

:::proof "grh-theta-dimension"
A translation in the dual lattice preserves the theta transformation law after multiplication by the prescribed factor. Representatives modulo the original lattice give independent operators and span the algebra of all endomorphisms. Counting these representatives gives the dimension of that algebra, which is the square of the dimension of the space. For irreducibility, take any nonzero vector $`f` and a linear functional taking value one on it. Multiplying that functional by any target vector gives an endomorphism carrying $`f` to the target. Since translations span the endomorphisms, their images of $`f` span all targets. For the unimodular real lattice in the Weil construction the relative index equals one. The dimension formula then makes the space of theta functions with the specified multiplier one-dimensional. [Use for the real lattice](/source/Lib.Weil.Construction.ThetaDictionary.html). [Theta shifts and the dimension formula](/source/Lib.Shimura.ComplexTheta.DimensionFormula.html).
:::

:::theorem "grh-interpolation" (lean := "New.DiscreteSeries.sum_eval_div_eval_derivative_nodal")
At $`M` distinct real nodes let $`P` be their monic nodal polynomial. For monic $`F` of degree less than $`M`, the sum of $`F(x_i)/P'(x_i)` is one when the degree is $`M-1` and zero when it is smaller.
:::

:::proof "grh-interpolation"
Lagrange interpolation expresses the polynomial as a sum with numerators obtained by deleting one linear factor from the nodal polynomial. Every such numerator is monic of degree one less than the number of nodes. Reading off that coefficient in the interpolation formula gives the claimed sum. These quotients are also the residues of the rational function at its simple poles, so the coefficient computation evaluates all those residues together. In the discrete-series calculation of stationary position this gives the pairings of polynomial vectors for an alternating bilinear form. Below the top degree each pairing vanishes, and at the top degree only the explicit sign remains. [Use in the stationary-position calculation](/source/New.Appendix.DiscreteSeries.StationaryPosition.html). [Residue sums in the discrete-series calculations](/source/Lib.General.Algebra.ResidueSums.html).
:::

# What the text checks

The Lean declarations attached to theorem panels are the formal statements. The surrounding explanations, including the interpretation of their mathematics, are editorial prose by Eric Vergo and OpenAI Codex. The upstream project credits the original proof to Levent Alpöge with Claude. Luke Sernau describes the shorter rewriting as a collaboration with his Anthropic colleagues and Claude. The edition README credits Claude with writing its Lean text and documents. The upstream notice credits Anthropic, PBC and identifies adaptations from Mathlib. The upstream README reports machine checks and says that no mathematician has read the proof through. [Upstream account](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/README.md) and [edition credits](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/README.md).
