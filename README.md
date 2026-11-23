# Learn it my way

[![Netlify Status](https://api.netlify.com/api/v1/badges/1bd82c76-3450-45aa-b7b4-cf16ea67e647/deploy-status)](https://app.netlify.com/sites/learnitmyway/deploys)

This is the source code for [my website](https://www.learnitmyway.com).
[Hugo](https://gohugo.io/) is used as a static site generator and it is hosted by [Netlify](https://www.netlify.com/).

## Local development

- `mise install` (installs Hugo; keep the version in sync with `netlify.toml`)
- `make dev`

## Link checking

The Netlify build runs `make build check-internal-links`, which fails the deploy if a link between pages on the site is broken. Links to other sites are only checked locally with `make check-links`, since external sites can be down or rate limit. Both need `python3` to install [lychee](https://github.com/lycheeverse/lychee) (see `docs/lychee.md`).

## Useful commands

- Add new post: `hugo new post/my-first-post.md`

## Content License

[CC BY-SA](http://creativecommons.org/licenses/by-sa/4.0/)

## Software License

[MIT](https://opensource.org/licenses/MIT)

## Disclaimers

- Licenses for Software that has been dealt in can be found in the Licenses directory