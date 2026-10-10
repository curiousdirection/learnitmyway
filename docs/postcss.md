# PostCSS

Source: https://gohugo.io/functions/css/postcss/ (Hugo 0.147.9)

- `css.PostCSS` pipes a resource from `assets/` through the locally installed `postcss-cli`, using `postcss.config.js` from the project root
- `noMap` disables the inline source map
- `postcss-import` resolves `@import` from the project root, so `path: ["assets/css"]` is set in `postcss.config.js` to resolve `@import 'syntax.css'`

The docs page could not be fetched from the authoring environment; the behaviours above were confirmed by running `hugo` 0.147.9 locally and comparing the output with the previous `postcss-cli` output.
