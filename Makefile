.PHONY: system
system:
	sudo nixos-rebuild switch --flake ./system

.PHONY: home
home:
	home-manager switch --flake ./home
