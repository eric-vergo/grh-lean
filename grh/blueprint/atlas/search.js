// SPDX-License-Identifier: Apache-2.0
// Authors: Eric Vergo, GPT-6.2 (OpenAI)
const form = document.querySelector('form');
const field = document.querySelector('#q');
const hits = document.querySelector('#hits');
const status = document.querySelector('#status');
let catalog;
let sequence = 0;
async function search() {
  const request = ++sequence;
  const term = field.value.trim().toLowerCase();
  hits.replaceChildren();
  status.textContent = '';
  if (!term) return;
  try {
    catalog ??= fetch('catalog.json').then(response => {
      if (!response.ok) throw Error(response.status);
      return response.json();
    });
    const rows = await catalog;
    if (request !== sequence) return;
    let count = 0;
    function match(label, module, fragment = '') {
      if (!label.toLowerCase().includes(term)) return;
      count++;
      if (count > 150) return;
      const link = document.createElement('a');
      link.href = encodeURIComponent(module) + '.html' + fragment;
      link.textContent = label;
      const item = document.createElement('li');
      item.append(link);
      if (fragment) item.append(' · ' + module);
      hits.append(item);
    }
    for (const [module, names] of rows) {
      match(module,module);
      for (const name of names) match(name,module,'#d-' + encodeURIComponent(name));
    }
    status.textContent = count > 150 ? 'Showing the first 150 of ' + count + ' matches. Refine your search to see fewer results.' : count + ' matches.';
  } catch {
    catalog = undefined;
    status.textContent = 'The search index could not be loaded. You can still browse the modules below.';
  }
}
form.addEventListener('submit', event => {
  event.preventDefault();
  const url = new URL(location.href);
  url.searchParams.set('q',field.value);
  history.replaceState(null,'',url);
  search();
});
field.addEventListener('input',search);
field.value = new URLSearchParams(location.search).get('q') ?? '';
search();
