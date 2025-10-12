{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, lanzaboote, disko, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: hostModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit lanzaboote nixos-hardware disko inputs; };
        modules =
        [
          { networking.hostName = hostName; }
          disko.nixosModules.disko
          ./hardware/${hostName}
          ./config/base.nix
        ] ++ hostModules;
      };
    in
    builtins.mapAttrs systemDef {
      boyd = [ ./archetypes/personal-laptop.nix ];
      elka = [ ./archetypes/server.nix ];
    };
  };
}
