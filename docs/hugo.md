# Hugo

## absURL

Source: https://gohugo.io/functions/urls/absurl/ (Hugo 0.147.9)

- `absURL` returns an absolute URL built from the site's `baseURL`
- An input that is already an absolute URL (such as a post's Cloudinary `shareImage`) is returned unchanged
- `baseURL` is overridden per deploy context in `netlify.toml`, so `og:image` points at the right host for previews and production

## Generated share images

Sources: https://gohugo.io/functions/images/text/, https://gohugo.io/functions/images/overlay/, https://gohugo.io/methods/resource/crop/ (Hugo 0.147.9), https://github.com/gohugoio/hugo/blob/v0.147.9/resources/images/text.go

- `images.Text TEXT OPTIONS` returns a filter that draws text with a TrueType `font` resource at `size` px, `color`, `x`/`y` offset and `linespacing` px between lines
- `alignx` (0.141.0+) and `aligny` (0.147.0+) accept `center`, so a title can be centred on its `x`/`y` point
- Text wraps on spaces; with `alignx "center"` the wrap width is `min(imageWidth - 20 - x, x) * 2`, so a full-width canvas wraps almost edge to edge
- `.Crop "WxH Center"` cuts a region without resizing; cropping the empty middle of `share-base.png` gives a narrower canvas so the title wraps with margins
- `images.Overlay RESOURCE X Y` draws a resource on top of the image at the given offset from the top left
- `images.Filter` / `.Filter` apply filters and the result is cached under `resources/_gen`
- The font is Inter Bold 4.1 from https://github.com/rsms/inter/releases/tag/v4.1 (SIL Open Font License, see `Licenses/Inter`)

## Image render hook

Source: https://github.com/gohugoio/hugo/blob/v0.147.9/docs/content/en/render-hooks/images.md (Hugo 0.147.9)

- `layouts/_default/_markup/render-image.html` overrides how every Markdown image (`![alt](src "title")`) is rendered to HTML
- The context provides `.Destination`, `.PlainText`, `.Text`, `.Title`, `.IsBlock`, `.Ordinal` and `.Page`
- Use `{{- -}}` to trim whitespace, since images are inline elements
- Hugo's embedded image render hook is disabled by default, and a custom render hook overrides it anyway
