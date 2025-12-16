{
  description = "Nigel's NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    # Temporary fix for lanzaboote/rust-overlay issue
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?rev=26531fc46ef17e9365b03770edd3fb9206fcb460";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, deploy-rs, nixos-hardware, lanzaboote, disko, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = let
      systemDef = hostName: hostModules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit lanzaboote nixos-hardware disko inputs; };
        modules =
        [
          { networking.hostName = hostName; }
          disko.nixosModules.disko
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.default
          ./hardware/${hostName}
          ./config/base.nix
        ] ++ hostModules;
      };
    in
    builtins.mapAttrs systemDef {
      boyd = [ ./archetypes/personal-laptop.nix ];
      elka = [ ./archetypes/server.nix ];
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
          interactiveSudo = true;
          path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.elka;
        };
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
