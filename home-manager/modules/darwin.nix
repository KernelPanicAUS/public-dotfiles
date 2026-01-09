{ config, pkgs, lib, ... }:
{
  # macOS-specific home-manager configuration
  # Only applies when running on Darwin

  config = lib.mkIf pkgs.stdenv.isDarwin {
    # GPG agent with macOS keychain integration
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry_mac;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };

    # Add other macOS-specific home config here as needed
  };
}
