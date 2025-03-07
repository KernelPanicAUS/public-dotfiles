{pkgs, ...}: let
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
  ghostty = dervify rec {
    pname = "Ghostty";
    version = "1.0.1";
    url = "https://release.files.ghostty.org/${version}/${pname}.dmg";
    hash = "sha256-CR96Kz9BYKFtfVKygiEku51XFJk4FfYqfXACeYQ3JlI=";
    useHdiutil = true;
  };
  basePackages = with pkgs; [
    aria2
    vim
    act
    alacritty
    bartender
    aspell
    aspellDicts.en
    bash-completion
    bash
    bat
    vlc-bin
    btop
    tailscale
    coreutils
    difftastic
    du-dust
    gcc
    git-filter-repo
    killall
    neofetch
    openssh
    pandoc
    sqlite
    wget
    zip
    jq
    ripgrep
    gnupg
    tree
    tmux
    unrar
    unzip
    dive
    arc-browser
    cmake

    # Encryption and security tools
    just
    age
    age-plugin-yubikey
    gnupg
    libfido2
    pinentry-emacs
    pinentry_mac

    # Cloud tools
    kubectl
    k9s
    tflint
    pre-commit
    terraform-ls

    # Media-related packages
    emacs-all-the-icons-fonts
    imagemagick
    dejavu_fonts
    ffmpeg
    fd
    font-awesome
    glow
    hack-font
    jpegoptim
    meslo-lgs-nf
    noto-fonts
    noto-fonts-emoji
    pngquant

    # Node.js development tools
    fzf
    nodePackages.typescript-language-server
    nodePackages.live-server
    nodePackages.nodemon
    nodePackages.prettier
    nodePackages.npm
    nodejs

    # Source code management, Git, GitHub tools
    gh
    #_1password-gui
    #        vscode
    code-cursor
    emacs
    obsidian
    kubectx

    # Text and terminal utilities
    htop
    hunspell
    iftop
    jetbrains-mono

    # Communication/Chat
    slack
    zoom-us

    # nix
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixci
    alejandra
    nixfmt-classic

    # Python packages
    black
  ];
  commonPackages =
    basePackages
    ++ [
      alfred
      lulu
      orbstack
      hammerspoon
      _1password
      istat-menus
      ghostty
    ];
in {
  inherit commonPackages;
}
