# PostCSS

Source: https://gohugo.io/functions/css/postcss/ (Hugo 0.147.9)

- `css.PostCSS` pipes a resource from `assets/` through the locally installed `postcss-cli`, using `postcss.config.js` from the project root
- `noMap` disables the inline source map
- `postcss-import` resolves `@import` from the project root, so `path: ["assets/css"]` is set in `postcss.config.js` to resolve `@import 'syntax.css'`

The docs page could not be fetched from the authoring environment; the behaviours above were confirmed by running `hugo` 0.147.9 locally and comparing the output with the previous `postcss-cli` output.

## postcss-preset-env features

Source: https://github.com/csstools/postcss-preset-env/blob/6.7.0/README.md#features (postcss-preset-env 6.7.0, also in `node_modules/postcss-preset-env/README.md`)

- The `features` option enables or disables specific polyfills by ID; `false` disables one
- With `stage: 0`, `focus-visible-pseudo-class` rewrites `:focus-visible` to `.focus-visible`, which only works with the focus-visible JS polyfill. It is disabled so the native `:focus-visible` selector reaches the browser
- `prefers-color-scheme-query` (css-prefers-color-scheme 3.1.1, see `node_modules/css-prefers-color-scheme/README.md` or https://github.com/csstools/css-prefers-color-scheme/blob/v3.1.1/README.md) adds a `(color-index: 48)` copy of every `prefers-color-scheme: dark` query, which only does something with its JS polyfill. It is disabled so only the native query is output

## Chroma syntax styles

Source: `hugo gen chromastyles --help` (Hugo 0.147.9), https://gohugo.io/commands/hugo_gen_chromastyles/

- `hugo gen chromastyles --style=<name>` prints the stylesheet for a Chroma style; the default style is `friendly`, which is what `assets/css/syntax.css` contains
- `--omitEmpty` leaves out empty rules
- `assets/css/syntax-dark.css` is the `github-dark` output wrapped in `@media (prefers-color-scheme: dark)`, plus `.na` and `.nb` which `friendly` colours but `github-dark` does not
