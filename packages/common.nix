{pkgs, ...}: let
  dervify = import ./dervify.nix {inherit pkgs;};
  lulu = dervify rec {
    pname = "Lulu";
    version = "3.1.2";
    url = "https://github.com/objective-see/${pname}/releases/download/v${version}/${pname}_${version}.dmg";
    hash = "sha256-sZ7gNMSq30StcwPettHoUFjTGYtEYxIXfOGQdASLiII=";
  };
  orbstack = dervify rec {
    pname = "Orbstack";
    version = "1.10.2";
    url = "https://orbstack.dev/download/stable/latest/arm64";
    hash = "sha256-/zujkmctMdJUm3d7Rjjeic8QrvWSlEAUhjFgouBXeNw=";
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
    version = "1.1.3";
    url = "https://release.files.ghostty.org/1.1.3/Ghostty.dmg";
    hash = "sha256-ZOUUGI9UlZjxZtbctvjfKfMz6VTigXKikB6piKFPJkc=";
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
    arc-browser
    cmake
    tailscale
    mtr

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
