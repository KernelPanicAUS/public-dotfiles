{ config, pkgs, pkgs-stable, lib, self, user, ... }:
let
  common = import ../../packages/common.nix { inherit pkgs pkgs-stable; };
  linux = import ../../packages/linux.nix { inherit pkgs pkgs-stable; };
in {
  imports = [
    ../../modules/nixos/common.nix
    ./stinkpad-hardware.nix  # Hardware configuration
  ];

  # Add flake-managed packages
  environment.systemPackages = lib.mkAfter (
    common.basePackages ++
    linux.linuxPackages
  );

  # Hostname
  networking.hostName = "stinkpad";

  # Time zone specific to this host
  time.timeZone = "Europe/Berlin";
}
