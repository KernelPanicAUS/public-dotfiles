{
  config,
  pkgs,
  lib,
  self,
  system,
  ...
}: let
  common = import ../packages/common.nix {inherit pkgs;};
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
  imports = [./common.nix];

  environment.systemPackages = common.commonPackages ++ additionalPackages;
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
          "${pkgs.arc-browser}/Applications/Arc.app"
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
