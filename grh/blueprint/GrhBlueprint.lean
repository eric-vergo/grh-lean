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
The [source atlas](source/index.html) indexes the readable edition by module and declaration.

{include 0 GrhBlueprint.Parts.Orientation}

{include 0 GrhBlueprint.Parts.ShortForms}

{include 0 GrhBlueprint.Parts.Spanning}

{include 0 GrhBlueprint.Parts.LongForms}

{include 0 GrhBlueprint.Parts.Cancellation}

{include 0 GrhBlueprint.Parts.Analytic}

{include 0 GrhBlueprint.Parts.Atlas}

{blueprint_graph}

{blueprint_summary}
