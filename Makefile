default: system

SHELL := /usr/bin/env bash

.PHONY: system
system:
	sudo nixos-rebuild switch --flake ./system

.PHONY: home
home:
	home-manager switch --flake ./home

.PHONY: fetch-update fetch-system-update fetch-home-update

fetch-update: fetch-system-update fetch-home-update

fetch-system-update:
	nix flake update ./system
	nixos-rebuild build --flake ./system
	nix store diff-closures /run/current-system ./result
	rm result

fetch-home-update:
	nix flake update ./home
	home-manager build --flake ./home
	nix store diff-closures "${HOME}/.local/state/nix/profiles/home-manager" ./result
	rm result

.PHONY: link-system link-home links

link: link-system link-home

link-system:
	@ set -e; \
	if [[ ! -L /etc/nixos ]]; then \
		if [[ ! -f "./system/hardware/$$(hostname)/hardware-configuration.nix" ]]; then \
			echo "Copying hardware-configuration.nix for $$(hostname)"; \
			mkdir -p "./system/hardware/$$(hostname)"; \
			cp "/etc/nixos/hardware-configuration.nix" "./system/hardware/$$(hostname)"; \
		fi; \
		if [[ -d /etc/nixos ]]; then \
			echo "Moving /etc/nixos to /etc/nixos.bak"; \
			sudo mv /etc/nixos /etc/nixos.bak; \
		fi; \
		echo "Linking /etc/nixos to ./system"; \
		sudo ln -s "$(abspath ./system)" /etc/nixos; \
	fi

link-home:
	@ set -e; \
	if [[ ! -L "${HOME}/.config/home-manager" ]]; then \
		if [[ -d "${HOME}/.config/home-manager" ]]; then \
			echo "Moving ~/.config/home-manager to ~/.config/home-manager.bak"; \
			sudo mv "${HOME}/.config/home-manager" "${HOME}/.config/home-manager.bak"; \
		fi; \
		echo "Linking ~/.config/home-manager to ./home"; \
		ln -s "$(abspath ./home)" "${HOME}/.config/home-manager"; \
	fi
