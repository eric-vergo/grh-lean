/-
Released under the Apache 2.0 license as described in LICENSE.
Authors: Eric Vergo, GPT-6.2 (OpenAI)
-/
import Comparator.Grh.Solution
import Verso
import VersoManual
import VersoBlueprint
import VersoBlueprint.Commands.Graph
import VersoBlueprint.Commands.Summary
import GrhBlueprint.Notices
import GrhBlueprint.Parts.Orientation
import GrhBlueprint.Parts.ShortForms
import GrhBlueprint.Parts.Spanning
import GrhBlueprint.Parts.LongForms
import GrhBlueprint.Parts.Cancellation
import GrhBlueprint.Parts.Analytic
import GrhBlueprint.Parts.Atlas

open Verso.Genre Verso.Genre.Manual Informal

#doc (Manual) "The Generalized Riemann Hypothesis for Dirichlet L-functions" =>

This blueprint follows the readable Lean edition of Levent Alpöge's argument with Claude.
Start with the five formal statements, then follow the construction of modular forms,
the lattice estimates, and the passage from a prime sum to zeros of Dirichlet L-functions.
The [source atlas](source/index.html) displays every file under `grh/src`. Its declaration
names and locations come from the Lean compiler's source index. A line number links to that
line, and a declaration search result takes you to its definition. Each chapter places the informal proofs beside their Lean declarations. Follow a theorem in
the dependency graph to see which earlier results it uses. For a particular step from the readable
edition, the [results index](reading/index.html#steps-of-the-argument) links directly to the argument.

The readable edition’s [guide](reading/guide.html) includes its [glossary](reading/guide.html#2-glossary)
and [table of scales](reading/guide.html#3-sizes). The [results and sources](reading/index.html)
connect each part of the argument to a file. The [reference audit](reading/references.html)
records which citations the edition checked and how.

The Project Stats page compares the five statements in `Comparator.Grh.Challenge` with those
in `Comparator.Grh.Solution` and reports the outcome of this build's kernel replay. The build
checks that the solution file matches `src/Main.lean` byte for byte and separately prints the
axioms of the five declarations imported from `Main`. The original proof is Levent Alpöge's
with Claude. The upstream readable edition credits Claude with writing the Lean development
and its accompanying guides. The site reproduces that source under its
[license](source/LICENSE), [notice](source/NOTICE), and [attributions](source/ATTRIBUTION.md).

The five conclusions are stated in the following declarations.

- [`riemannHypothesis`](source/Main.html#d-riemannHypothesis) proves Mathlib's Riemann hypothesis.
- [`riemannZeta_eq_zero_re`](source/Main.html#d-riemannZeta_eq_zero_re) puts every zeta zero other than the negative even integers, with the point one excluded, on the critical line.
- [`LFunction_ne_zero_of_half_lt_re`](source/Main.html#d-LFunction_ne_zero_of_half_lt_re) gives nonvanishing to the right of the critical line for every character of every positive modulus, with the principal character at one excluded.
- [`LFunction_eq_zero_re`](source/Main.html#d-LFunction_eq_zero_re) puts the zeros in the open critical strip of every such character on the critical line.
- [`LFunction_eq_zero_re_of_isPrimitive`](source/Main.html#d-LFunction_eq_zero_re_of_isPrimitive) specializes the strip result to primitive characters.

{include 0 GrhBlueprint.Parts.Orientation}

{include 0 GrhBlueprint.Parts.ShortForms}

{include 0 GrhBlueprint.Parts.Spanning}

{include 0 GrhBlueprint.Parts.LongForms}

{include 0 GrhBlueprint.Parts.Cancellation}

{include 0 GrhBlueprint.Parts.Analytic}

{include 0 GrhBlueprint.Parts.Atlas}

{blueprint_graph}

{blueprint_summary}

{include 0 GrhBlueprint.Notices}
