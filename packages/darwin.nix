{ pkgs, pkgs-stable ? pkgs, ... }:
let
  dervify = import ./darwin-dmg.nix { inherit pkgs; };

  # macOS DMG/ZIP applications
  lulu = dervify rec {
    pname = "Lulu";
    version = "4.3.2";
    url = "https://github.com/objective-see/${pname}/releases/download/v${version}/${pname}_${version}.dmg";
    hash = "sha256-ZR2FU5y3AIszuFcSFai4BA9PJtdzBmdenIlyKUqA9UE=";
  };

  orbstack = dervify rec {
    pname = "Orbstack";
    version = "2.2.0";
    url = "https://orbstack.dev/download/stable/latest/arm64";
    hash = "sha256-W8FxnDyYfExgxlvp/dZbRzCZDhaX7Byxwz5rujG/krU=";
    useHdiutil = true;
  };

  hammerspoon = dervify rec {
    pname = "hammerspoon";
    version = "1.1.1";
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    hash = "sha256-EbsckPr1Qn83x71P5+q5d0rkPh1csCDFswiNrDKEnvo=";
    format = "zip";
  };

  _1password = dervify rec {
    pname = "1password";
    version = "8.12.22";
    url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
    hash = "sha256-Rbac0JcB2kbH6EfEGkuKwhaIW0Bgkhyw7olSjqe1euE=";
    format = "zip";
  };

  istat-menus = dervify rec {
    pname = "istat-menus";
    version = "7.30";
    url = "https://cdn.istatmenus.app/files/istatmenus7/versions/iStatMenus${version}.zip";
    hash = "sha256-qCgMEUjHUsEP+B+e2nylse9T/Xnt765RzV0WtBSWSPY=";
    format = "zip";
  };

  ghostty = dervify rec {
    version = "1.3.1";
    pname = "Ghostty";
    url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
    hash = "sha256-GM/ysKbO6Q7q2cfTBk6AiiUqQLryFKp1LB7LeTuPX2k=";
    useHdiutil = true;
  };

  darwinPackages = with pkgs; [
    bartender
    pinentry_mac
  ] ++ [
    lulu
    orbstack
    hammerspoon
    _1password
    istat-menus
    ghostty
  ];
in {
  inherit darwinPackages;
}
