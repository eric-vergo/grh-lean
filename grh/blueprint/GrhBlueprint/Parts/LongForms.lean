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
htmlSplit := .never
%%%

The volume of a lifted basis is measured by its Gram determinant. For a linear map $`u`, this is `det(u* u)`, the square of the usual volume factor. A change of basis acts twice in this expression, which accounts for the coefficient two on the finite-place index.

Theorem C asks what an independent family must cost if it occupies nearly the whole target. There are two ways to record that cost. At infinity we can measure the size of its untwisted lift. At a finite prime we can measure how much of a change of basis is needed before the lifted vectors become integral. A very small complex determinant can coexist with integrality at many primes, but the product formula requires compensation somewhere. To use that fact we must complete the given family to a basis and know that its Gram determinant is nonzero.

The difficulty is that the convenient lift at a finite prime is often a twist of the one measured at infinity. We first formulate the lattice inequality with an allowance for changing the determinant. We then exchange adjacent theta lifts until that allowance is expressed in terms of individual lifts and explicit Hecke values. Projecting onto genuine lifts introduces denominators when different eigensystems are congruent. Selmer groups measure the resulting obstruction. The last part chooses a twist separately at each prime that controls all the stages at once and inserts its total cost into the lattice inequality.

# A different twist at each finite place

Let $`Z` be the Gram determinant of the chain on target forms. The complex norms in the final inequality are measured for the untwisted chain. At a finite place over a prime $`\ell `, one may instead measure integrality after applying a character twist whose modulus is prime to $`\ell `. To compare these different measurements one needs a height bound for `Z(1)/Z(ξᵢ)`, the ratio of the two determinants. A height bound controls a sum of logarithmic local contributions. Applying the number-field product formula to a basis Gram determinant is the step that joins the complex and finite estimates. Auxiliary forms complete a nearly full independent family to such a basis. The small codimension limits the total cost of those extra vectors. [Twisted lattice argument](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/Lattices/TwistedLattice.lean).


## The product formula for the completed basis

:::theorem "grh-c-product-formula" (lean := "New.HeightLe.neg_le_of_norm_map_le")
Suppose a nonzero scalar has constant finite-place family of height at most $`h`, and every complex conjugate has norm at most $`\exp (c)`. Then $`-h \le  c`.
:::

:::proof "grh-c-product-formula"
Take the inverse of the constant family. The bound on all complex conjugates supplies a height bound for the constant family of inverses. Multiplying the inverse by the original scalar gives the constant family one. Applying the number-field product formula to the algebraic multiplier witnessing its height shows that the bound must be nonnegative, giving $`0 \le  h+c`. For a rational prime $`p`, the contribution $`\log  p` at infinity and the contribution $`-\log  p` at $`p` illustrate the cancellation behind this argument.
:::

:::theorem "grh-c-twisted-lattice" (lean := "New.TwistedLattice.covolume_add_index_nonneg") (uses := "grh-c-product-formula")
Complete an independent family to a basis. Suppose its twisted images satisfy the common integral correction condition, the lifts are injective, and the auxiliary vectors have bounded size. Let $`c` bound the logarithm of the untwisted squared covolume of the original family at every complex conjugate. Let $`\delta` bound its finite index, using logarithmic prime weights. Write $`N` for the number of auxiliary vectors, $`S` for their squared-norm bound in logarithms, $`H` for their scalar denominator budget and $`V` for the height bound on the determinant ratio. Then $`0 \le c + 2\delta + N(S+H) + V`.
:::

:::proof "grh-c-twisted-lattice"
Write the Gram determinant after the change of basis by the correcting matrix. The matrix acts on both arguments of the pairing, so the determinant gains the square of its absolute determinant. This gives a finite height bound with cost $`2\delta `. Multiply the height bounds for the determinant ratio and the normalizing scalar to recover a bound for the untwisted basis Gram determinant. Injectivity makes that scalar nonzero. At infinity every auxiliary vector contributes its short-vector bound, so the preceding product-formula inequality applies to the completed basis.
:::

# Replacing a chain by single lifts

An exchange identity relates integrals for complementary ranks. Applied to a square of lifts and transposed lifts it moves one path of integration across that square, with a scalar involving partial Hecke L-values. Moving between the two extreme paths takes `m²` squares. Rallis norm identities relate the resulting operators to single-lift Gram determinants. Comparing the twisted and untwisted formulas removes common normalizations. Positivity and injectivity are needed before determinants can be divided. [Chain comparison and positivity](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Determinant/Chain/NormOfChain.lean).

## Doubling and the norm of a theta lift

The analytic starting point is a pairing of lifts. Opening it up gives a group integral. Choosing its finite test data carefully makes that integral into a discrete operator whose injectivity can be tested on the input.

:::theorem "grh-c-doubling" (lean := "New.SiegelWeil.inner_product_formula")
In the range where the target rank exceeds twice the source rank, the Petersson pairing of two theta lifts has an integral expression involving the Weil matrix coefficient and a right translation of the input forms. One datum must be clean and the forms rapidly decreasing.
:::

:::proof "grh-c-doubling"
Expand the two lifts in the Petersson integral. The doubling identity for the product of kernels expresses the inner target integral as the target quotient volume times a sum over rational source points. Absolute integrability permits interchange of the integrations. Unfold that sum against a source fundamental domain. The variable left over is the group element translating one source form, which gives precisely the matrix-coefficient integral.
:::

:::theorem "grh-c-sharp-norm" (lean := "New.SiegelWeil.exists_petersson_formLift_eq_rallisSeries") (uses := "grh-c-doubling")
For a sharp finite datum and a real edge vector in the same rank range, the norm formula becomes a Petersson pairing against a Rallis series. Its nonzero real-data constant can be chosen before the finite datum.
:::

:::proof "grh-c-sharp-norm"
Evaluate the finite matrix coefficient by separating the sharp mass from the unramified double cosets. Summing the remaining translations gives the Rallis series of the input. The archimedean edge condition gives a common scalar on the specified type. Test the identity against the series itself. If the lift vanished, the squared norm of the series would vanish since the mass, volume and scalar are nonzero. Injectivity of the unramified series then recovers the input.
:::

:::theorem "grh-c-nonvanishing" (lean := "New.SiegelWeil.realConv_eq_zero_of_lift_eq_zero") (uses := "grh-c-doubling, grh-c-sharp-norm")
Vanishing of a lift with sharp finite data forces the convolution by its integrable real matrix coefficient to vanish. For the edge type in the sharp norm theorem this supplies a nonvanishing test on nonzero inputs.
:::

:::proof "grh-c-nonvanishing"
Translate the vanishing pairing at the finite places. Moving the real convolution across the Petersson pairing shows that the translated averages are zero. Express the self-pairing of the Rallis series by summing these averages over unramified cosets. Its value is zero, so positivity and injectivity of the series force the real convolution to vanish. The edge-type conclusion uses the separate scalar action on that type.
:::

:::theorem "grh-c-adjoint" (lean := "New.Data.exists_adjoint_singleLift_comp_eq") (uses := "grh-c-sharp-norm, grh-c-nonvanishing")
On the stage-$`j` forms the composite of a single lift and its adjoint is the twisted Rallis operator multiplied by the twist factor and a nonzero stage constant.
:::

:::proof "grh-c-adjoint"
Pair the proposed equality with an arbitrary test form. The definition of the adjoint turns the left side into the Petersson pairing of two lifts. The sharp norm formula evaluates that pairing and the identified finite series acts by the stated operator. Nondegeneracy turns equality of all pairings into equality of maps. The stage constant is fixed before choosing the tame twist, which later permits division of the two determinant formulas.
:::

## Exchanging adjacent lifts

For exchange one also needs to identify expressions on different spaces. The hyperbolic-plane criterion below explains when the invariant expression encountered in such a comparison can be evaluated at the identity.

:::theorem "grh-c-strong-approximation" (lean := "New.Exchange.IsAutFunction.apply_eq_apply_one")
For a unitary space containing a hyperbolic plane, an automorphic function with the specified right invariances and torus-independence on the Levi takes its value at the identity everywhere.
:::

:::proof "grh-c-strong-approximation"
Use the hyperbolic decomposition to move a representative into radical, Levi and compact factors. Split the compact correction into one element supported on the chosen nonempty places and a second integral element trivial there. The two level hypotheses remove them separately. Rational left invariance and the radical condition reduce the value to its Levi value, where independence of the torus gives the claimed constant.
:::

:::theorem "grh-c-exchange" (lean := "New.Exchange.exchange_identity")
For complementary ranks and signatures satisfying the exchange inequalities there are archimedean data and a positive normalization for which the two kernel integrals agree up to a scalar. Its squared absolute value involves a product of Hecke values.
:::

:::proof "grh-c-exchange"
Choose the real data from the exchange theorem for the partner spaces. Match the finite Schwartz data on both sides, retaining the determinant-character equivariance when changing the finite character. The equivariance factors are the same on both sides of the integral identity. This leaves the scalar from the exchange theorem with its prescribed squared norm. Uniformity of the real choice is what makes this identity applicable both before and after twisting.
:::

:::theorem "grh-c-matching" (lean := "New.Rows.exists_stdClassSum_eq_mul_integral_modKernel") (uses := "grh-c-exchange")
Explicit matched data turn the integral on one side of the exchange into a definite class sum on the other. The real data use the determinant polynomials of the two rows.
:::

:::proof "grh-c-matching"
Stack the rows in the prescribed determinants and contract the real polynomial after unitary averaging. With these real inputs and the matched finite functions, the definite integral is a sum over classes. Pass the two determinant characters through the modified kernel using its twist law. This proves an identity of the tested expressions and keeps the normalization attached to the class sum.
:::

:::theorem "grh-c-square" (lean := "New.Exchange.one_square_identity_of_isEdgeFamily") (uses := "grh-c-exchange, grh-c-matching")
For the matching character and edge families, going around two sides of one square can be exchanged for going around its other two sides, with the exchange scalar.
:::

:::proof "grh-c-square"
Apply the matched integral identity at the vertex where a lift meets a transpose. Express its finite side using the edge-family equivariance and the imposed rank twist. Evaluate on a vector and apply the testing functional to the resulting sum. Linearity transports the exchange scalar through the test. Iterating squares now compares the two extreme paths without making an unsupported assertion that individual edges commute.
:::

:::theorem "grh-c-chain-injective" (lean := "New.Data.lowerChainAtLevel_injective") (uses := "grh-c-adjoint, grh-c-square")
The lower chain at the indicated level is injective. In particular the associated Gram determinant on an independent family is nonzero.
:::

:::proof "grh-c-chain-injective"
Apply the inner-product identity for the chain with both arguments equal. If the output vanishes, remove the nonzero relative-level factor to see that the weighted chain has zero squared norm. Its triangular injectivity forces the starting vector to vanish. For a basis the resulting positive Gram form is nonsingular, supplying the nonzero denominator required in the comparison of paths.
:::

## Isolating one genuine lift

For one lift, an auxiliary comparison operator is built from a gluing map and its adjoint. A frame decomposes the operator into rank-one terms, yielding an integrality estimate and a complex size estimate. Its image is orthogonal to the false lifts, forms which pass a local Hecke-polynomial test while lying in the orthogonal complement of the lifts. On projecting to the genuine lifts, a determinant identity relates the operator to the desired single-lift volume through Hecke values. The denominator of that projection must still be paid. [Single-lift estimate](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/OneLift/LiftVolumeHeight.lean).

The lower bound also uses a sharpness result for theta derivatives. Theorem A needed that certain jets are divisible. The comparison of single-lift Hecke values needs a witness whose valuation is *at most* the predicted amount plus a controlled error. A tight frame reduces the problem to theta functions on a curve. Fourier inversion then expands the resulting test vector in vacuum translates. In the allowed window of degrees, one scalar with bounded conjugates controls the losses at all primes, though the witnessing Taylor coefficient can depend on the prime. [Valuation witnesses](/source/New.Derivatives.Sharpness.BoundAttained.html) and [their use for twisted Hecke values](/source/New.OneLift.HeckeValues.TwistedValueHeights.html).

To control the determinant of one edge we need integral tests that detect the whole genuine lift space. A vanishing theorem first removes spurious contributions. Three exchanges then bring the tests into a form with measurable size.

:::theorem "grh-c-false-periods" (lean := "New.Rows.stdClassSum_period_eq_zero")
At the descent pair, the period class sum vanishes on the kernel vectors specified by the hyperplane and Hecke conditions. These are the false contributions to be removed before estimating the determinant.
:::

:::proof "grh-c-false-periods"
Rewrite evaluation of the period form as a Gram-form class sum. On a conjugate of the level its stabilizer fixes the data, so the vanishing lemma for a Gram form tested against a kernel vector applies. That lemma exploits the lower tower and the hyperbolic summation in the kernel. Thus a period functional used to construct the comparison ignores these vectors even when their local Hecke test resembles that of a genuine lift.
:::

:::theorem "grh-c-series-size" (lean := "New.Data.exists_isIntegralAndSmall_leftSideSeries") (uses := "grh-c-matching")
One common nonzero scaling makes the left-side series integral away from the twist conductor and bounds the squared norms of all conjugates in the untwisted case.
:::

:::proof "grh-c-series-size"
Expand the left side in the class-sum factors. Choose the scalar clearing their fixed normalizations before choosing the test index, twist and evaluation point. Use homogeneity of the determinant polynomials to control evaluation on the bounded coordinates, and combine the three factor bounds. This gives the untwisted exponential bound with exponent $`f m b (\log  b)^2` while preserving the finite-place integrality outside the conductor.
:::

:::theorem "grh-c-three-exchanges" (lean := "New.Data.exists_mul_thirdExchangeLeftSide_eq_choiceFn") (uses := "grh-c-exchange, grh-c-series-size")
Three exchanges express the chosen test function as a twist-dependent scalar times the last left-side expression. Its squared absolute value is a fixed normalization divided by the Hecke-value product.
:::

:::proof "grh-c-three-exchanges"
Apply the two preceding exchanges to the carrier data, retaining their scalars, then exchange the third carrier. Normalize the resulting class sum by its nonzero finite cardinality. Its evaluation is the chosen function, so multiplication gives the required identity. Taking squared norms combines the three normalization factors into the single Hecke product that will enter the determinant.
:::

:::theorem "grh-c-test-functions" (lean := "New.Data.eq_zero_of_integral_choiceFn_thetaKernelPairing") (uses := "grh-c-three-exchanges")
If all the theta-kernel pairings tested against the choice functions vanish, the good input form vanishes.
:::

:::proof "grh-c-test-functions"
Suppose the form is nonzero and normalize at a point of maximal norm. Approximate the isolating test there by the truncated kernel expressions and insert the assumed zero pairings. The discarded terms bound the normalized main contribution by $`(4B+1)2/B^{19}` with $`B>10`. This is less than one, whereas the normalization gives one. The contradiction shows why a finite collection of tests suffices.
:::

:::theorem "grh-c-period-injective" (lean := "New.Rows.periodLift_injective") (uses := "grh-c-test-functions, grh-c-false-periods")
The period lift on the good forms is injective. Its gluings can consequently detect every vector needed for the comparison.
:::

:::proof "grh-c-period-injective"
Test the adjoint gluing identity on a tuple supported in one coordinate with the chosen test vector there. Every other coordinate drops out of the Petersson pairing. Its surviving gluing coefficient is nonzero, so vanishing of the lift gives the zero integrals of the preceding test-function criterion. The false-period vanishing separately places the glued forms in the orthogonal complement required by the projection.
:::

:::theorem "grh-c-value-heights" (lean := "New.Data.heightLe_inv_heckeValueProd_div")
For a regular family, the inverse ratio of the Hecke products has a height bound with a signed contribution from the chosen direction.
:::

:::proof "grh-c-value-heights"
Split the pairs entering the product into the principal contribution from rank-one theta values and the ramified factors. For the former the sharp jet estimate gives a witness with valuation bounded above. For the latter use the bounds on the individual critical ratios in the regular-family hypotheses. Multiply the estimates, keeping their powers. At the selected prime the modulus is a unit, so its norm factor adds no local cost.
:::

:::theorem "grh-c-one-determinant" (lean := "New.Data.heightLe_liftDeterminant_ratio") (uses := "grh-c-adjoint, grh-c-series-size, grh-c-three-exchanges, grh-c-period-injective, grh-c-value-heights, grh-c-clearing-bound")
A regular family gives a height bound for the ratio of the untwisted and twisted Gram determinants of one lift.
:::

:::proof "grh-c-one-determinant"
Compress the comparison operator to the genuine lift space and take its determinant. Its frame estimate supplies the archimedean size, and clearing the projection supplies a finite denominator budget. Compare the two identities for the twisted and untwisted determinants. The common nonzero normalization cancels, leaving the comparison determinant ratio and the inverse Hecke-product contribution to its dimension power. Combining their heights gives the negative direction term in the stage bound.
:::

# Paying for congruences

Congruences between eigensystems can make a projection onto just some eigensystems nonintegral. The first-order congruence argument bounds denominators using Galois extension classes. A Selmer group collects such classes subject to specified local conditions. At each prime a tame character is chosen so its first $`m` powers simultaneously control Selmer lengths and valuations of critical Hecke-value ratios. Applying the denominator bound and summing local losses gives a regular family of twists. Its bounds are precisely what the determinant comparison consumes. [Regular families](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Congruences/FitTwistsExist.lean).

## The Galois representations behind congruent eigenvalues

For example, two integral eigenvalues that differ by a multiple of a prime are difficult to separate integrally. The projector onto one eigenline is obtained from the operator minus the other eigenvalue by dividing by their difference. In higher rank the relevant denominator depends on the whole family. Its estimate begins by attaching Galois data to the actual eigensystems.

:::theorem "grh-c-galois-summands" (lean := "New.Selmer.exists_isMainSummand_descentPair")
A Hecke system occurring in a nonzero good form on the specified principal level yields a main Galois summand of rank $`r` for the untwisted descent pair at each stage.
:::

:::proof "grh-c-galois-summands"
Decompose the central good idempotent as a sum of tuple projectors. Since the input is nonzero, at least one good tuple survives. Transfer its eigensystem to an algebraic form and attach a Galois representation using the lift setting of that tuple. Identify its trace at unramified Frobenii with the appropriate coefficient of the Hecke polynomial. Continuity of the coefficients gives the required trace limit at general elements. The descent pair has rank difference $`t` and weight the negative lift weight. Substitution in its shifted jumps gives precisely the main-summand weight condition, making this representation eligible for the twisting theorem.
:::

:::theorem "grh-c-cocycle-count" (lean := "New.IsLargeLevel.SplitPlaces.hasFewCocycles_of_central")
Let the selected split Frobenii detect the prime-power roots of level units in the sense that roots fixed by all of them are fixed by the chosen subgroup. Suppose a central element modulo that subgroup has trivial cyclotomic character and acts with its difference from the identity injective on the finite coefficient module. For a module fixed by the subgroup and killed by the indicated prime power there is a uniform upper bound on the number of trivialised cocycles.
:::

:::proof "grh-c-cocycle-count"
First treat modules killed by the prime. Reciprocity for the split places and the condition on fixed roots of units give the required surjectivity of restriction. The count in this case is exactly the module cardinality to the power one plus the number of selected places. Filter a prime-power module by modules killed by the prime, and use the short-exact-sequence bound at each extension. This preserves the upper bound once exact counting is no longer available.
:::

:::theorem "grh-c-odd-cocycles" (lean := "New.exists_length_shaOdd_le")
For a CM field inside the cyclotomic field of level $`N` and exponents below $`t`, one nonzero integer bounds the lengths of all the indicated odd cocycle modules by its valuation.
:::

:::proof "grh-c-odd-cocycles"
For each positive exponent obtain a Stickelberger annihilator. Small primes are handled by the bound for primes at most the square of the scale, large primes by the complementary length estimate. Take the product of the auxiliary integers with the common power used in these estimates, and include the class number for the zero-exponent case. Each local bound divides the common integer, so taking its valuation bounds every length simultaneously.
:::

## Controlling local losses at the residue characteristic

At a place above the residue characteristic the loss comes from integral local conditions. A cup product measures the obstruction to pairing two extension classes trivially. If a controlled power of the prime makes the cup product a coboundary, that power bounds the obstruction. The chart records a sequence of Hodge–Tate jump windows, one at each embedding, through which Frobenius transports a representative.

:::theorem "grh-c-safe-move" (lean := "New.Lift.KummerChart.PairingSide.SidePairing.exists_mem_stopPoints_isSafeMoveFst")
On a run of letters where the two jump bounds have opposite directions, the second side has a stop point at which moving the first by a Frobenius difference is safe for the pairing.
:::

:::proof "grh-c-safe-move"
Take the proposed second-side point itself. The downward jump inequalities and its prescribed depth put it in the standard points and then the stop set. On the first side use the lower jump inequality, the pole bounds and the annihilator of the dual cokernel. These are exactly the hypotheses guaranteeing that the difference between the transported and present first-side points is safe at that stop.
:::

:::theorem "grh-c-cut-windows" (lean := "New.Lift.KummerChart.PairingSide.SidePairing.isScaledCupCoboundary_any_pattern") (uses := "grh-c-safe-move")
On the unramified chart for $`p\ge 7`, opposite separated jump windows of the prescribed two sizes allow a power of $`p` to turn the cup product into a coboundary for every allowed sign pattern.
:::

:::proof "grh-c-cut-windows"
Mark a cut where the allowed order is smaller than the threshold. The thick and thin letter estimates place a cut within the required short backward distance. Between nearest cuts the signs either persist or give a long gap with its own estimate. These cases give compatible moves around the letters. Insert their depth and cokernel bounds into the cut-window lemma and bound its accumulated exponent by $`10^{4}(K+\lfloor \log _p(2(b+W))\rfloor )`.
:::

:::theorem "grh-c-few-low-jumps" (lean := "New.Lift.KummerChart.PairingSide.exists_relLength_le_and_isScaledCupCoboundary") (uses := "grh-c-safe-move")
For the separated windows and few low jumps in the unramified chart, one obtains both a relative-length bound and a scaled cup coboundary.
:::

:::proof "grh-c-few-low-jumps"
Restrict the parameter lattice so representatives satisfy the required depths. The low jumps measure the cost of this restriction. At a positive-window letter use the plain-depth stop rule. At a negative-window letter use the deeper negative-window estimate to show that the Frobenius difference is safe at the chosen point. Matching these moves on successive letters constructs the coboundary, retaining the length cost of the restriction.
:::

:::theorem "grh-c-cup-exponent" (lean := "New.Lift.hasCupExponent_of_isTameType") (uses := "grh-c-cut-windows, grh-c-few-low-jumps")
For the specified tame inertial type and jump windows there is a quantitative cup exponent for lattices in the indicated local class.
:::

:::proof "grh-c-cup-exponent"
Pass to a chart for the local representation and realize its permitted cocycles by the chart parameters. The tame-type polynomial bounds the cokernels of the paired lattices and of the Tate dual. Apply the window estimates with those annihilators. Finally the chart different has bound one in the estimate used here, so its contribution is absorbed by the displayed polynomial in the ranks, degrees and window sizes. This makes the estimate uniform over the class.
:::

:::theorem "grh-c-local-defect" (lean := "New.Selmer.summand_defect_le_at_place") (uses := "grh-c-cup-exponent")
For coefficients sufficiently far in the directed family of integer rings, the dual defect of each indicated main or rank-one local class has bounded normalized length.
:::

:::proof "grh-c-local-defect"
Package the tame type, occurrence of jumps, prescribed multisets and rank as a summand class. The local dual-defect theorem then applies with its cup-product estimates. Its bound carries the index of the local group and the rank of the chosen lattice. The main component gets the full defect allowance, whereas a rank-one component gets the allowance divided by $`t`, so summing the latter does not charge the full allowance at each jump.
:::

## First-order congruences and the integral projection

To return to operators on automorphic forms, one must distinguish the systems at enough auxiliary primes. Their local evaluations supply the rows of a coefficient calculation, while Selmer lengths bound the cost of isolating the surviving coefficient.

:::theorem "grh-c-prime-triangle" (lean := "New.Selmer.exists_isPrimeTriangle")
Under the field, cyclotomic divisibility and Frobenius-density hypotheses, one can arrange the auxiliary places and tame generators in a finite ordered prime triangle.
:::

:::proof "grh-c-prime-triangle"
Choose Frobenii in the allowed neighborhoods so their evaluations give the triangular relations. Order the indices by exponent and then by the auxiliary index, controlling the size by the product of their cardinalities. At the distinguished place even classes take twice the specified value. The divisibilities of the products of differences of cyclotomic powers bound the costs of separating the rows, including the factor four from squaring.
:::

:::theorem "grh-c-tame-relations" (lean := "New.Selmer.exists_tame_relations")
In a lift setting the integral models of the auxiliary twist satisfy finitely many tame relations with total valuation cost at most twice the ramification allowance plus the chosen-level contribution.
:::

:::proof "grh-c-tame-relations"
At the auxiliary primes use the two-root inertia equation. At the chosen-level places the group order supplies an annihilator. Rewrite the power relation by the geometric-sum identity. Account for a place and its conjugate separately. The auxiliary cost is at most twice the ramification bound, and at most four times the field parameter many chosen places contribute, giving the additional eightfold chosen-group-order valuation term.
:::

:::theorem "grh-c-ribet-columns" (lean := "New.Selmer.ribet_columns") (uses := "grh-c-prime-triangle, grh-c-tame-relations, grh-c-local-defect, grh-c-odd-cocycles")
Suppose the twisted main summand has a finite bound on its divisible Selmer length. For a conjugate self-dual lift setting with its auxiliary twist and prime triangle, Ribet’s construction supplies columns with controlled valuations, vanishing lower terms and a controlled top term.
:::

:::proof "grh-c-ribet-columns"
Use the separated Frobenius evaluations to choose the row combinations and the tame relations to control their denominators. Determinants of combinations of representation differences become functions on the eigensystems. In particular the coefficient supported at one element with value minus one gives the determinant of one minus its matrix. The bounds for the local defects, the main Selmer lattice and the odd terms control the valuation of the distinguished coefficient. Vanishing of lower coefficients is what subsequently isolates a diagonal operator.
:::

:::theorem "grh-c-diagonal-operator" (lean := "New.Patching.BaseLevel.exists_diagOp_mem_ellIntegralForms") (uses := "grh-c-ribet-columns")
At off-level auxiliary primes the patching identity places the appropriately scaled diagonal action on projected forms back in the lattice of integral forms, subject to its chain and divisibility hypotheses.
:::

:::proof "grh-c-diagonal-operator"
Multiply the Hecke action by the product of the selected linear factors. On the surviving projection this product acts by the product of their chosen lifted values. For a proper subset of the auxiliary indices, its multi-index lies strictly below the full multi-index, so the low-coefficient vanishing kills that contribution. Apply the integral top-coefficient identity to what remains. This is the step turning the scalar information from the columns into a lattice statement.
:::

:::theorem "grh-c-clearing-bound" (lean := "New.Selmer.denominatorLe_clearingBound") (uses := "grh-c-diagonal-operator, grh-c-ribet-columns")
If the good space is spanned by lift generators for an auxiliary twist with the prescribed ramification budget, the local projection denominator satisfies the clearing bound times the logarithm of the prime.
:::

:::proof "grh-c-clearing-bound"
Construct the correcting operator from the separated eigensystems. Its determinant has the clearing-bound estimate obtained by adding local and congruence losses. Its action on the projection of an eligible integral form is integral, and it satisfies the required pairing identity against every other eligible test form. These three outputs give the determinant, integrality and pairing clauses in the definition of the denominator bound.
:::

## Choosing a simultaneous Selmer twist

It remains to find a character for which these conditional costs are affordable at every stage. The prime and the identification of coefficient fields are fixed during the next construction.

:::theorem "grh-c-selmer-descent" (lean := "New.Selmer.exists_isTiedPrimes_card_le_and_length_le") (uses := "grh-c-cocycle-count")
For a finite family of Selmer lattices with the specified inertial element and residue-field room, tied auxiliary primes control both their number and the lengths of the tied Selmer groups.
:::

:::proof "grh-c-selmer-descent"
Begin with one prime in the prescribed neighborhood and set its slopes equal to zero. Run the tied-prime descent to shorten each of the finitely many Selmer conditions, keeping the previous ties. The initial bound and the descent count give the cardinality estimate. Identify the ideal generated by the chosen power of the rational prime with the equal uniformizer-power ideal. This converts the length obtained in descent into the required length for the original quotient.
:::

:::theorem "grh-c-roots-of-unity" (lean := "New.Selmer.exists_rootsOfUnity_ellVal_eval_le_add")
A finite family of integral polynomials with bounded total valuation at admissible test points can all be tested at one tuple of roots of unity minus one, with an arbitrarily small additive valuation loss.
:::

:::proof "grh-c-roots-of-unity"
Replace coordinates successively and bound the cost of each replacement by a small increment. Choose that increment so the maximum number of variables times the increment is at most the requested error and at most one. The piecewise evaluation estimate then applies uniformly to all the polynomials. After replacing the full set of coordinates the old test points disappear. The chosen order bound is uniform for the stated parameter bounds.
:::

:::theorem "grh-c-simultaneous-twist" (lean := "New.Selmer.exists_mFoldTwist_hasDivisibleSelmerLengthLe") (uses := "grh-c-galois-summands, grh-c-selmer-descent, grh-c-roots-of-unity")
For a finite family of main-summand-like representations and the specified critical pairs there is one admissible multifold twist at the given prime that simultaneously bounds divisible Selmer lengths and critical-value valuations for its required powers.
:::

:::proof "grh-c-simultaneous-twist"
Choose local lattices and tied conditions for all the representations together. Express the remaining requirements by a finite set of evaluations, and use roots of unity to realize them by one character of the norm-one torus. The short tied lengths give the divisible Selmer bounds for the twists. The evaluation bound for each critical pair has the residual cost four times the valuation of the selected residue cardinality minus one, plus the approximation error. The choice of the level prime puts this inside the twist budget.
:::

:::theorem "grh-c-regular-family" (lean := "New.exists_isRegularFamily") (uses := "grh-c-simultaneous-twist, grh-c-clearing-bound")
Every admissible datum has a regular family indexed by a prime together with a chosen isomorphism from the complex numbers to an algebraic closure of its local field. Each chosen modulus is coprime to that prime.
:::

:::proof "grh-c-regular-family"
At a fixed index choose the simultaneous twist for the finite family of occurring eigensystems. Its Selmer bounds make the projection-clearing theorem available at every stage, and its critical-value estimates apply for all the required powers. Choose these local twists independently. For each finite set of primes sum the local twist errors with weights $`\log  \ell `. Negligibility bounds this sum by $`x^{999}\le x_1`. The resulting height and denominator bounds are exactly the global clauses defining regularity.
:::

## Assembling the determinant and completing the basis

:::theorem "grh-guide-twists" (lean := "New.exists_isRegularFamily, New.Data.exists_hasSmallRatios_heightLe_liftDeterminant_div, New.Data.heightLe_chainDeterminant_one_div") (uses := "grh-c-regular-family, grh-c-one-determinant, grh-c-chain-injective")
For each admissible datum there is a regular family indexed by the prime and its chosen complex-to-adic identification. It supplies small inverse Hecke-value ratios and a bound for the heights of the single-lift determinant ratios. The chain comparison turns these into the height bound for the full determinant ratio.
:::

:::proof "grh-guide-twists"
Select a regular family and apply the single-lift estimate to each of its stages. In the exchanged path identity the powers of the conductor norm have zero height cost because the chosen prime is coprime to that conductor. At most $`m^2t` inverse critical ratios contribute their error allowance. Sum the stage estimates, then use the identity defining the main amount. This yields the claimed chain estimate uniformly in the adic identification.
:::

Quantitatively, the bound per stage is `d (f a (log b)⁴/m − k directionAmount)`, where $`d` is the target dimension. Summing through the chain gives the term `−d mainAmount`, since `mainAmount = m k directionAmount`. After the factors involving the twists are included, the upper bound for the height of the full ratio is `d (b + f a (log b)⁴ − mainAmount)`. This is how the same main term that A charged on the upper side reappears as a lower bound on the covolume. [Height of the chain ratio](/source/New.Determinant.Twist.LongForms.html).

The intermediate projection bound is an operator statement. On the relevant space the operator preserves Hecke eigenspaces and its eigenvalues have bounded valuation. Applying it to the projection of an integral form orthogonal to the false lifts restores integrality. The bound on those valuations uses the lengths of the twisted Selmer groups. The twisting theorem chooses one character for the finite family of main summands and critical pairs at the given prime. Controlling its first powers together lets it serve all stages of one chain. [Denominator bound](/source/New.Congruences.FirstOrder.DenominatorBound.html) and [twisting theorem](/source/New.Congruences.Selmer.TwistingTheorem.html).

The last ingredient supplies the missing basis vectors without consuming the main term.

:::theorem "grh-c-deep-level" (lean := "New.Data.exists_eq_zero_of_orthogonal_gridLevelForms")
A suitable real translate of the deeper grid-level forms detects every form of principal level in the indicated space. A form orthogonal to all the tests must vanish.
:::

:::proof "grh-c-deep-level"
Choose the finite grid level deep enough to isolate the relevant classes and the real translate supplied by the discrete-series estimate. At each infinite place steepness gives a point where the integral pairing the two real matrix coefficients has a lower bound. The bounds on finite cardinalities and volumes let the restriction theorem use these points simultaneously. Applied to an orthogonal form they force that term to vanish. Taking orthogonal complements gives the spanning statement needed when completing a nearly full family.
:::

:::theorem "grh-guide-long" (lean := "New.Data.integral_forms_long") (uses := "grh-guide-twists, grh-c-twisted-lattice, grh-c-deep-level")
For an independent family of at least `(1 − 4/b²) d` target vectors, let $`c` bound the logarithm of the untwisted lift’s squared Gram volume uniformly over every field automorphism of the complex numbers. Let $`\delta ` bound its index, with losses weighted by logarithms of primes. For each adic identification a single correcting matrix must give integrality across all allowed twists. Then `d (mainAmount − 3 f a (log b)⁴) ≤ c + 2δ`.
:::

:::proof "grh-guide-long"
Complete the independent vectors with projected grid forms. Their short lifts remain integral, and at most $`4d/b^2` additional vectors are needed, so their number cancels the quadratic size factor in their total cost. Choose a regular twist at each finite place and insert the full determinant ratio in the twisted-lattice inequality. The inverse squared scalar in the normalization is a conductor norm power times inverse critical ratios and therefore has controlled height too. The two remaining errors of size $`db` fit inside the stated logarithmic allowance. Rearranging leaves the main amount on the lower-bound side and counts the finite index twice.
:::
