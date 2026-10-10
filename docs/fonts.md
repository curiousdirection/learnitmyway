# Fonts

Fonts are self-hosted from `static/fonts/` so no visitor data is sent to a font CDN (see `privacy-policy.md`).

## Source Serif 4 (body and headings)

- Variable font with `wght` (200–900) and `opsz` (8–60) axes. With `font-optical-sizing: auto` (the CSS default) the browser picks the optical size from the font size, so headings get the tighter display cut and body text the sturdier text cut. Source: [MDN font-optical-sizing](https://developer.mozilla.org/en-US/docs/Web/CSS/font-optical-sizing)
- Files `source-serif-4-latin-opsz-{normal,italic}.woff2` come from the npm package `@fontsource-variable/source-serif-4@5.2.8`, latin subset. Source: [Fontsource – Source Serif 4](https://fontsource.org/fonts/source-serif-4)
- License: SIL Open Font License 1.1, copy in `Licenses/SourceSerif4`. Source: [adobe-fonts/source-serif](https://github.com/adobe-fonts/source-serif)

## Inter (UI: navigation, dates, labels)

- Variable font with a `wght` axis (100–900).
- File `inter-latin-wght-normal.woff2` comes from the npm package `@fontsource-variable/inter@5.2.8`, latin subset. Source: [Fontsource – Inter](https://fontsource.org/fonts/inter)
- License: SIL Open Font License 1.1, copy in `Licenses/Inter`. Source: [rsms/inter](https://github.com/rsms/inter)

## Loading

- `@font-face` uses `font-display: swap` and the same latin `unicode-range` as Fontsource. Source: [MDN font-display](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)
- The two upright fonts are preloaded with `<link rel="preload" as="font" type="font/woff2" crossorigin>`; `crossorigin` is required for font preloads. Source: [MDN rel=preload](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/preload#cors-enabled_fetches)
