{ config, pkgs, lib, ... }:
{
  # Linux-specific home-manager configuration
  # Only applies when running on Linux

  config = lib.mkIf pkgs.stdenv.isLinux {
    # GPG agent with terminal-based pinentry (customizable per host)
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-curses;  # or pinentry-gnome3, pinentry-qt
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };

    # Add other Linux-specific home config here as needed
    # For i3 users: could add rofi, feh, etc. configs here
  };
}
