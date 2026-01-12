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
  python3
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

  # Enable laptop power management
  services.tlp.enable = true;

  # Compositor to prevent screen tearing in i3
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    settings = {
      # Reduce input lag
      unredir-if-possible = true;
      # Better performance for Intel GPUs
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
    };
  };

  # Fonts for polybar and system
  fonts.packages = with pkgs; [
    font-awesome
    dejavu_fonts
    nerd-fonts.symbols-only
  ];
}
