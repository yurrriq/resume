OUT_DIR ?= docs
PORT    ?= 4000
THEME   ?= stackoverflow

RESUME     ?= node_modules/resume-cli/index.js
THEME_PATH ?= node_modules/jsonresume-theme-$(THEME)

RESUME_FLAGS ?= -t $(THEME) -p $(PORT) -d $(OUT_DIR)

.PHONY: theme serve watch

all: $(OUT_DIR)/index.html

node_modules: package.json
	@npm install

$(RESUME): node_modules

theme: $(THEME_PATH)

$(THEME_PATH): node_modules

$(OUT_DIR)/index.html: $(RESUME) theme resume.json
	$(RESUME) export $(OUT_DIR)/index.html $(RESUME_FLAGS)

serve: $(RESUME) theme
	$(RESUME) serve $(RESUME_FLAGS)

test: $(RESUME) resume.json
	$(RESUME) test

watch: serve
