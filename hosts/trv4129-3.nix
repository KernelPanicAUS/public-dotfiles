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
  aerospace = pkgs.stdenv.mkDerivation (self: {
    pname = "aerospace";
    version = "v0.15.2-Beta";
    src = pkgs.fetchzip {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/${self.version}/AeroSpace-${self.version}.zip";
      hash = "sha256-jOSUtVSiy/S4nsgvfZZqZjxsppqNi90edn8rcTa+pFQ=";
    };
    sourceRoot = "./source";
    installPhase = ''
      mkdir -p $out/Applications
      if [ -d AeroSpace.app ]; then
        cp -r AeroSpace.app $out/Applications/
      else
        echo "No .app bundles found to copy"
        ls -la
        exit 1
      fi
    '';
    meta.platforms = ["x86_64-darwin" "aarch64-darwin"];
  });
  additionalPackages = with pkgs; [
    lmstudio
    gdk
    aerospace
    rancher
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
          "${pkgs.zoom-us}/Applications/zoom.us.app"
          "/System/Applications/System Settings.app"
        ];
      };
    };
  };
}
