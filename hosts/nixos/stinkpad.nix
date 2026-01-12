{
  config,
  pkgs,
  lib,
  self,
  user,
  ...
}: let
  common = import ../../packages/common.nix {inherit pkgs;};
  linux = import ../../packages/linux.nix {inherit pkgs;};
  host = with pkgs; [
    wget
    alejandra
    neovim
    htop
    neofetch
    git
    gh
    _1password-gui
    _1password-cli
    tailscale
    just
    cmake
    gnumake
    libtool
    kubectl
    k9s
    rofi
    feh
    fzf
    scrot
    claude-code
  ];
in {
  imports = [
    ../../modules/nixos/common.nix
    ./stinkpad-hardware.nix # Hardware configuration
  ];

  # Add flake-managed packages
  environment.systemPackages = lib.mkAfter (
    common.basePackages
    ++ linux.linuxPackages
    ++ host
  );

  # Hostname
  networking.hostName = "stinkpad";

  # Time zone specific to this host
  time.timeZone = "Europe/Berlin";
}
