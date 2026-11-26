"""Check the published atlas, links and proof-verification results. SPDX-License-Identifier: Apache-2.0."""
import json
import re
import sys
from collections import Counter
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urljoin, urlsplit


class Page(HTMLParser):
    def __init__(self, file):
        super().__init__()
        self.base = None
        self.navigation = set()
        self.ids = set()
        self.hrefs = set()
        self.classes = Counter()
        self.tags = Counter()
        self.verdicts = {}
        self.line_depth = 0
        self.line = []
        self.lines = []
        self.line_number = False
        self.source_links = []
        self.feed(file.read_text())
        self.close()

    def handle_starttag(self, tag, attrs):
        self.tags[tag] += 1
        attrs = dict(attrs)
        if self.line_depth:
            self.line_depth += 1
        if attrs.get('class') == 'line':
            self.line_depth = 1
            self.line = []
        if attrs.get('class') == 'ln':
            self.line_number = True
        if attrs.get('class') == 'ref':
            self.source_links.append(unquote(attrs['href']))
        if 'data-bp-theorem' in attrs and 'data-bp-verdict' in attrs:
            self.verdicts[attrs['data-bp-theorem']] = attrs['data-bp-verdict']
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        if tag == 'base' and self.base is None and attrs.get('href') is not None:
            self.base = attrs['href']
        if tag == 'a' and attrs.get('href') is not None:
            self.navigation.add(attrs['href'])
        if attrs.get('href') is not None:
            self.hrefs.add(unquote(attrs['href']))
        self.classes.update((attrs.get('class') or '').split())

    def handle_data(self, data):
        if self.line_depth and not self.line_number:
            self.line.append(data)

    def handle_endtag(self, tag):
        if self.line_depth:
            self.line_depth -= 1
            if self.line_depth == 0:
                self.lines.append(''.join(self.line))
        if tag == 'a':
            self.line_number = False


def check(condition, text):
    if not condition:
        raise SystemExit(text)


def check_navigation(site):
    project_url = 'https://eric-vergo.github.io/grh-lean/'
    root = urlsplit(project_url)
    ids = {}
    static = dynamic = 0
    for file in site.rglob('*.html'):
        relative = file.relative_to(site)
        if relative.parts[0] == 'source':
            continue
        page = Page(file)
        page_url = urljoin(project_url, relative.as_posix())
        base = urljoin(page_url, page.base or page_url)
        for href in page.navigation:
            target = urlsplit(urljoin(base, href))
            if target.scheme not in ('http', 'https') or target.netloc != root.netloc:
                continue
            path = unquote(target.path)
            check(path.startswith(root.path), f'{relative}: link escapes project path: {href}')
            dest = site / path.removeprefix(root.path)
            if dest.is_dir():
                dest = dest / 'index.html'
            check(dest.is_file(), f'{relative}: missing target {href} ({dest})')
            fragment = unquote(target.fragment)
            if fragment.startswith(('--informal-preview-', '--informal-external-decl-')):
                # VersoBlueprint opens these preview/declaration targets in its client runtime.
                dynamic += 1
                continue
            if fragment and dest.suffix == '.html':
                if dest not in ids:
                    ids[dest] = Page(dest).ids
                check(fragment in ids[dest], f'{relative}: missing fragment {href} ({dest})')
            static += 1
    print(f'Checked {static} local navigation links under {root.path} and '
          f'{dynamic} client-managed preview links for destination pages')


def check_reading_pages(site):
    for document in ('GUIDE', 'INDEX', 'REFERENCES'):
        markdown = Path(document + '.md').read_text()
        page = Page(site / 'reading' / (document.lower() + '.html'))
        lines = markdown.splitlines()
        rows = sum(line.startswith('|') and not re.fullmatch(r'[| :\-]+', line) for line in lines)
        check(page.tags['tr'] == rows, f'{document}: expected all {rows} table rows')
        check(page.tags['h2'] == sum(line.startswith('## ') for line in lines),
              f'{document}: missing section')
        for name in set(re.findall(r'`((?:New|Lib)/[A-Za-z0-9_/]+)`', markdown)):
            if (Path('src') / (name + '.lean')).is_file():
                check('../source/' + name.replace('/', '.') + '.html' in page.hrefs,
                      f'{document}: no atlas link for {name}')
        check(any(h.endswith('/grh/' + document + '.md') for h in page.hrefs),
              f'{document}: missing upstream provenance link')


def check_atlas(site):
    atlas = site / 'source'
    index = Page(atlas / 'index.html')
    catalog = dict(json.loads((atlas / 'catalog.json').read_text()))
    sources = {'.'.join(p.relative_to('src').with_suffix('').parts): p for p in Path('src').rglob('*.lean')}
    check(catalog.keys() == sources.keys(), 'Source atlas module coverage mismatch')
    indexed = {module: set(names) for module, names in catalog.items()}
    total_lines = total_links = 0
    for module, source in sources.items():
        filename = module + '.html'
        check(filename in index.hrefs, 'Missing module link: ' + module)
        page = Page(atlas / filename)
        compiler = json.loads((Path('.lake/build/lib/lean') / source.relative_to('src').with_suffix('.ilean')).read_text())
        expected = set(compiler['decls'])
        check(set(catalog[module]) == expected, 'Incomplete declaration search: ' + module)
        check(all('d-' + d in page.ids for d in expected), 'Missing declaration anchor: ' + module)
        lines = source.read_text().splitlines()
        total_lines += len(lines)
        total_links += len(page.source_links)
        check(page.lines == lines, 'Published text differs from Lean source: ' + module)
        for href in page.source_links:
            target, anchor = href.split('#', 1)
            target_module = target.removesuffix('.html') if target else module
            check(anchor.startswith('d-') and anchor[2:] in indexed.get(target_module, set()),
                  'Unknown source reference in ' + module + ': ' + href)
        check(all('L' + str(n) in page.ids for n in range(1,len(lines)+1)), 'Missing line: ' + module)
        check(all(not h.startswith('#') or h[1:] in page.ids for h in page.hrefs), 'Broken local link: ' + module)
    return len(sources), sum(map(len, catalog.values())), total_lines, total_links


site = Path(sys.argv[1])
if sys.argv[2:] == ['--atlas-only']:
    modules, declarations, lines, links = check_atlas(site)
    print(f'Verified {modules} modules, {declarations:,} declaration anchors, {lines:,} source lines '
          f'and {links:,} linked references')
    sys.exit(0)
check_navigation(site)
if sys.argv[2:] == ['--links-only']:
    sys.exit(0)
check_reading_pages(site)
if sys.argv[2:] == ['--reading-only']:
    sys.exit(0)
modules, declarations, _, _ = check_atlas(site)
landing = Page(site / 'index.html')
check('source/index.html' in landing.hrefs, 'Landing page has no source atlas link')
check({'reading/guide.html', 'reading/guide.html#2-glossary', 'reading/guide.html#3-sizes',
       'reading/index.html', 'reading/references.html'} <= landing.hrefs,
      'Landing page does not link to all readable companions')
stats = Page(site / 'Project-Stats/index.html')
judged = json.loads(Path('Comparator/Grh/comparator.json').read_text())['theorem_names']
check(all('source/Main.html#d-' + name in landing.hrefs for name in judged),
      'Landing page does not link to each canonical theorem')
check(stats.verdicts == dict.fromkeys(judged, 'proved'), 'Comparator theorem verdicts mismatch')
check(stats.classes['bp_stats_replay_accepted'] > 0, 'Kernel replay has not accepted the export')
sizes = Counter()
for file in site.rglob('*'):
    if not file.is_file():
        continue
    relative = file.relative_to(site)
    check(file.suffix != '.ndjson', 'Private kernel export in the published site: ' + str(relative))
    if relative.parts[0] == 'source':
        group = 'indexed source atlas'
    elif file.suffix == '.html':
        group = 'blueprint HTML pages'
    elif relative.parts[0] == '-verso-data' and file.suffix == '.json':
        group = 'blueprint JSON data'
    else:
        group = 'shared assets and other files'
    sizes[group] += file.stat().st_size
size = sizes.total()
for group, value in sorted(sizes.items()):
    print(f'{group}: {value:,} bytes')
check(size < 1_000_000_000, f'Published site exceeds the 1 GB budget ({size:,} bytes)')
print(f'Verified {modules} modules, {declarations:,} declaration anchors, and {size:,} published bytes')
