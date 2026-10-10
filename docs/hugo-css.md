# Hugo CSS pipeline

Source: https://gohugo.io/functions/resources/concat/ (Hugo 0.147.9)

- `resources.Concat "css/main.css"` joins a slice of resources from `assets/` into one resource, in slice order
- `minify` is applied only when `hugo.IsProduction`
- Nesting, custom properties and `color-mix()` are left untouched and handled by the browser

The docs page could not be fetched from the authoring environment (gohugo.io is blocked); the behaviours above were confirmed by running `hugo` 0.147.9 locally.

# Chroma syntax styles

Source: `hugo gen chromastyles --help` (Hugo 0.147.9), https://gohugo.io/commands/hugo_gen_chromastyles/

- `hugo gen chromastyles --style=<name>` prints the stylesheet for a Chroma style; `--omitEmpty` leaves out empty rules
- `assets/css/syntax.css` is the unmodified `github` output
- `assets/css/syntax-dark.css` is the `github-dark --omitEmpty` output with comments and the `.bg` rule removed, every selector scoped twice so it applies in dark mode: under `:root:not([data-theme="light"])` inside `@media (prefers-color-scheme: dark)`, and under `:root[data-theme="dark"]` for the theme toggle. The `.chroma` background is dropped so `--code-background` from `styles.css` applies, and `.na`, `.nx`, `.nb`, `.bp` and `.p`, which `github` colours but `github-dark` does not, are reset to the `github-dark` text colour
