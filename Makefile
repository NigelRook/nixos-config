default: build

SHELL := /usr/bin/env bash

.PHONY: system
build:
	nixos-rebuild build --flake .#

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake .#

.PHONY: boot
switch:
	sudo nixos-rebuild switch --flake .#

.PHONY: check-update
check-update:
	nix flake update .
	nixos-rebuild build --flake .#
	nix store diff-closures /run/current-system ./result
	rm result

.PHONY: build-elka
build-elka:
	nixos-rebuild build --flake .#elka

.PHONY: deploy-elka
deploy-elka:
	deploy .#elka --boot

.PHONY: deploy-elka-switch
deploy-elka-switch:
	deploy .#elka
