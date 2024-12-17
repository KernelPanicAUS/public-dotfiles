{pkgs, ...}: let
  commonPackages = with pkgs; [
    vim
    act
    alacritty
    bartender
    aspell
    aspellDicts.en
    bash-completion
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
    #_1password
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
    emacs
    obsidian
    kubectx

    # Text and terminal utilities
    htop
    hunspell
    iftop
    jetbrains-mono

    # Editors
    #jetbrains.idea-ultimate
    # jetbrains-toolbox # only supported on x86_64-linux
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
    #python39
    #python39Packages.virtualenv
  ];
in {
  inherit commonPackages;
}
