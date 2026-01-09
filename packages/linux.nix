{ pkgs, pkgs-stable ? pkgs, ... }:
let
  linuxPackages = with pkgs; [
    pinentry-curses  # Configurable: change to pinentry-gnome3 or pinentry-qt per host
    # Add Linux-specific packages here as needed
  ];
in {
  inherit linuxPackages;
}
