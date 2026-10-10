# Hugo CSS pipeline

Source: https://gohugo.io/functions/resources/concat/ (Hugo 0.147.9)

- `resources.Concat "css/main.css"` joins a slice of resources from `assets/` into one resource, in slice order
- `minify` is applied only when `hugo.IsProduction`
- Nesting, custom properties and `color-mix()` are left untouched and handled by the browser

The docs page could not be fetched from the authoring environment (gohugo.io is blocked); the behaviours above were confirmed by running `hugo` 0.147.9 locally.

# normalize.css

Source: https://github.com/necolas/normalize.css/blob/8.0.1/normalize.css

- `assets/css/normalize.css` is a copy of v8.0.1 (MIT, licence in `Licenses/normalize.css/`)
