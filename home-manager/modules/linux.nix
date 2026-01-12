{
  config,
  pkgs,
  lib,
  ...
}: {
  # Linux-specific home-manager configuration
  # Only applies when running on Linux

  config = lib.mkIf pkgs.stdenv.isLinux {
    # GPG agent with GUI pinentry for X11/i3
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3; # GUI pinentry for X11
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };

    # i3 window manager configuration
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";

        fonts = {
          names = ["DejaVu Sans Mono"];
          size = 10.0;
        };
        
        startup = [
          {
            command = "exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${config.home.homeDirectory}/Downloads/cute-town.png";
            notification = false;
          }
          {
            command = "${pkgs.clipmenu}/bin/clipmenud";
            notification = false;
          }
          {
            command = "${pkgs.dex}/bin/dex --autostart --environment i3";
            notification = false;
          }
          {
            command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock --nofork";
            notification = false;
          }
          {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
            notification = false;
          }
        ];

        keybindings = lib.mkOptionDefault {
          # Terminal
          "Mod4+Return" = "exec ghostty";

          # App launcher
          "Mod4+d" = "exec rofi -show drun";

          # Close window
          "Mod4+w" = "kill";

          # File manager
          "Mod4+Shift+f" = "exec ghostty -e ranger";

          # Focus (vim keys)
          "Mod4+h" = "focus left";
          "Mod4+j" = "focus down";
          "Mod4+k" = "focus up";
          "Mod4+semicolon" = "focus right";

          # Focus (arrows)
          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Up" = "focus up";
          "Mod4+Right" = "focus right";

          # Move window (vim keys)
          "Mod4+Shift+h" = "move left";
          "Mod4+Shift+j" = "move down";
          "Mod4+Shift+k" = "move up";
          "Mod4+Shift+semicolon" = "move right";

          # Move window (arrows)
          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Right" = "move right";

          # Split
          "Mod4+Ctrl+h" = "split h";
          "Mod4+Ctrl+v" = "split v";

          # Fullscreen
          "Mod4+f" = "fullscreen toggle";

          # Layout
          "Mod4+s" = "layout stacking";
          "Mod4+t" = "layout tabbed";
          "Mod4+e" = "layout toggle split";

          # Floating
          "Mod4+Shift+space" = "floating toggle";
          "Mod4+space" = "focus mode_toggle";

          # Focus parent
          "Mod4+a" = "focus parent";

          # Config reload/restart/exit
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+r" = "restart";
          "Mod4+Shift+q" = "exec i3-nagbar -t warning -m 'Exit i3?' -B 'Yes' 'i3-msg exit'";

          # Media keys
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +10%";
          "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 10%-";

          # Resize mode
          "Mod4+r" = "mode resize";
        };

        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "semicolon" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Return" = "mode default";
            "Escape" = "mode default";
          };
        };

        floating = {
          modifier = "Mod4";
        };

        bars = [];
      };
    };

    # Polybar configuration
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };
      script = "polybar main &";

      settings = {
        "bar/main" = {
          width = "100%";
          height = 30;
          radius = 0;
          fixed-center = true;

          background = "#222";
          foreground = "#dfdfdf";

          line-size = 3;
          line-color = "#f00";

          border-size = 0;
          border-color = "#00000000";

          padding-left = 0;
          padding-right = 2;

          module-margin-left = 1;
          module-margin-right = 2;

          font-0 = "DejaVu Sans Mono:size=10;1";
          font-1 = "Symbols Nerd Font Mono:size=12;2";
          font-2 = "Font Awesome 7 Free:style=Solid:size=10;1";

          modules-left = "i3";
          modules-center = "date";
          modules-right = "filesystem cpu memory pulseaudio network battery tray";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          label-mode-padding = 2;
          label-mode-foreground = "#000";
          label-mode-background = "#ffb52a";

          # focused = Active workspace on focused monitor
          label-focused = "%index%";
          label-focused-background = "#285577";
          label-focused-underline = "#4c7899";
          label-focused-padding = 2;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%index%";
          label-unfocused-padding = 2;

          # visible = Active workspace on unfocused monitor
          label-visible = "%index%";
          label-visible-background = "#5f676a";
          label-visible-underline = "#5f676a";
          label-visible-padding = 2;

          # urgent = Workspace with urgency hint set
          label-urgent = "%index%";
          label-urgent-background = "#900000";
          label-urgent-padding = 2;
        };

        "module/date" = {
          type = "internal/date";
          interval = 5;

          date = "%Y-%m-%d";
          date-alt = "%A, %B %d, %Y";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          format-prefix = " ";
          format-prefix-foreground = "#ffb52a";
          format-underline = "#0a6cf5";

          label = "%date% %time%";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume>";
          format-volume-prefix = "%{T2}󰕾 %{T-}";
          format-volume-prefix-foreground = "#5fb3f5";
          label-volume = "%percentage%%";
          label-volume-foreground = "#dfdfdf";

          format-muted-prefix = "%{T2}󰖁 %{T-}";
          format-muted-prefix-foreground = "#666";
          label-muted = "muted";
          label-muted-foreground = "#666";

          click-right = "pavucontrol";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          full-at = 98;

          format-charging = "<label-charging>";
          format-charging-prefix = "%{T2}󰂄 %{T-}";
          format-charging-prefix-foreground = "#a3be8c";
          format-charging-underline = "#a3be8c";
          label-charging = "%percentage%%";

          format-discharging = "<label-discharging>";
          format-discharging-prefix = "%{T2}󰁹 %{T-}";
          format-discharging-prefix-foreground = "#ebcb8b";
          format-discharging-underline = "#ebcb8b";
          label-discharging = "%percentage%%";

          format-full-prefix = "%{T2}󰁹 %{T-}";
          format-full-prefix-foreground = "#a3be8c";
          format-full-underline = "#a3be8c";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "%{T2}󰻠 %{T-}";
          format-prefix-foreground = "#bf616a";
          format-underline = "#bf616a";
          label = "%percentage:2%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "%{T2}󰍛 %{T-}";
          format-prefix-foreground = "#88c0d0";
          format-underline = "#88c0d0";
          label = "%percentage_used%%";
        };

        "module/network" = {
          type = "internal/network";
          interface-type = "wired";
          interval = 3;

          format-connected = "<label-connected>";
          format-connected-prefix = "%{T2}󰈀 %{T-}";
          format-connected-prefix-foreground = "#a3be8c";
          format-connected-underline = "#a3be8c";
          label-connected = "%local_ip%";

          format-disconnected = "<label-disconnected>";
          format-disconnected-prefix = "%{T2}󰈂 %{T-}";
          format-disconnected-prefix-foreground = "#666";
          label-disconnected = "down";
          format-disconnected-foreground = "#666";
        };

        "module/filesystem" = {
          type = "internal/fs";
          interval = 25;

          mount-0 = "/";

          format-mounted = "<label-mounted>";
          format-mounted-prefix = "%{T2}󰋊 %{T-}";
          format-mounted-prefix-foreground = "#b48ead";
          label-mounted = "%percentage_used%%";
          label-mounted-underline = "#b48ead";
          label-unmounted = "";
        };

        "module/tray" = {
          type = "internal/tray";
          tray-spacing = 8;
        };

        "settings" = {
          screenchange-reload = true;
        };

        "global/wm" = {
          margin-top = 5;
          margin-bottom = 5;
        };
      };
    };

    # Install packages needed for i3 config
    home.packages = with pkgs; [
      rofi
      dex
      xss-lock
      brightnessctl
      ranger
      pavucontrol  # For polybar volume right-click
    ];
  };
}
