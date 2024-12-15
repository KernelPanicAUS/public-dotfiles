{
  description = "Thomas's nix darwin and home-manager flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
  };

  outputs = {
    self,
    nix-darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    mac-app-util,
    home-manager,
    nixpkgs,
    nixpkgs-stable,
    determinate,
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
    };

    commonPackages = pkgs:
      with pkgs; [
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

    uniPackages = pkgs:
      with pkgs; [
        lmstudio
        # kicad
        # bambu-studio
      ];

    uniConfiguration = {pkgs, ...}: {
      environment.systemPackages = commonPackages pkgs ++ uniPackages pkgs;
      imports = [./hosts/uni.nix];
    };

    workConfiguration = {pkgs, ...}: let
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
    in {
      environment.systemPackages = commonPackages pkgs;
      imports = [./hosts/trv4129-3.nix];
    };
    userConfiguration = {...}: {
      users.users.tkhalil = {
        name = "tkhalil";
        home = "/Users/tkhalil";
      };

      home-manager.users.tkhalil = {pkgs, ...}: {
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        imports = [./home-manager/home.nix];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#trv4129
    darwinConfigurations."uni" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        determinate.darwinModules.default
        uniConfiguration
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # inherit user;
            enable = true;
            user = "tkhalil";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
            enableRosetta = true;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
        userConfiguration
      ];
    };

    darwinConfigurations."trv4129-3" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit self;};
      modules = [
        determinate.darwinModules.default
        workConfiguration
        home-manager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # inherit user;
            enable = true;
            user = "tkhalil";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
            enableRosetta = true;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
        userConfiguration
      ];
    };
  };
}
