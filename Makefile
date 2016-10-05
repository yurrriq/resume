OUT_DIR ?= docs
RESUME  ?= node_modules/resume-cli/index.js

PORT         ?= 4000
THEME        ?= elegant
RESUME_FLAGS ?= -t $(THEME) -p $(PORT) -d $(OUT_DIR)

all: $(OUT_DIR)/index.html

$(OUT_DIR)/index.html: resume.json
	$(RESUME) export $(OUT_DIR)/index.html $(RESUME_FLAGS)

serve: $(OUT_DIR)/index.html
	$(RESUME) serve $(RESUME_FLAGS)

.PHONY: watch
watch: serve
