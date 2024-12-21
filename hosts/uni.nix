{
  config,
  pkgs,
  lib,
  self,
  system,
  ...
}: let
  common = import ../packages/common.nix {inherit pkgs;};
  additionalPackages = with pkgs; [lmstudio];
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
