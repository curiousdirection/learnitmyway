# lychee

Sources:

- https://github.com/lycheeverse/lychee/blob/lychee-v0.24.2/README.md (lychee 0.24.2)
- https://pypi.org/project/lychee-bin/0.24.2/ (lychee 0.24.2)

## Installing

- lychee publishes prebuilt binaries to PyPI as `lychee-bin`, so `pip install lychee-bin==0.24.2` puts a `lychee` executable on the path without needing Rust
- `requirements.txt` pins the version and lists the sha256 of the macOS (x86_64 and arm64) and manylinux (x86_64 and aarch64) wheels, which makes pip run in hash-checking mode
- `--only-binary :all:` stops pip falling back to the source distribution, which would need a Rust toolchain
- `make` installs it into `.venv` the first time a link check runs

## Options used

- `--offline` only checks local files and blocks network requests. Links to other sites are reported as excluded rather than as errors
- `--root-dir` is required for root-relative links such as `/css/main.css`, which Hugo emits when `baseURL` is `/`. It must be an absolute path
- `--remap` rewrites URLs that match a regex. Production builds use `baseURL = "https://learnitmyway.com/"` and posts link to `https://www.learnitmyway.com/...`, so both are remapped to `file://` paths in `public/` and checked offline
- `--index-files index.html` makes a directory link only valid when it contains an `index.html`. Without it, Hugo term pages that only had an `index.xml` passed
- `--include-fragments` also checks that the `#anchor` in a link exists on the target page
- lychee exits with code 2 when it finds broken links, which fails `make` and therefore the Netlify build
