{
  config,
  pkgs,
  pkgs-stable,
  lib,
  self,
  system,
  ...
}: let
  common = import ../../packages/common.nix {inherit pkgs pkgs-stable;};
  darwin = import ../../packages/darwin.nix {inherit pkgs pkgs-stable;};
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
    core
    gsutil
    bq
  ]);
  additionalPackages = with pkgs; [
    gdk
    aerospace
    rancher
    kubernetes-helm
    kcat
  ];
in {
  imports = [../../modules/darwin/common.nix];

  environment.systemPackages = common.basePackages ++ darwin.darwinPackages ++ additionalPackages;
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "microsoft-office"
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
          "/Applications/Firefox.app"
          "${pkgs.slack}/Applications/Slack.app"
          "${pkgs.alacritty}/Applications/Alacritty.app"
          #"${pkgs.zoom-us}/Applications/zoom.us.app"
          "/System/Applications/System Settings.app"
        ];
      };
    };
  };
}
