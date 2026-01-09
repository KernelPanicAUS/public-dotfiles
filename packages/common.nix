{ pkgs, pkgs-stable ? pkgs, ... }:
let
  # Truly portable packages only (no macOS-specific packages)
  basePackages = with pkgs; [
    aria2
    vim
    act
    alacritty
    aspell
    aspellDicts.en
    bash-completion
    bash
    bat
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
    yubikey-manager 

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
in {
  inherit basePackages;
}
