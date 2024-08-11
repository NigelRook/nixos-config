{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # home-manager, used for managing user configuration
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { lanzaboote, nixpkgs, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: hostModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { lanzaboote = lanzaboote; };
        modules =
        let
          hardwareExtensionsPath = ./hardware/${hostName}/hardware-extensions.nix;
        in
        [
          { networking.hostName = hostName; }
          ./hardware/${hostName}/hardware-configuration.nix
          ./configuration.nix
        ] ++ (
          if (builtins.pathExists hardwareExtensionsPath)
          then [ hardwareExtensionsPath ]
          else []
        ) ++ hostModules;
      };
    in
    builtins.mapAttrs systemDef {
      helmut = [ ./archetypes/personal-laptop.nix ];
    };
  };
}
