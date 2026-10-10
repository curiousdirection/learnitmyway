# Hugo

## absURL

Source: https://gohugo.io/functions/urls/absurl/ (Hugo 0.147.9)

- `absURL` returns an absolute URL built from the site's `baseURL`
- An input that is already an absolute URL (such as a post's Cloudinary `shareImage`) is returned unchanged
- `baseURL` is overridden per deploy context in `netlify.toml`, so `og:image` points at the right host for previews and production
