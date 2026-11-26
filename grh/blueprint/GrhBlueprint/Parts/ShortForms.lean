/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Comparator.Grh.Solution

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem A. Short lifts and their denominators" =>

%%%
tag := "guide-shortforms"
%%%

A short lift has small squared norm at every complex conjugate. An integral source form satisfies the local gauge bound at every finite place. Both conditions matter because dividing by a large integer improves the complex estimate while risking large denominators.

# Counting prime powers inside a theta jet

A jet evaluates a polynomial differential operator on a theta function at zero. The operators are organized by products of minors. After a linear substitution the relevant coefficients are integral in the required degree. Factorial valuations then give a lower bound for the prime divisibility of the jet. The chain rule charges back the valuation of the substitution. The shape of the minors specifies how many times this happens. At marked places the count omits certain height-one columns and uses additional row divisibility to pay for them. Thus the estimate can be summed across primes even though the sharp local count varies by place. [Formal divisibility count](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Derivatives/Divisibility/Count.lean).

# Building a theta vector with integral values

A tight frame reconstructs a vector from its inner products with the frame elements, up to a fixed scalar. Powers of a primitive root of unity supply such a frame in the chosen CM lattice. Pull back one-variable theta sections along the corresponding linear forms and take their product. The result is the theta function of a finite adelic vector whose values are integral. Normalizing the Taylor variables by the CM period makes its derivative bounds comparable at complex and finite places. The integral vacuum is a particular such vector. Translating it by the finite Heisenberg and Weil actions yields the modules of standard data. [Tight frames](https://eric-vergo.github.io/grh-lean/source/New.Derivatives.Vacuum.TightFrames.html) and [integral vacuum](https://eric-vergo.github.io/grh-lean/source/New.Derivatives.Vacuum.IntegralVacuum.html).

:::theorem "grh-guide-vacuum" (lean := "New.Parameters.norm_intVacuum_le_one, New.Parameters.norm_schurJet_jetSeries_le_of_charges")
The values of the normalized vacuum at the specified finite vectors satisfy the integral norm bound. For standard data the charged Schur-jet estimate converts the shape calculation into a valuation bound for the derivatives used by the chain.
:::

At a given prime this estimate can require passing to a submodule of the integral ramified source. The local theorem records both the power of the prime that bounds its colength and the gain on that submodule. Its quantifiers fix the submodule before the prime-to-that-prime twist and its chain datum vary. Thus it can supply one index estimate across those choices. [Local theorem](https://eric-vergo.github.io/grh-lean/source/New.UpperBound.Divisibility.LocalDivisibility.html).

# Normalizing the Poincaré map

Expand a composite chain on the definite side in translates of the integral vacuum, the basic theta vector. Bounds for its derivatives give the complex size and the local divisibility estimates for this same chain. The seesaw transfers them to the target side up to a common nonzero scalar. The normalization removes this scalar, applies the good projection with a group-order factor to control its denominators, and divides by powers of primes. At each prime the exponent is the floor of the predicted gain less its allowed error. The sum of local errors, weighted by logarithms of primes, costs at most `errorUnit = f a (log b)³`. At primes different from the level prime the error vanishes if the prime splits in the quadratic field or lies beyond the second cutoff.

:::theorem "grh-guide-seesaw" (lean := "New.Data.seesaw_identity, New.Data.exists_err_gaugeLe_compositeLift") (uses := "grh-guide-vacuum")
Fix the real point and evaluation functional for the Poincaré map. There is a nonzero scalar common to the twists. For each twist there is a finitely supported chain datum for which the lower chain of every ramified source image equals that scalar times its composite lift. The local theorem bounds the gauge of these composite lifts after the controlled restriction of the integral source.
:::

To see why the same map appears on both sides, pair a lower-chain lift with a test form at its endpoint. Transpose the last lift across the pairing and unfold the resulting period. Its outer integral splits into a real integral and a weighted sum of finite classes. Repeating the operation exposes the whole upper-chain tensor. At the definite endpoint the remaining pairing is the inner product with the restricted form. This identity alone allows a zero image. The dimension estimate in Theorem B supplies the necessary nonvanishing in aggregate. [Seesaw unfolding](https://eric-vergo.github.io/grh-lean/source/New.UpperBound.Seesaw.SeesawIdentity.html).

:::theorem "grh-guide-short" (lean := "New.Data.span_short_integralRamified_eq_top, New.Data.indexLe_normalizedPoincare") (uses := "grh-guide-seesaw")
The ramified source is spanned over the complex numbers by integral forms whose normalized images, for every translate, have untwisted lifts of squared norm at every conjugate at most `exp(mainAmount − m totalRemainder + f a (log b)⁴)`. For images of integral forms from a finite set of translates, the index bound is twice the error unit times the number of translates times the dimension of the ramified source.
:::

The index estimate charges each translate for at most one source dimension of denominators. This explains why the next step counts how many translates are used, as well as how many independent images they produce. [Assembly of the local and archimedean bounds](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/ShortAndEnough.lean).
