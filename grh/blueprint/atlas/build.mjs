// SPDX-License-Identifier: Apache-2.0
// Authors: Eric Vergo, GPT-6.2 (OpenAI)
import { mkdir, readFile, readdir, writeFile, copyFile } from 'node:fs/promises';
import path from 'node:path';

const args = process.argv.slice(2);
const pilot = args.includes('--measure-source');
const output = args.find(arg => !arg.startsWith('--')) ?? '_out/site/html-multi/source';
const titles = new Map();
const entries = [];
const catalog = [];
const bytes = { sourcePages: 0, indexPage: 0, searchData: 0, sharedAssets: 0 };
const escape = value => value.replaceAll('&', '&amp;').replaceAll('<', '&lt;')
  .replaceAll('>', '&gt;').replaceAll('"', '&quot;');
const modulePage = name => encodeURIComponent(name) + '.html';

// Lean records LSP columns in UTF-16, which are JavaScript string offsets.
function sourceLinks(index, known) {
  const links = new Map();
  for (const [key, reference] of Object.entries(index.references ?? {})) {
    const constant = JSON.parse(key).c;
    if (!constant || !known.get(constant.m)?.has(constant.n)) continue;
    const page = constant.m === index.module ? '' : modulePage(constant.m);
    const href = page + '#d-' + encodeURIComponent(constant.n);
    for (const [line, start, last, end] of reference.usages) {
      if (line !== last || start >= end) continue;
      if (!links.has(line)) links.set(line, []);
      links.get(line).push({start, end, href});
    }
  }
  return links;
}

function renderLine(text, references) {
  let markup = '';
  let at = 0;
  for (const ref of (references ?? []).sort((a,b) => a.start-b.start || a.end-b.end)) {
    if (ref.start < at || ref.end > text.length) continue;
    markup += escape(text.slice(at,ref.start));
    markup += '<a class="ref" href="'+escape(ref.href)+'">'+escape(text.slice(ref.start,ref.end))+'</a>';
    at = ref.end;
  }
  return markup + escape(text.slice(at));
}

async function walk(dir) {
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    const file = path.join(dir, entry.name);
    if (entry.isDirectory()) await walk(file);
    else if (entry.name.endsWith('.lean')) entries.push(file);
  }
}

function page(title, main, extra = '') {
  return '<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>' +
    escape(title) + ' · GRH source atlas</title><link rel="stylesheet" href="atlas.css">' +
    '<header><nav><a href="../index.html">GRH blueprint</a> / <a href="index.html">Source atlas</a></nav></header>' +
    '<main><h1>' + escape(title) + '</h1>' + main + '</main>' + extra + '</html>\n';
}
async function write(file, data, group) {
  await writeFile(path.join(output, file), data);
  bytes[group] += Buffer.byteLength(data);
}
await mkdir(output, { recursive: true });
await walk('src');
entries.sort();
for (const file of entries) {
  const name = file.slice(4, -5).split(path.sep).join('.');
  titles.set(name, file);
}
const indexFile = file => path.join('.lake/build/lib/lean',file.slice(4,-5)+'.ilean');
const known = new Map();
if (!pilot) {
  for (const [name,file] of titles) {
    const compiler = JSON.parse(await readFile(indexFile(file),'utf8'));
    known.set(name,new Set(Object.keys(compiler.decls)));
  }
}
for (const [name, file] of titles) {
  const source = await readFile(file, 'utf8');
  const lines = source.split('\n');
  if (lines.at(-1) === '') lines.pop();
  const idx = pilot ? { module: name, decls: {}, directImports: [] } :
    JSON.parse(await readFile(indexFile(file), 'utf8'));
  if (idx.module !== name || !idx.decls || !Array.isArray(idx.directImports)) {
    throw new Error('Missing compiler index for ' + file);
  }
  const decls = Object.entries(idx.decls).map(([decl, range]) => [decl, range[4] + 1]);
  decls.sort((a,b) => a[1]-b[1] || a[0].localeCompare(b[0]));
  const anchor = decl => 'd-' + encodeURIComponent(decl);
  const anchors = new Map();
  for (const [decl,line] of decls) {
    if (!Number.isSafeInteger(line) || line < 1 || line > lines.length) throw new Error(file + ': invalid source range for ' + decl);
    if (!anchors.has(line)) anchors.set(line, []);
    anchors.get(line).push('<span id="' + escape('d-' + decl) + '"></span>');
  }
  const imports = idx.directImports.map(([mod]) => titles.has(mod)
    ? '<a href="' + modulePage(mod) + '">' + escape(mod) + '</a>' : escape(mod));
  const links = decls.map(([decl]) => '<li><a href="#'+anchor(decl)+'">'+escape(decl)+'</a></li>');
  const refs = sourceLinks(idx,known);
  const rendered = lines.map((line,i) => '<span class="line" id="L'+(i+1)+'">'+(anchors.get(i+1) ?? []).join('')+
    '<a class="ln" aria-label="Line '+(i+1)+'" href="#L'+(i+1)+'">'+(i+1)+'</a>'+renderLine(line,refs.get(i))+'</span>').join('\n');
  await write(modulePage(name), page(name,
    '<p><code>'+escape(file)+'</code> · '+lines.length+' lines · '+decls.length+' compiler-indexed declarations</p>'+
    '<p>Imports: '+imports.join(', ')+'</p><details><summary>Declarations in source order</summary><ul>'+
    links.join('')+'</ul></details><pre><code>'+rendered+'</code></pre>'), 'sourcePages');
  catalog.push([name, decls.map(([decl]) => decl)]);
}
const moduleList = [...titles.keys()].map(name => '<li><a href="'+modulePage(name)+'">'+escape(name)+'</a></li>').join('');
await write('index.html', page('Readable edition source atlas',
  '<p>Browse all '+entries.length+' Lean modules. Select a declaration or line number to copy a link to its source.</p>'+
  '<form role="search"><label for="q">Find a module or declaration</label> <input type="search" name="q" id="q" autocomplete="off"><button>Search</button></form>'+
  '<p role="status" id="status"></p><ul id="hits"></ul><h2>Modules</h2><ul>'+moduleList+'</ul>',
  '<footer><a href="LICENSE">Apache 2.0 license</a> · <a href="NOTICE">Notice</a> · <a href="ATTRIBUTION.md">Source attributions</a></footer><script type="module" src="search.js"></script>'), 'indexPage');
await write('catalog.json', JSON.stringify(catalog), 'searchData');
for (const asset of ['atlas.css','search.js']) {
  await write(asset, await readFile(new URL(asset,import.meta.url)), 'sharedAssets');
}
await copyFile('LICENSE', path.join(output,'LICENSE'));
await copyFile('NOTICE', path.join(output,'NOTICE'));
await copyFile('ATTRIBUTION.md', path.join(output,'ATTRIBUTION.md'));
console.log(JSON.stringify({mode: pilot ? 'source-only pilot' : 'compiler-indexed atlas',
  modules: entries.length, declarations: catalog.reduce((sum,row)=>sum+row[1].length,0), bytes}));
