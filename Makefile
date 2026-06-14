PACKAGES_DIR := packages
OUTPUT_DIR   := public
REPO_NAME    := odevsa
PKGBUILDS    := $(wildcard $(PACKAGES_DIR)/*/PKGBUILD)
PACKAGES     := $(patsubst $(PACKAGES_DIR)/%/PKGBUILD,%,$(PKGBUILDS))
IGNORED_PACKAGES := $(shell cat $(PACKAGES_DIR)/.ignore 2>/dev/null || true)

.PHONY: help build database update clean $(PACKAGES)

$(PACKAGES):
	@mkdir -p $(OUTPUT_DIR)
	@cp $(PACKAGES_DIR)/$@/sources/* $(PACKAGES_DIR)/$@ 2>/dev/null || true
	cd $(PACKAGES_DIR)/$@ && makepkg -s --noconfirm -c
	@mv $(PACKAGES_DIR)/$@/*.pkg.tar.zst $(OUTPUT_DIR)/ 2>/dev/null || true
	@rm -f $(PACKAGES_DIR)/$@/*.zip
	@rm -f $(PACKAGES_DIR)/$@/*.deb
	@rm -f $(PACKAGES_DIR)/$@/*.rpm
	@rm -f $(PACKAGES_DIR)/$@/*.AppImage
	@rm -f $(PACKAGES_DIR)/$@/*.tar.*

build: clean $(filter-out $(IGNORED_PACKAGES),$(PACKAGES)) database html

database:
	cd $(OUTPUT_DIR) && repo-add $(REPO_NAME).db.tar.gz *.pkg.tar.zst

update:
	@for pkg in $(PACKAGES); do \
		if [ -f $(PACKAGES_DIR)/$$pkg/update.sh ]; then \
			bash $(PACKAGES_DIR)/$$pkg/update.sh; \
		fi; \
	done

clean:
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(PACKAGES_DIR)/*/{src,pkg}
	@rm -f $(PACKAGES_DIR)/*/*.zip
	@rm -f $(PACKAGES_DIR)/*/*.deb
	@rm -f $(PACKAGES_DIR)/*/*.rpm
	@rm -f $(PACKAGES_DIR)/*/*.AppImage
	@rm -f $(PACKAGES_DIR)/*/*.tar.*

html:
	@echo "<html>" > $(OUTPUT_DIR)/index.html
	@echo "<head>" >> $(OUTPUT_DIR)/index.html
	@echo "<title>Arch Repo</title>" >> $(OUTPUT_DIR)/index.html
	@echo "<link rel=\"icon\" type=\"image/png\" href=\"https://archlinux.org/static/archlinux_common_style/favicon.png\" />" >> $(OUTPUT_DIR)/index.html
	@echo "</head>" >> $(OUTPUT_DIR)/index.html
	@echo "<body>" >> $(OUTPUT_DIR)/index.html
	@for pkg in $(wildcard $(OUTPUT_DIR)/*.pkg.tar.zst); do \
		pkgname=$$(basename $$pkg); \
		echo "<a href=\"$$pkgname\">$$pkgname</a><br />" >> $(OUTPUT_DIR)/index.html; \
	done
	@echo "</body>" >> $(OUTPUT_DIR)/index.html
	@echo "</html>" >> $(OUTPUT_DIR)/index.html


help:
	@echo "Usage: make <target>"
	@echo
	@echo "Available targets:"
	@echo "  build        Build all packages and update repo database"
	@echo "  update       Update all packages versions"
	@echo "  clean        Remove built packages and output directories"
	@echo "  html         Generate HTML index of packages"
	@echo "  help         Show this help message"
	@echo "  <packages>   Build specific packages (see below)"
	@echo
	@echo "Package targets (build individual package):"
	@for p in $(PACKAGES); do \
		printf "  - %s\n" $$p; \
	done