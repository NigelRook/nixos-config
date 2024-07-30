{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/NUR;
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, lanzaboote, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.helmut = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = [ nur.overlay ]; }
        lanzaboote.nixosModules.lanzaboote

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix

        ./secure-boot.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        # home-manager.nixosModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;

        #   home-manager.users.nigel = import ./home.nix;

        #   # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
        # }
      ];
    };
  };
}
