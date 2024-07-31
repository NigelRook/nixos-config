.PHONY: copy-sys
copy-sys:
	sudo cp system/*.nix /etc/nixos

.PHONY: rebuild-switch
rebuild-switch: copy-sys
	sudo nixos-rebuild switch

system/flake.lock: system/*.nix rebuild-switch
	cp /etc/nixos/flake.lock system

.PHONY: system
system: rebuild-switch system/flake.lock

PHONY: copy-home
copy-home:
	cp home/*.nix "${HOME}/.config/home-manager"

.PHONY: home-switch
home-switch: copy-home
	home-manager switch

home/flake.lock: home/*.nix home-switch
	cp "${HOME}/.config/home-manager/flake.lock" home

.PHONY: home
home: home-switch home/flake.lock
