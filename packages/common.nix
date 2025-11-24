{pkgs, pkgs-stable ? pkgs, ...}: let
  dervify = import ./dervify.nix {inherit pkgs;};
  lulu = dervify rec {
    pname = "Lulu";
    version = "3.1.5";
    url = "https://github.com/objective-see/${pname}/releases/download/v${version}/${pname}_${version}.dmg";
    hash = "sha256-eFrOZv6KSZlmLtyPORrD2Low/e7m7HU1WeuT/w8Us7I=";
  };
  orbstack = dervify rec {
    pname = "Orbstack";
    version = "1.10.2";
    url = "https://orbstack.dev/download/stable/latest/arm64";
    hash = "sha256-YBiJVRzf3H/u4Ui3/bBID6C6XA2wvo8cBH/IQIhqdXE=";
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
    version = "7.10.4";
    url = "https://cdn.istatmenus.app/files/istatmenus7/versions/iStatMenus7.10.4.zip";
    hash = "sha256-lvB76NTtFKzxYXFsHk/2Ykl1nt+ZzEe+3euQdipoWB8=";
    format = "zip";
  };
  ghostty = dervify rec {
    version = "1.2.3";
    pname = "Ghostty";
    url = "https://release.files.ghostty.org/1.2.3/Ghostty.dmg";
    hash = "sha256-817pHxFuKAJ6ufje9FCYx1dbRLQH/4g6Lc0phcSDIGs=";
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
    dust
    gcc
    git-filter-repo
    delta
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
    cmake
    tailscale
    mtr
    libvterm-neovim
    glibtool
    cmake
    nix-output-monitor
    watch
    ispell

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
    kubeconform
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
    noto-fonts-color-emoji
    pngquant

    # Node.js development tools
    fzf
    nodePackages.typescript-language-server
    nodePackages.nodemon
    nodejs

    # Source code management, Git, GitHub tools
    gh
    #_1password-gui
    #        vscode
    code-cursor
    emacs
    obsidian
    kubectx
    claude-code

    # Text and terminal utilities
    htop
    hunspell
    iftop
    jetbrains-mono

    # Communication/Chat
    slack
    #zoom-us

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
