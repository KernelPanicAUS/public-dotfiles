{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  system.configurationRevision = self.rev or self.dirtyRev or null;
  nix.enable = false;
  nix = {
    settings = {
      eval-cores = 0;
      extra-experimental-features = "parallel-eval";
      experimental-features = "nix-command flakes";
      extra-platforms = "aarch64-darwin x86_64-darwin";
      download-buffer-size = "536870912";
      substituters = ["https://nix-community.cachix.org"];
      trusted-users = ["root" "tkhalil"];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  programs.zsh.enable = true; # default shell on catalina

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "tkhalil";

  networking = {
    applicationFirewall = {
      enableStealthMode = false;
      allowSignedApp = false;
      allowSigned = true;
      enable = true;
      blockAllIncoming = false;
    };
  };

  system = {
    # activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    stateVersion = 4;
    defaults = {
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
      dock = {
        appswitcher-all-displays = false;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.15;
        dashboard-in-overlay = false;
        enable-spring-load-actions-on-all-items = false;
        expose-animation-duration = 0.2;
        expose-group-apps = false;
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
}
