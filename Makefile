PACKAGES_DIR := packages
OUTPUT_DIR   := public
REPO_NAME    := odevsa
PKGBUILDS    := $(wildcard $(PACKAGES_DIR)/*/PKGBUILD)
PACKAGES     := $(patsubst $(PACKAGES_DIR)/%/PKGBUILD,%,$(PKGBUILDS))
IGNORED_PACKAGES := $(shell cat $(PACKAGES_DIR)/.ignore 2>/dev/null || true)

CLEAN_EXTENSIONS := install sh zip deb rpm AppImage 'tar.*' part desktop png xml

.PHONY: help build database update clean $(PACKAGES)

$(PACKAGES):
	@mkdir -p $(OUTPUT_DIR)
	@cp $(PACKAGES_DIR)/$@/sources/* $(PACKAGES_DIR)/$@ 2>/dev/null || true
	cd $(PACKAGES_DIR)/$@ && makepkg -s --noconfirm -c
	@mv $(PACKAGES_DIR)/$@/*.pkg.tar.zst $(OUTPUT_DIR)/ 2>/dev/null || true
	@for ext in $(CLEAN_EXTENSIONS); do \
		rm -f $(PACKAGES_DIR)/$@/*.$$ext; \
	done

build: clean $(filter-out $(IGNORED_PACKAGES),$(PACKAGES)) database

database:
	cd $(OUTPUT_DIR) && rm -f $(REPO_NAME).db* $(REPO_NAME).files* && repo-add $(REPO_NAME).db.tar.gz *.pkg.tar.zst

update:
	@for pkg in $(filter-out $(IGNORED_PACKAGES),$(PACKAGES)); do \
		if [ -f $(PACKAGES_DIR)/$$pkg/update ]; then \
			bash $(PACKAGES_DIR)/$$pkg/update; \
		fi; \
	done

clean:
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(PACKAGES_DIR)/*/{src,pkg}
	@for pkgdir in $(PACKAGES_DIR)/*; do \
		if [ -d $$pkgdir ]; then \
			for ext in $(CLEAN_EXTENSIONS); do \
				rm -f $$pkgdir/*.$$ext; \
			done; \
		fi; \
	done

help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  build        Build all packages and update repo database"
	@echo "  update       Update all packages versions"
	@echo "  clean        Remove built packages and output directories"
	@echo "  help         Show this help message"
	@echo "  <packages>   Build specific packages (see below)"
	@echo
	@echo "Package targets (build individual package):"
	@for p in $(PACKAGES); do \
		printf "  - %s\n" $$p; \
	done