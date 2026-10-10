.PHONY: \
	build \
	dev

build:
	hugo --minify

dev:
	npx netlify dev
