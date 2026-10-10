# Hugo

## absURL

Source: https://gohugo.io/functions/urls/absurl/ (Hugo 0.147.9)

- `absURL` returns an absolute URL built from the site's `baseURL`
- An input that is already an absolute URL (such as a post's Cloudinary `shareImage`) is returned unchanged
- `baseURL` is overridden per deploy context in `netlify.toml`, so `og:image` points at the right host for previews and production

## disableKinds

Source: https://gohugo.io/configuration/all/#disablekinds and https://gohugo.io/configuration/taxonomies/ (Hugo 0.147.9)

- Disabling the taxonomy system needs both the `taxonomy` and `term` kinds
- With only `taxonomy` disabled, Hugo still published an RSS feed and a sitemap entry for each tag and category, but `layouts/_default/list.html` is empty so the linked page had no HTML

## cleanDestinationDir

Source: https://gohugo.io/commands/hugo/ (Hugo 0.147.9)

- `--cleanDestinationDir` removes stale files from `public/`, so a page that no longer exists can't hide a broken link from the link check
