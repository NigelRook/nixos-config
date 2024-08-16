{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # home-manager, used for managing user configuration
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, lanzaboote, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: hostModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit lanzaboote nixos-hardware; };
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
