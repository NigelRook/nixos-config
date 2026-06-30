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

  outputs = { self, nixpkgs, nixos-raspberrypi, deploy-rs, nixos-hardware, lanzaboote, disko, ... }@inputs:
  let
    hardware = {
      boyd = {
        system = "x86_64-linux";
        modules = [ ./archetypes/personal-laptop.nix ];
      };
      elka = {
        system = "x86_64-linux";
        modules = [ ./archetypes/server.nix ];
      };
      bacon = {
        system = "aarch64-linux";
        modules = [ ./archetypes/server.nix ];
      };
      ford = {
        system = "x86_64-linux";
        modules = [ ./archetypes/server.nix ];
      };
    };

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

    deployNode = hostName: attrs: let
      system = attrs.system;
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
    in
    {
      hostname = hostName;
      profiles.system = {
        sshUser = "nigel";
        user = "root";
        remoteBuild = true;
        path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.${hostName};
      };
    };
  in
  {
    nixosConfigurations = builtins.mapAttrs systemDef hardware;
    deploy.nodes = builtins.mapAttrs deployNode hardware;
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
