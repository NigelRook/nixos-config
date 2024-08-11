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
    nixosConfigurations = nixpkgs.lib.genAttrs [
      "helmut"
    ] (hostName: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { networking.hostName = hostName; }
        ./hardware/${hostName}/hardware-configuration.nix
        ./hardware/${hostName}/hardware-extensions.nix

        ./configuration.nix

        ./archetypes/personal-laptop.nix
      ];
      specialArgs = { lanzaboote = lanzaboote; };
    });
  };
}
