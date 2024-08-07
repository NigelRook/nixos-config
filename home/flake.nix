{
  description = "Home Manager configuration of nigel";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }:
    {
      homeConfigurations."nigel@helmut" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./users/nigel.nix
          { nixpkgs.overlays = [ nur.overlay ]; }
          { nixpkgs.config.allowUnfree = true; }
          ./config/common.nix
          ./config/gnome-desktop.nix
          ./config/firefox.nix
          ./config/dev.nix
          ./config/gaming.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
