{
  description = "Thomas's nix darwin and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

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
  } @ inputs: let
    system = "aarch64-darwin";
    user = "tkhalil";
    pkgs-stable = import nixpkgs-stable {inherit system;};

    generateSystemDerivation = systemName:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit self;};
        modules = [
          (import ./hosts/${systemName}.nix)
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              inherit user;
              enable = true;
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
          (_: {
            users.users.${user} = {
              name = user;
              home = "/Users/${user}";
            };

            home-manager.users.${user} = {pkgs, ...}: {
              imports = [./home-manager/home.nix];
            };
          })
        ];
      };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#trv4129
    darwinConfigurations = {
      "uni" = generateSystemDerivation "uni";
      "trv4129-3" = generateSystemDerivation "trv4129-3";
    };
  };
}
