{
  description = "Thomas's nix darwin and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    mac-app-util,
    home-manager,
    nixpkgs,
    nixpkgs-stable,
    determinate,
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
    };

    uniConfiguration = {pkgs, ...}: {
      imports = [./hosts/uni.nix];
    };

    workConfiguration = {pkgs, ...}: let
    in {
      imports = [./hosts/trv4129-3.nix];
    };
    userConfiguration = {...}: {
      users.users.tkhalil = {
        name = "tkhalil";
        home = "/Users/tkhalil";
      };

      home-manager.users.tkhalil = {pkgs, ...}: {
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        imports = [./home-manager/home.nix];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#trv4129
    darwinConfigurations."uni" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        determinate.darwinModules.default
        uniConfiguration
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # inherit user;
            enable = true;
            user = "tkhalil";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
            enableRosetta = true;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
        userConfiguration
      ];
    };

    darwinConfigurations."trv4129-3" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        determinate.darwinModules.default
        workConfiguration
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # inherit user;
            enable = true;
            user = "tkhalil";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
            enableRosetta = true;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
        userConfiguration
      ];
    };
  };
}
