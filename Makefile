.PHONY: \
	build \
	dev

build:
	hugo --minify

dev:
	hugo server -w
