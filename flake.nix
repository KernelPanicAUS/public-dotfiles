{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
    nixpkgs,
  } @ inputs: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
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
        iterm2
        gcc
        git-filter-repo
        killall
        neofetch
        openssh
        pandoc
        sqlite
        wget
        zip
        nixfmt-classic

        # Encryption and security tools
        #_1password
        age
        age-plugin-yubikey
        gnupg
        libfido2
        pinentry-emacs

        kubectl
        k9s
        google-cloud-sdk
        tflint
        pre-commit

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
        nodePackages.live-server
        nodePackages.nodemon
        nodePackages.prettier
        nodePackages.npm
        nodejs

        # Source code management, Git, GitHub tools
        gh
        #_1password-gui
        vscode
        obsidian
        kubectx
        # Text and terminal utilities
        htop
        hunspell
        iftop
        jetbrains-mono
        jetbrains.phpstorm
        jq
        ripgrep
        slack
        tree
        tmux
        unrar
        unzip
        zsh-powerlevel10k
        alejandra
        zoom-us
        # Python packages
        black
        python39
        python39Packages.virtualenv
      ];

      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
        };
        taps = [];
        brews = ["aria2"];
        casks = [
          "google-chrome"
          "firefox"
          "1password"
          "microsoft-office"
          "alfred"
          "istat-menus"
          "lulu"
          "orbstack"
          "hammerspoon"
          "caffeine"
        ];
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      nix.settings.extra-platforms = "aarch64-darwin x86_64-darwin";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;

      security.pam.enableSudoTouchIdAuth = true;

      system.activationScripts.postUserActivation.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

      system.defaults = {
        CustomUserPreferences = {
          NSGlobalDomain = {
            NSCloseAlwaysConfirmsChanges = false;
            AppleSpacesSwitchOnActivate = true;
          };
          "com.apple.Music" = {
            userWantsPlaybackNotifications = false;
          };
          "com.apple.ActivityMonitor" = {
            UpdatePeriod = 1;
          };
          "com.apple.TextEdit" = {
            SmartQuotes = false;
            RichText = false;
          };
          "com.apple.spaces" = {
            "spans-displays" = false;
          };
          "com.apple.menuextra.clock" = {
            DateFormat = "EEE d MMM HH:mm:ss";
            FlashDateSeparators = false;
          };
        };
        alf = {
          allowdownloadsignedenabled = 0;
          allowsignedenabled = 1;
          globalstate = 1;
          loggingenabled = 0;
          stealthenabled = 0;
        };
        dock = {
          appswitcher-all-displays = false;
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.15;
          dashboard-in-overlay = false;
          enable-spring-load-actions-on-all-items = false;
          expose-animation-duration = 0.2;
          expose-group-by-app = false;
          launchanim = true;
          mineffect = "genie";
          minimize-to-application = false;
          mouse-over-hilite-stack = true;
          mru-spaces = false;
          orientation = "left";
          show-process-indicators = true;
          show-recents = true;
          showhidden = true;
          static-only = false;
          tilesize = 48;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
          persistent-apps = [
            "/Applications/Safari.app"
            "/Applications/Microsoft Outlook.app"
            "/Applications/Google Chrome.app"
            "/Applications/Firefox.app"
            "${pkgs.slack}/Applications/Slack.app"
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "${pkgs.zoom-us}/Applications/zoom.us.app"
            "/System/Applications/System Settings.app"
          ];
          # persistent-others = [ "/Users/${user.login}/Downloads/" ];
        };
        finder = {
          _FXShowPosixPathInTitle = false;
          AppleShowAllExtensions = true;
          AppleShowAllFiles = false;
          CreateDesktop = true;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "clmv";
          QuitMenuItem = false;
          ShowPathbar = true;
          ShowStatusBar = false;
        };
        loginwindow = {
          autoLoginUser = null;
          DisableConsoleAccess = false;
          GuestEnabled = false;
          LoginwindowText = null;
          PowerOffDisabledWhileLoggedIn = false;
          RestartDisabled = false;
          RestartDisabledWhileLoggedIn = false;
          SHOWFULLNAME = false;
          ShutDownDisabled = false;
          ShutDownDisabledWhileLoggedIn = false;
          SleepDisabled = false;
        };
        magicmouse = {
          MouseButtonMode = "TwoButton";
        };
        screencapture = {
          disable-shadow = true;
          location = "~/screenshots";
          show-thumbnail = true;
          type = "jpg";
        };
        smb = {
          NetBIOSName = null;
          ServerDescription = null;
        };
        spaces = {
          spans-displays = false;
        };
        trackpad = {
          ActuationStrength = 1;
          Clicking = true;
          Dragging = true;
          FirstClickThreshold = 1;
          SecondClickThreshold = 2;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
          TrackpadThreeFingerTapGesture = 0;
        };
        SoftwareUpdate = {
          AutomaticallyInstallMacOSUpdates = true;
          # AutomaticCheckEnabled = true;
          # # Check for software updates daily, not just once per week
          # ScheduleFrequency = 1;
          # # Download newly available updates in background
          # AutomaticDownload = 1;
          # # Install System data files & security updates
          # CriticalUpdateInstall = 1;
        };
        LaunchServices = {
          LSQuarantine = true;
        };
        ".GlobalPreferences" = {
          "com.apple.mouse.scaling" = null;
          "com.apple.sound.beep.sound" = null;
        };
        NSGlobalDomain = {
          _HIHideMenuBar = false;
          "com.apple.keyboard.fnState" = false;
          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.sound.beep.feedback" = 0;
          "com.apple.sound.beep.volume" = 0.0;
          "com.apple.springing.delay" = 1.0;
          "com.apple.springing.enabled" = null;
          "com.apple.swipescrolldirection" = true;
          "com.apple.trackpad.enableSecondaryClick" = true;
          "com.apple.trackpad.forceClick" = false;
          "com.apple.trackpad.scaling" = null;
          "com.apple.trackpad.trackpadCornerClickBehavior" = null;
          AppleEnableMouseSwipeNavigateWithScrolls = true;
          AppleEnableSwipeNavigateWithScrolls = true;
          AppleFontSmoothing = null;
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;
          AppleKeyboardUIMode = null;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = true;
          AppleShowAllFiles = false;
          AppleShowScrollBars = "WhenScrolling";
          AppleScrollerPagingBehavior = true;
          AppleTemperatureUnit = "Celsius";
          AppleWindowTabbingMode = "always";
          InitialKeyRepeat = 15; # slider values: 120, 94, 68, 35, 25, 15
          KeyRepeat = 2; # slider values: 120, 90, 60, 30, 12, 6, 2
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSAutomaticWindowAnimationsEnabled = true;
          NSDisableAutomaticTermination = null;
          NSDocumentSaveNewDocumentsToCloud = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSScrollAnimationEnabled = true;
          NSTableViewDefaultSizeMode = 2;
          NSTextShowsControlCharacters = false;
          NSUseAnimatedFocusRing = true;
          NSWindowResizeTime = 2.0e-2;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;
        };
      };
    };
  in {
    formatter = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#trv4129
    darwinConfigurations."trv4129-3" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
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
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."trv4129-3".pkgs;
  };
}
