{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        option_as_alt = "Both";
        dimensions = {
          columns = 180;
          lines = 60;
        };
        padding = {
          x = 2;
          y = 2;
        };
      };
      colors.draw_bold_text_with_bright_colors = true;
      font = {
        normal = {
          family = "BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons";
          style = "Regular";
        };
        bold = {
          family = "BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons";
          style = "Bold";
        };
        italic = {
          family = "BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons";
          style = "Italic";
        };
        size = 16;
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      debug = {render_timer = false;};
      colors = {
        primary = {
          background = "0x191919";
          foreground = "0xeaeaea";
        };
        cursor = {
          text = "0xf1c1c1";
          cursor = "0xff2600";
        };
        normal = {
          black = "0x000000";
          red = "0xd54e53";
          green = "0xb9ca4a";
          yellow = "0xe6c547";
          blue = "0x7aa6da";
          magenta = "0xc397d8";
          cyan = "0x70c0ba";
          white = "0xffffff";
        };
        bright = {
          black = "0x666666";
          red = "0xff3334";
          green = "0x9ec400";
          yellow = "0xe7c547";
          blue = "0x7aa6da";
          magenta = "0xb77ee0";
          cyan = "0x54ced6";
          white = "0xffffff";
        };
        dim = {
          black = "0x333333";
          red = "0xf2777a";
          green = "0x99cc99";
          yellow = "0xffcc66";
          blue = "0x6699cc";
          magenta = "0xcc99cc";
          cyan = "0x66cccc";
          white = "0xdddddd";
        };
      };

      window.opacity = 0.7;
      mouse = {
        hide_when_typing = true;
        bindings = [
          {
            mouse = "Middle";
            action = "PasteSelection";
          }
        ];
      };
      selection = {semantic_escape_chars = ",│`|:\"' ()[]{}<>";};
      cursor = {style = "Block";};
      general.live_config_reload = true;
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = ["--login"];
      };
      keyboard.bindings = [
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "Q";
          mods = "Command";
          action = "Quit";
        }
        {
          key = "W";
          mods = "Command";
          action = "Quit";
        }
        {
          key = "Home";
          chars = "OH";
          mode = "AppCursor";
        }
        {
          key = "Home";
          chars = "[H";
          mode = "~AppCursor";
        }
        {
          key = "End";
          chars = "OF";
          mode = "AppCursor";
        }
        {
          key = "End";
          chars = "[F";
          mode = "~AppCursor";
        }
        {
          key = "Key0";
          mods = "Command";
          action = "ResetFontSize";
        }
        {
          key = "Equals";
          mods = "Command";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Command";
          action = "DecreaseFontSize";
        }
        {
          key = "PageUp";
          mods = "Shift";
          chars = "[5;2~";
        }
        {
          key = "PageUp";
          mods = "Control";
          chars = "[5;5~";
        }
        {
          key = "PageUp";
          chars = "[5~";
        }
        {
          key = "PageDown";
          mods = "Shift";
          chars = "[6;2~";
        }
        {
          key = "PageDown";
          mods = "Control";
          chars = "[6;5~";
        }
        {
          key = "PageDown";
          chars = "[6~";
        }
        {
          key = "Tab";
          mods = "Shift";
          chars = "[Z";
        }
        {
          key = "Back";
          chars = "";
        }
        {
          key = "Back";
          mods = "Alt";
          chars = "";
        }
        {
          key = "Insert";
          chars = "[2~";
        }
        {
          key = "Delete";
          chars = "[3~";
        }
        {
          key = "Left";
          mods = "Shift";
          chars = "[1;2D";
        }
        {
          key = "Left";
          mods = "Control";
          chars = "[1;5D";
        }
        {
          key = "Left";
          mods = "Alt";
          chars = "[1;3D";
        }
        {
          key = "Left";
          chars = "[D";
          mode = "~AppCursor";
        }
        {
          key = "Left";
          chars = "OD";
          mode = "AppCursor";
        }
        {
          key = "Right";
          mods = "Shift";
          chars = "[1;2C";
        }
        {
          key = "Right";
          mods = "Control";
          chars = "[1;5C";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "[1;3C";
        }
        {
          key = "Right";
          chars = "[C";
          mode = "~AppCursor";
        }
        {
          key = "Right";
          chars = "OC";
          mode = "AppCursor";
        }
        {
          key = "Up";
          mods = "Shift";
          chars = "[1;2A";
        }
        {
          key = "Up";
          mods = "Control";
          chars = "[1;5A";
        }
        {
          key = "Up";
          mods = "Alt";
          chars = "[1;3A";
        }
        {
          key = "Up";
          chars = "[A";
          mode = "~AppCursor";
        }
        {
          key = "Up";
          chars = "OA";
          mode = "AppCursor";
        }
        {
          key = "Down";
          mods = "Shift";
          chars = "[1;2B";
        }
        {
          key = "Down";
          mods = "Control";
          chars = "[1;5B";
        }
        {
          key = "Down";
          mods = "Alt";
          chars = "[1;3B";
        }
        {
          key = "Down";
          chars = "[B";
          mode = "~AppCursor";
        }
        {
          key = "Down";
          chars = "OB";
          mode = "AppCursor";
        }
        {
          key = "F1";
          chars = "OP";
        }
        {
          key = "F2";
          chars = "OQ";
        }
        {
          key = "F3";
          chars = "OR";
        }
        {
          key = "F4";
          chars = "OS";
        }
        {
          key = "F5";
          chars = "[15~";
        }
        {
          key = "F6";
          chars = "[17~";
        }
        {
          key = "F7";
          chars = "[18~";
        }
        {
          key = "F8";
          chars = "[19~";
        }
        {
          key = "F9";
          chars = "[20~";
        }
        {
          key = "F10";
          chars = "[21~";
        }
        {
          key = "F11";
          chars = "[23~";
        }
        {
          key = "F12";
          chars = "[24~";
        }
        {
          key = "F1";
          mods = "Shift";
          chars = "[1;2P";
        }
        {
          key = "F2";
          mods = "Shift";
          chars = "[1;2Q";
        }
        {
          key = "F3";
          mods = "Shift";
          chars = "[1;2R";
        }
        {
          key = "F4";
          mods = "Shift";
          chars = "[1;2S";
        }
        {
          key = "F5";
          mods = "Shift";
          chars = "[15;2~";
        }
        {
          key = "F6";
          mods = "Shift";
          chars = "[17;2~";
        }
        {
          key = "F7";
          mods = "Shift";
          chars = "[18;2~";
        }
        {
          key = "F8";
          mods = "Shift";
          chars = "[19;2~";
        }
        {
          key = "F9";
          mods = "Shift";
          chars = "[20;2~";
        }
        {
          key = "F10";
          mods = "Shift";
          chars = "[21;2~";
        }
        {
          key = "F11";
          mods = "Shift";
          chars = "[23;2~";
        }
        {
          key = "F12";
          mods = "Shift";
          chars = "[24;2~";
        }
        {
          key = "F1";
          mods = "Control";
          chars = "[1;5P";
        }
        {
          key = "F2";
          mods = "Control";
          chars = "[1;5Q";
        }
        {
          key = "F3";
          mods = "Control";
          chars = "[1;5R";
        }
        {
          key = "F4";
          mods = "Control";
          chars = "[1;5S";
        }
        {
          key = "F5";
          mods = "Control";
          chars = "[15;5~";
        }
        {
          key = "F6";
          mods = "Control";
          chars = "[17;5~";
        }
        {
          key = "F7";
          mods = "Control";
          chars = "[18;5~";
        }
        {
          key = "F8";
          mods = "Control";
          chars = "[19;5~";
        }
        {
          key = "F9";
          mods = "Control";
          chars = "[20;5~";
        }
        {
          key = "F10";
          mods = "Control";
          chars = "[21;5~";
        }
        {
          key = "F11";
          mods = "Control";
          chars = "[23;5~";
        }
        {
          key = "F12";
          mods = "Control";
          chars = "[24;5~";
        }
        {
          key = "F1";
          mods = "Alt";
          chars = "[1;6P";
        }
        {
          key = "F2";
          mods = "Alt";
          chars = "[1;6Q";
        }
        {
          key = "F3";
          mods = "Alt";
          chars = "[1;6R";
        }
        {
          key = "F4";
          mods = "Alt";
          chars = "[1;6S";
        }
        {
          key = "F5";
          mods = "Alt";
          chars = "[15;6~";
        }
        {
          key = "F6";
          mods = "Alt";
          chars = "[17;6~";
        }
        {
          key = "F7";
          mods = "Alt";
          chars = "[18;6~";
        }
        {
          key = "F8";
          mods = "Alt";
          chars = "[19;6~";
        }
        {
          key = "F9";
          mods = "Alt";
          chars = "[20;6~";
        }
        {
          key = "F10";
          mods = "Alt";
          chars = "[21;6~";
        }
        {
          key = "F11";
          mods = "Alt";
          chars = "[23;6~";
        }
        {
          key = "F12";
          mods = "Alt";
          chars = "[24;6~";
        }
        {
          key = "F1";
          mods = "Command";
          chars = "[1;3P";
        }
        {
          key = "F2";
          mods = "Command";
          chars = "[1;3Q";
        }
        {
          key = "F3";
          mods = "Command";
          chars = "[1;3R";
        }
        {
          key = "F4";
          mods = "Command";
          chars = "[1;3S";
        }
        {
          key = "F5";
          mods = "Command";
          chars = "[15;3~";
        }
        {
          key = "F6";
          mods = "Command";
          chars = "[17;3~";
        }
        {
          key = "F7";
          mods = "Command";
          chars = "[18;3~";
        }
        {
          key = "F8";
          mods = "Command";
          chars = "[19;3~";
        }
        {
          key = "F9";
          mods = "Command";
          chars = "[20;3~";
        }
        {
          key = "F10";
          mods = "Command";
          chars = "[21;3~";
        }
        {
          key = "F11";
          mods = "Command";
          chars = "[23;3~";
        }
        {
          key = "F12";
          mods = "Command";
          chars = "[24;3~";
        }
      ];
    };
  };
}
