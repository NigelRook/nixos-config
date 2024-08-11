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
      homeConfigurations =
      let
        configDef = userHost: modules:
          let
            lib = nixpkgs.lib;
            parts = lib.strings.splitString "@" userHost;
            user = lib.lists.elemAt parts 0;
            userModulePath = ./users/${user}.nix;
            host = lib.lists.elemAt parts 1;
            hostModulePath = ./hosts/${host}.nix;
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages."x86_64-linux";

            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix

            modules = [
              nur.hmModules.nur
              {
                home.username = lib.mkDefault "${user}";
                home.homeDirectory = lib.mkDefault "/home/${user}";
              }
              ./config/common.nix
            ] ++ (
              if builtins.pathExists userModulePath
              then [ userModulePath ]
              else []
            ) ++ (
              if builtins.pathExists hostModulePath
              then [ hostModulePath ]
              else []
            ) ++ modules;
          };
      in
      builtins.mapAttrs configDef {
        "nigel@helmut" = [
          ./config/dev.nix
          ./config/gaming.nix
        ];
      };
    };
}
