{
  description = "Nigel's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/nixos-26.05";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, deploy-rs, nixos-hardware, lanzaboote, disko, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: attrs: nixpkgs.lib.nixosSystem {
        system = attrs.system;
        specialArgs = { inherit nixos-raspberrypi lanzaboote nixos-hardware disko inputs; };
        modules =
        [
          { networking.hostName = hostName; }
          disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.default
          ./hardware/${hostName}
          ./config/base.nix
        ] ++ attrs.modules;
      };
    in
    builtins.mapAttrs systemDef {
      boyd = { system = "x86_64-linux"; modules = [ ./archetypes/personal-laptop.nix ]; };
      elka = { system = "x86_64-linux"; modules = [ ./archetypes/server.nix ]; };
      bacon = { system = "aarch64-linux"; modules = [ ./archetypes/server.nix ]; };
    };

    deploy = let
      system = "x86_64-linux";
      # Unmodified nixpkgs
      pkgs = import nixpkgs { inherit system; };
      # nixpkgs with deploy-rs overlay but force the nixpkgs package
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlays.default
          (self: super: { deploy-rs = { inherit (pkgs) deploy-rs; lib = super.deploy-rs.lib; }; })
        ];
      };
    in {
      nodes.elka = {
        hostname = "elka";
        profiles.system = {
          sshUser = "nigel";
          user = "root";
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.elka;
        };
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
}
