{
  config,
  pkgs,
  pkgs-stable,
  lib,
  self,
  system,
  ...
}: let
  common = import ../packages/common.nix {inherit pkgs pkgs-stable;};
  dervify = import ../packages/dervify.nix {inherit pkgs;};
  notion = dervify rec {
    pname = "Notion";
    # renovate: datasource=notion-releases depName=Notion
    version = "4.2.0";
    url = "https://desktop-release.notion-static.com/${pname}-${version}-universal.dmg";
    hash = "sha256-+s31ix5Ce4JNqbPDKBrWxz+3YR5QNv/CKLHLXrxsIao=";
    format = "dmg";
  };
  additionalPackages = with pkgs; [mas notion];
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
          "/Applications/Firefox.app"
          "${pkgs.slack}/Applications/Slack.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "/Applications/Nix Trampolines/Notion.app"
          "/Applications/Nix Trampolines/Ghostty.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/TV.app"
        ];
      };
    };
  };
}
