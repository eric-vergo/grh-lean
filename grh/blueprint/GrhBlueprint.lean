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
line, and a declaration search result takes you to its definition. The chapter panels explain
selected steps. The dependency graph below describes the relationships recorded in those panels.

The Project Stats page compares the five statements in `Comparator.Grh.Challenge` with those
in `Comparator.Grh.Solution` and reports the outcome of this build's kernel replay. The build
checks that the solution file matches `src/Main.lean` byte for byte and separately prints the
axioms of the five declarations imported from `Main`. The original proof is Levent Alpöge's
with Claude. The upstream readable edition credits Claude with writing the Lean development
and its accompanying guides. The site reproduces that source under its
[license](source/LICENSE), [notice](source/NOTICE), and [attributions](source/ATTRIBUTION.md).

{include 0 GrhBlueprint.Parts.Orientation}

{include 0 GrhBlueprint.Parts.ShortForms}

{include 0 GrhBlueprint.Parts.Spanning}

{include 0 GrhBlueprint.Parts.LongForms}

{include 0 GrhBlueprint.Parts.Cancellation}

{include 0 GrhBlueprint.Parts.Analytic}

{include 0 GrhBlueprint.Parts.Atlas}

{blueprint_graph}

{blueprint_summary}
