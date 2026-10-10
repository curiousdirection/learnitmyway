.PHONY: \
	build \
	dev

build:
	hugo

dev:
	npx netlify dev
