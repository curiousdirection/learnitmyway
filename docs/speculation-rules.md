# Speculation Rules

Sources: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/script/type/speculationrules, https://developer.mozilla.org/en-US/docs/Web/API/Speculation_Rules_API

- `<script type="speculationrules">` holds JSON with `prefetch` and/or `prerender` rule lists; browsers without support ignore it
- `"where": { "href_matches": "/*" }` is a document rule that applies to every same-origin link on the page
- `"eagerness": "moderate"` starts when there is a reasonable suggestion the user will follow a link, e.g. hovering or focusing it for some time
- `prefetch` only fetches the document into a per-document in-memory cache; `prerender` also runs the page's JavaScript in an invisible tab
- Prefetch is preferred here so the Cloudflare analytics beacon doesn't run for pages the reader never opens
- Chrome keeps prefetched pages for 5 minutes, so content can be up to 5 minutes stale
