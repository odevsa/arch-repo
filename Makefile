PACKAGES_DIR := packages
OUTPUT_DIR   := public
REPO_NAME    := odevsa
PKGBUILDS    := $(wildcard $(PACKAGES_DIR)/*/PKGBUILD)
PACKAGES     := $(patsubst $(PACKAGES_DIR)/%/PKGBUILD,%,$(PKGBUILDS))

.PHONY: help build database clean $(PACKAGES)

$(PACKAGES):
	@mkdir -p $(OUTPUT_DIR)
	cd $(PACKAGES_DIR)/$@ && makepkg -s --noconfirm -c
	@mv $(PACKAGES_DIR)/$@/*.pkg.tar.zst $(OUTPUT_DIR)/ 2>/dev/null || true
	@rm -f $(PACKAGES_DIR)/$@/*.deb
	@rm -f $(PACKAGES_DIR)/$@/*.rpm
	@rm -f $(PACKAGES_DIR)/$@/*.AppImage
	@rm -f $(PACKAGES_DIR)/$@/*.tar.*

build: clean $(PACKAGES) database html

database:
	cd $(OUTPUT_DIR) && repo-add $(REPO_NAME).db.tar.gz *.pkg.tar.zst

clean:
	@rm -rf $(OUTPUT_DIR)
	@rm -rf $(PACKAGES_DIR)/*/{src,pkg}
	@rm -f $(PACKAGES_DIR)/*/*.deb
	@rm -f $(PACKAGES_DIR)/*/*.rpm
	@rm -f $(PACKAGES_DIR)/*/*.AppImage
	@rm -f $(PACKAGES_DIR)/*/*.tar.*

html:
	@echo "<html>" > $(OUTPUT_DIR)/index.html
	@echo "<head><title>Arch Repo</title></head>" >> $(OUTPUT_DIR)/index.html
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
	@echo "  clean        Remove built packages and output directories"
	@echo "  html         Generate HTML index of packages"
	@echo "  help         Show this help message"
	@echo "  <packages>   Build specific packages (see below)"
	@echo
	@echo "Package targets (build individual package):"
	@for p in $(PACKAGES); do \
		printf "  - %s\n" $$p; \
	done