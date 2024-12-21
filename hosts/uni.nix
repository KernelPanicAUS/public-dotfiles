{
  config,
  pkgs,
  lib,
  self,
  system,
  ...
}: let
  common = import ../packages/common.nix {inherit pkgs;};
  dervify = import ./dervify.nix {inherit pkgs;};

  alfred = dervify rec {
    pname = "Alfred";
    version = "5.5";
    url = "https://cachefly.alfredapp.com/${pname}_${version}.1_2273.dmg";
    hash = "sha256-BopF9IV/JOpu/aViwV4nDxivlQUZmN+K3+f1/7BaN6M=";
  };
  lulu = dervify rec {
    pname = "Lulu";
    version = "2.9.6";
    url = "https://github.com/objective-see/${pname}/releases/download/v${version}/${pname}_${version}.dmg";
    hash = "sha256-OagnURumn+Aw5XBEbdz0LSEuhc3abY8h+RlXarzKgBk=";
  };
  orbstack = dervify rec {
    pname = "Orbstack";
    version = "1.9.2";
    url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v1.9.2_18814_arm64.dmg";
    hash = "sha256-rNKfP6+vbxUGfzdYqy6F+iSn5XzZw1MN0EXL7odFvXI=";
    useHdiutil = true;
  };
  hammerspoon = dervify rec {
    pname = "hammerspoon";
    version = "1.0.0";
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/1.0.0/Hammerspoon-1.0.0.zip";
    hash = "sha256-XbcCtV2kfcMG6PWUjZHvhb69MV3fopQoMioK9+1+an4=";
    format = "zip";
  };
  _1password = dervify rec {
    pname = "1password";
    version = "8.10.48";
    url = "https://downloads.1password.com/mac/1Password-8.10.48-aarch64.zip";
    hash = "sha256-LZ56dIJ5vXJ1SbCI8hdeldKJwzkfM0Tp8d9eZ4tQ9/k=";
    format = "zip";
  };
  istat-menus = dervify rec {
    pname = "istat-menus";
    version = "7.02.15";
    url = "https://cdn.istatmenus.app/files/istatmenus7/versions/iStatMenus7.02.15.zip";
    hash = "sha256-TEDSNuUS3Xuqzqjo+rdJuVDXjtsFan6gnpTbQp2xDo0=";
    format = "zip";
  };
  additionalPackages = with pkgs;
    [lmstudio]
    ++ [
      lulu
      alfred
      orbstack
      hammerspoon
      _1password
      istat-menus
    ];
in {
  environment.systemPackages = common.commonPackages ++ additionalPackages;
  imports = [./common.nix];

  system = {
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Safari.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Messages.app"
          "/System/Applications/Calendar.app"
          "${pkgs.arc-browser}/Applications/Arc.app"
          "/Applications/Firefox.app"
          "${pkgs.slack}/Applications/Slack.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/TV.app"
        ];
      };
    };
  };
}
