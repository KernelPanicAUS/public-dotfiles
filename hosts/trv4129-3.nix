{
  config,
  pkgs,
  lib,
  self,
  system,
  ...
}: {
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
      "microsoft-office"
      "alfred"
      "istat-menus"
      "lulu"
      "orbstack"
      "hammerspoon"
      "caffeine"
    ];
  };

  system = {
    defaults = {
      dock = {
        persistent-apps = [
          "/Applications/Safari.app"
          "/Applications/Microsoft Outlook.app"
          "/Applications/Google Chrome.app"
          "${pkgs.arc-browser}/Applications/Arc.app"
          "/Applications/Firefox.app"
          "${pkgs.slack}/Applications/Slack.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "${pkgs.zoom-us}/Applications/zoom.us.app"
          "/System/Applications/System Settings.app"
        ];
      };
    };
  };
}
