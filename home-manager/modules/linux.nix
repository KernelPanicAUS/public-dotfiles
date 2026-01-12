{
  config,
  pkgs,
  lib,
  ...
}: {
  # Linux-specific home-manager configuration
  # Only applies when running on Linux
  # Desktop environment configs (i3/polybar) are in separate modules

  config = lib.mkIf pkgs.stdenv.isLinux {
    # GPG agent with GUI pinentry for X11
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3; # GUI pinentry for X11
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };
  };
}
