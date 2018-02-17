OUT_DIR ?= docs
PORT    ?= 4000
THEME   ?= stackoverflow

RESUME     ?= node_modules/resume-cli/index.js
THEME_PATH ?= node_modules/jsonresume-theme-$(THEME)

RESUME_FLAGS ?= -t $(THEME) -p $(PORT) -d $(OUT_DIR)


GO ?= $(shell nix-build --no-out-link '<nixpkgs>' -A go)/bin/go

.PHONY: all bin/ym serve test theme watch


# all: $(OUT_DIR)/index.html
all: $(OUT_DIR)/resume.pdf


$(OUT_DIR)/index.html: $(RESUME) theme resume.json
	$(RESUME) export $(OUT_DIR)/index.html $(RESUME_FLAGS)


$(RESUME): node_modules


$(THEME_PATH): node_modules


bin/ym:
	@ mkdir -p bin
	@ ${GO} get github.com/iameli/ym
	${GO} build -o bin/ym github.com/iameli/ym


node_modules: package.json
	@ npm install


$(OUT_DIR)/resume.pdf: resume.tex resume-tweaked.yml resume.yml.patch
	pandoc --template $(filter-out $(lastword $^),$^) -o $@


resume.yml: resume.json # bin/ym
	@ echo "---"  >$@
	bin/ym <$< >>$@
	@ echo "---" >>$@


resume.yml.patch: resume.yml resume-tweaked.yml
	@ echo "git diff --no-index $^ >$@"
	@ git --no-pager diff --no-color --no-index $^ >$@ || exit 0
	@ test -f $@


serve: $(RESUME) theme
	$(RESUME) serve $(RESUME_FLAGS)


test: $(RESUME) resume.json
	$(RESUME) test


theme: $(THEME_PATH)


watch: serve
