.PHONY: \
	build \
	check-internal-links \
	check-links \
	dev

LYCHEE := .venv/bin/lychee
LYCHEE_ARGS := \
	--root-dir $(CURDIR)/public \
	--remap '^https?://(www\.)?learnitmyway\.com/(.*)$$ file://$(CURDIR)/public/$$2' \
	--index-files index.html \
	--include-fragments \
	--no-progress

build:
	hugo --minify --cleanDestinationDir

dev:
	hugo server -w

check-internal-links: $(LYCHEE)
	$(LYCHEE) --offline $(LYCHEE_ARGS) public

check-links: build $(LYCHEE)
	$(LYCHEE) $(LYCHEE_ARGS) public

$(LYCHEE): requirements.txt
	python3 -m venv .venv
	.venv/bin/pip install --only-binary :all: --require-hashes -r requirements.txt
	touch $@
