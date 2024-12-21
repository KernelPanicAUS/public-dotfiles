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
  additionalPackages = with pkgs; [lmstudio] ++ [lulu alfred orbstack];
in {
  environment.systemPackages = common.commonPackages ++ additionalPackages;
  imports = [./common.nix];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    taps = [];
    brews = ["aria2"];
    casks = [
      "1password"
      "istat-menus"
      "orbstack"
      "hammerspoon"
    ];
  };

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
