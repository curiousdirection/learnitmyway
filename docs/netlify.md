# Netlify

Source: https://docs.netlify.com/build/configure-builds/manage-dependencies/ (the docs page could not be fetched from the authoring environment)

- `NODE_VERSION` in `[build.environment]` of `netlify.toml` sets the Node version used during the build, including when Netlify installs its own build plugins into `.netlify/plugins/`
- The site has no `package.json`, but those plugins still need Node 18 or newer. Without `.nvmrc` or `NODE_VERSION` the deploy preview for this repo ran them on Node 8.17.0 and failed in the `esbuild` postinstall, before Hugo ran
