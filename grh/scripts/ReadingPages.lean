/-
Released under the Apache 2.0 license as described in LICENSE.
Authors: Eric Vergo, GPT-6.2 (OpenAI)
-/
import MD4Lean
import Lean.Data.Json
import Std.Data.HashMap

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

/-- Add a chapter link beside each argument in the upstream index. Key rows by their
original first cell so an upstream insertion cannot silently shift the concordance. -/
private def withProofLinks (source : String) (site : FilePath) : IO String := do
  let manifest ← IO.ofExcept <| Lean.Json.parse <| ← IO.FS.readFile
    (site / "-verso-data" / "blueprint-manifest.json")
  let previews : Array Lean.Json ← IO.ofExcept (manifest.getObjValAs? _ "previews")
  let mut urls : Std.HashMap String String := {}
  for preview in previews do
    if (← IO.ofExcept (preview.getObjValAs? String "facet")) == "statement" then
      urls := urls.insert (← IO.ofExcept (preview.getObjValAs? String "authoredLabel"))
        (← IO.ofExcept (preview.getObjValAs? String "href"))
  let mut entries : Std.HashMap (String × String) String := {}
  for line in (← IO.FS.lines "blueprint/coverage.tsv") do
    let [sectionName, row, label] := line.splitOn "\t"
      | throw <| IO.userError s!"Invalid coverage row: {line}"
    let some url := urls[label]? | throw <| IO.userError s!"Unknown blueprint entry: {label}"
    if entries.contains (sectionName, row) then throw <| IO.userError s!"Duplicate index row: {row}"
    entries := entries.insert (sectionName, row) url
  let mut sectionName := ""
  let mut tableRow := 0
  let mut lines := #[]
  for line in source.splitOn "\n" do
    if line.startsWith "## " then
      sectionName := (line.drop 3).toString
      tableRow := 0
    if ["The last step", "Steps of the argument"].contains sectionName && line.startsWith "|" then
      let cell := ((line.splitOn "|")[1]!).trimAscii.toString
      let link ← match tableRow with
        | 0 => pure "Blueprint"
        | 1 => pure "---"
        | _ => do
          let some href := entries[(sectionName, cell)]?
            | throw <| IO.userError s!"Missing blueprint entry for {cell}"
          entries := entries.erase (sectionName, cell)
          pure s!"[Read the argument](../{href})"
      tableRow := tableRow + 1
      lines := lines.push (line ++ " " ++ link ++ " |")
    else
      lines := lines.push line
  unless entries.isEmpty do throw <| IO.userError "Concordance includes rows absent from INDEX.md"
  return String.intercalate "\n" lines.toList

/-- Old subsection URLs keep both section bookmarks and deep links to proof panels. -/
private def writeSectionLinks (site : FilePath) : IO Unit := do
  for line in (← IO.FS.lines "blueprint/section-links.tsv") do
    let [path, anchor] := line.splitOn "\t" | throw <| IO.userError s!"Invalid section link: {line}"
    let dir := site / path
    let target := "../#" ++ anchor
    IO.FS.createDirAll dir
    IO.FS.writeFile (dir / "index.html") <| "<!doctype html><html lang=\"en\"><meta charset=\"utf-8\">" ++
      "<title>GRH blueprint section</title><script>location.replace('../'+location.search+" ++
      "(location.hash||'#" ++ anchor ++ "'))</script><meta http-equiv=\"refresh\" content=\"0;url=" ++
      target ++ "\"><p><a href=\"" ++ target ++ "\">Read this section in the chapter</a></p></html>\n"

private def render (dest : FilePath) (doc : String) : IO Unit := do
  let source ← IO.FS.readFile (doc ++ ".md")
  let markdown ← if doc == "INDEX" then withProofLinks source (dest / "..") else pure source
  let some raw := MD4Lean.renderHtml markdown (MD4Lean.MD_DIALECT_GITHUB ||| MD4Lean.MD_FLAG_NOHTML)
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
  writeSectionLinks (FilePath.mk dest / "..")
