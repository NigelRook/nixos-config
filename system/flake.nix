{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # home-manager, used for managing user configuration
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # fw-fanctrl = {
    #   url = "github:TamtamHero/fw-fanctrl/packaging/nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { nixpkgs, nixos-hardware, lanzaboote, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: hostModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit lanzaboote nixos-hardware inputs; };
        modules =
        [
          { networking.hostName = hostName; }
          ./hardware/${hostName}
          ./config/base.nix
        ] ++ hostModules;
      };
    in
    builtins.mapAttrs systemDef {
      helmut = [ ./archetypes/personal-laptop.nix ];
      boyd = [ ./archetypes/personal-laptop.nix ];
    };
  };
}
