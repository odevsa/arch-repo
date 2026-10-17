# Arch Repo - Makefile wrapper forwarding to just (https://github.com/casey/just)
# All canonical tasks are defined in justfile.

.PHONY: default
default:
	@just

ifeq (install,$(firstword $(MAKECMDGOALS)))
  INSTALL_ARG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(INSTALL_ARG):;@:)
endif

install:
	@just install $(INSTALL_ARG)

ifeq (update,$(firstword $(MAKECMDGOALS)))
  UPDATE_ARG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(UPDATE_ARG):;@:)
endif

update:
	@just update $(UPDATE_ARG)

ifeq (build,$(firstword $(MAKECMDGOALS)))
  BUILD_ARG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(BUILD_ARG):;@:)
endif

build:
	@just build $(BUILD_ARG)

ifeq (version,$(firstword $(MAKECMDGOALS)))
  VERSION_ARG := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(VERSION_ARG):;@:)
endif

version:
	@just version $(VERSION_ARG)

%:
	@if [ -d "packages/$@" ] && [ -f "packages/$@/PKGBUILD" ]; then \
		just build "$@"; \
	else \
		just "$@"; \
	fi