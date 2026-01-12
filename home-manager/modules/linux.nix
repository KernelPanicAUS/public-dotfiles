{ config, pkgs, lib, ... }:
{
  # Linux-specific home-manager configuration
  # Only applies when running on Linux

  config = lib.mkIf pkgs.stdenv.isLinux {
    # GPG agent with GUI pinentry for X11/i3
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;  # GUI pinentry for X11
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };

    # i3 window manager configuration
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";

        fonts = {
          names = [ "DejaVu Sans Mono" ];
          size = 10.0;
        };

        startup = [
          { command = "${pkgs.dex}/bin/dex --autostart --environment i3"; notification = false; }
          { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
          { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; notification = false; }
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

        bars = [
          {
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];
      };
    };

    # Install packages needed for i3 config
    home.packages = with pkgs; [
      rofi
      dex
      xss-lock
      brightnessctl
      ranger
    ];
  };
}
