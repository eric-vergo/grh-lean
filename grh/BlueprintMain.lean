/-
Released under the Apache 2.0 license as described in LICENSE.
Authors: Eric Vergo, GPT-6.2 (OpenAI)
-/
import VersoManual
import VersoBlueprint.PreviewManifest
import GrhBlueprint

open Verso Doc Verso.Genre Manual

set_option maxHeartbeats 0 in
def main (args : List String) : IO UInt32 :=
  Informal.PreviewManifest.blueprintMainWithPreviewData (%doc GrhBlueprint) args
    (extensionImpls := by exact extension_impls%)
    (sideBySide := true)
    (sidebar? := some { links := #[
      { label := "Readable edition", href := "https://github.com/eric-vergo/grh-lean/tree/codex/grh-blueprint/grh" }] })
