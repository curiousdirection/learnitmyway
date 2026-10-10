.PHONY: \
	build \
	dev \
	postcss postcss/watch \

build: postcss
	hugo --minify

dev:
	npx parallelshell 'netlify dev' 'make postcss/watch'

postcss := npx postcss src/css/styles.css --dir assets/dist/ styles.css

postcss:
	${postcss}

postcss/watch:
	${postcss} --watch