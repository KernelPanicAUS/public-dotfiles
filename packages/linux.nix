{ pkgs, pkgs-stable ? pkgs, ... }:
let
  linuxPackages = with pkgs; [
    pinentry-qt  # Configurable: change to pinentry-gnome3 or pinentry-qt per host
    ghostty
    # Add Linux-specific packages here as needed
  ];
in {
  inherit linuxPackages;
}
