.DEFAULT_GOAL := all

SHELL := $(shell command -v bash)

makefile := $(abspath $(lastword $(MAKEFILE_LIST)))
makefile_dir := $(dir $(makefile))

root := $(makefile_dir)
repo := $(patsubst %/,%,$(root))

host ?= vm-aarch64
user ?= sasaplus1

#-------------------------------------------------------------------------------

.PHONY: all
all: ## output targets
	@grep -E '^[a-zA-Z_-][0-9a-zA-Z_-]+:.*?## .*$$' $(makefile) | awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

.PHONY: setup
setup: setup-hardware
setup: setup-password
setup: setup-switch
setup: ## apply this configuration to the running NixOS

.PHONY: setup-hardware
setup-hardware: ## [subtarget] import generated hardware-configuration.nix
	cp /etc/nixos/hardware-configuration.nix '$(root)hosts/$(host)/'
	git -C '$(repo)' add 'hosts/$(host)/hardware-configuration.nix'

.PHONY: setup-password
setup-password: ## [subtarget] reuse the current password hash
	sudo mkdir -p /etc/passwords
	getent shadow '$(user)' | cut -d: -f2 | sudo tee '/etc/passwords/$(user)' > /dev/null
	sudo chmod 600 '/etc/passwords/$(user)'

.PHONY: setup-switch
setup-switch: ## [subtarget] switch to the new configuration
	sudo nixos-rebuild switch --flake '$(repo)#$(host)' --option extra-experimental-features 'nix-command flakes'

.PHONY: test
test: test-parse
test: ## verify files

.PHONY: test-parse
test-parse: ## [subtarget] check syntax of nix files
	find '$(root)' -name '*.nix' -not -path '*/.git/*' -print0 | xargs -0 nix-instantiate --parse > /dev/null
