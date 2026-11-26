/-
Released under the Apache 2.0 license as described in LICENSE.
Authors: Eric Vergo, GPT-6.2 (OpenAI)
-/
import MD4Lean

open System

private def revision := "72fead102f663d5c7a407964a13dc0cf9d977207"
private def upstream (kind : String) := "https://github.com/lsernau/grh-lean/" ++ kind ++
  "/" ++ revision ++ "/grh/"

private def documents := ["GUIDE", "INDEX", "REFERENCES"]

/-- Map the edition's inline file references to the local atlas or the preserved upstream source. -/
private def fileLink (label : String) : IO (Option String) := do
  if (label.splitOn "/").any (· == "..") then return none
  if !label.toList.all (fun c ↦ c.isAlphanum || "/._-".toList.contains c) then return none
  if let some doc := documents.find? (fun d ↦ label == d ++ ".md") then
    return some (doc.toLower ++ ".html")
  if label.endsWith ".md" && (← FilePath.pathExists label) then return some (upstream "blob" ++ label)
  let name := ((label.dropPrefix "src/").dropSuffix ".lean").toString
  let file : FilePath := "src" / (name ++ ".lean")
  if ← file.pathExists then return some ("../source/" ++ name.replace "/" "." ++ ".html")
  if label.startsWith "src/" || ["Lib", "New"].contains name ||
      name.startsWith "Lib/" || name.startsWith "New/" then
    if ← (FilePath.mk "src" / name).isDir then return some (upstream "tree" ++ "src/" ++ name)
  return none

private def withFileLinks (html : String) : IO String := do
  let pieces := html.splitOn "<code>"
  let mut out := pieces.head!
  for piece in pieces.tail! do
    match piece.splitOn "</code>" with
    | [label, rest] =>
      let code := "<code>" ++ label ++ "</code>"
      match ← fileLink label with
      | some href => out := out ++ "<a href=\"" ++ href ++ "\">" ++ code ++ "</a>" ++ rest
      | none => out := out ++ code ++ rest
    | _ => throw <| IO.userError "Unexpected code span in rendered Markdown"
  return out

private def render (dest : FilePath) (doc : String) : IO Unit := do
  let source ← IO.FS.readFile (doc ++ ".md")
  let some raw := MD4Lean.renderHtml source (MD4Lean.MD_DIALECT_GITHUB ||| MD4Lean.MD_FLAG_NOHTML)
    | throw <| IO.userError s!"Failed to render {doc}.md"
  let mut body ← withFileLinks raw
  let mut sections := ""
  for line in raw.splitOn "\n" do
    if line.startsWith "<h2>" && line.endsWith "</h2>" then
      let heading := ((line.dropPrefix "<h2>").dropSuffix "</h2>").toString
      let id := String.intercalate "-" <| (heading.toLower.splitOn " ").map fun word ↦
        String.ofList (word.toList.filter Char.isAlphanum)
      body := body.replace line ("<h2 id=\"" ++ id ++ "\">" ++ heading ++ "</h2>")
      sections := sections ++ "<li><a href=\"#" ++ id ++ "\">" ++ heading ++ "</a></li>"
  let title := ((source.splitOn "\n").head!.dropPrefix "# ").toString
  let nav := "<nav><a href=\"../index.html\">GRH blueprint</a> · <a href=\"../source/index.html\">Source atlas</a> · <a href=\"guide.html\">Reading guide</a> · <a href=\"index.html\">Results</a> · <a href=\"references.html\">References</a></nav>"
  let credit := "<p>From the original readable edition. <a href=\"" ++ upstream "blob" ++ doc ++
    ".md\">Pinned original</a> · <a href=\"../source/LICENSE\">License</a> · <a href=\"../source/NOTICE\">Notice</a> · <a href=\"../source/ATTRIBUTION.md\">Attributions</a></p>"
  let header := "<!doctype html><html lang=\"en\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>" ++
    title ++ " · GRH readable edition</title><link rel=\"stylesheet\" href=\"../source/atlas.css\"><body class=\"edition-document\">"
  body := body.replace ("<h1>" ++ title ++ "</h1>") ("<h1>" ++ title ++ "</h1>" ++ credit ++
    "<nav aria-label=\"On this page\"><ul>" ++ sections ++ "</ul></nav>")
  IO.FS.writeFile (dest / (doc.toLower ++ ".html")) (header ++ nav ++ "<main>" ++ body ++ "</main></body></html>\n")

/-- Publish the complete guide, result concordance and source comparison from the readable edition. -/
def main (args : List String) : IO Unit := do
  let [dest] := args | throw <| IO.userError "Usage: ReadingPages.lean OUTPUT_DIRECTORY"
  IO.FS.createDirAll dest
  documents.forM (render dest)
