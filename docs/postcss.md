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
