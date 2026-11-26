/-
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Eric Vergo, OpenAI Codex
-/
import VersoManual
import VersoBlueprint
import Main

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "Theorem A. Short lifts and their denominators" =>

%%%
tag := "guide-shortforms"
%%%

A short lift has small squared norm at every complex conjugate. An integral source form satisfies the local gauge bound at every finite place. Both conditions matter because dividing by a large integer improves the complex estimate while risking large denominators.

# Counting prime powers inside a theta jet

A jet evaluates a polynomial differential operator on a theta function at zero. The operators are organized by products of minors. After a linear substitution the relevant coefficients are integral in the required degree. Factorial valuations then give a lower bound for the prime divisibility of the jet. The chain rule charges back the valuation of the substitution. The shape of the minors specifies how many times this happens. At marked places the count omits certain height-one columns and uses additional row divisibility to pay for them. Thus the estimate can be summed across primes even though the sharp local count varies by place. [Formal divisibility count](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Derivatives/Divisibility/Count.lean).

# Normalizing the Poincaré map

Expand a composite chain on the definite side in translates of the integral vacuum, the basic theta vector. Bounds for its derivatives give the complex size and the local divisibility estimates for this same chain. The seesaw transfers them to the target side up to a common nonzero scalar. The normalization removes this scalar, applies the good projection with a group-order factor to control its denominators, and divides by powers of primes. At each prime the exponent is the floor of the predicted gain less its allowed error. The sum of local errors, weighted by logarithms of primes, costs at most `errorUnit = f a (log b)³`. At primes different from the level prime the error vanishes if the prime splits in the quadratic field or lies beyond the second cutoff.

:::theorem "grh-guide-short" (lean := "New.Data.span_short_integralRamified_eq_top, New.Data.indexLe_normalizedPoincare")
The ramified source is spanned over the complex numbers by integral forms whose normalized images, for every translate, have untwisted lifts of squared norm at every conjugate at most `exp(mainAmount − m totalRemainder + f a (log b)⁴)`. For images of integral forms from a finite set of translates, the index bound is twice the error unit times the number of translates times the dimension of the ramified source.
:::

The index estimate charges each translate for at most one source dimension of denominators. This explains why the next step counts how many translates are used, as well as how many independent images they produce. [Assembly of the local and archimedean bounds](https://github.com/lsernau/grh-lean/blob/72fead102f663d5c7a407964a13dc0cf9d977207/grh/src/New/Reduction/ShortAndEnough.lean).
