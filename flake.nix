{
  description = "Thomas's multi-platform nix configuration (macOS + NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Darwin-specific inputs
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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

    # Shared inputs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
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
    # User configuration
    user = "tkhalil";

    # Helper: Generate per-system pkgs
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    mkPkgsStable = system: import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    # Helper: Build Darwin system
    mkDarwinSystem = { systemName, system ? "aarch64-darwin" }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit self user;
          pkgs-stable = mkPkgsStable system;
        };
        modules = [
          ./hosts/darwin/${systemName}.nix
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
          {
            users.users.${user} = {
              name = user;
              home = "/Users/${user}";
            };

            home-manager.users.${user} = {
              imports = [ ./home-manager/home.nix ];
            };
          }
        ];
      };

    # Helper: Build NixOS system
    mkNixOSSystem = { systemName, system ? "x86_64-linux" }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self user;
          pkgs-stable = mkPkgsStable system;
        };
        modules = [
          ./hosts/nixos/${systemName}.nix
          determinate.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = {
              imports = [ ./home-manager/home.nix ];
            };
          }
        ];
      };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#uni
    # $ darwin-rebuild build --flake .#trv4129-3
    darwinConfigurations = {
      "uni" = mkDarwinSystem { systemName = "uni"; };
      "trv4129-3" = mkDarwinSystem { systemName = "trv4129-3"; };
    };

    # Build nixos flake using:
    # $ nixos-rebuild build --flake .#stinkpad
    nixosConfigurations = {
      "stinkpad" = mkNixOSSystem {
        systemName = "stinkpad";
        system = "x86_64-linux";
      };
    };
  };
}
