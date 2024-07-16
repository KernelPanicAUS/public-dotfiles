{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tkhalil";
  home.homeDirectory = "/Users/tkhalil";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixci
    #bash
    direnv
    iterm2
    git
    gnupg
    silver-searcher
    skhd
    vim
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tkhalil/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
    # SSH_AUTH_SOCKET = $(gpgconf --list-dirs agent-ssh-socket)
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Programs natively supported by home-manager.
  programs = {
    bat.enable = true;
    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    htop.enable = true;
    bash = {enable = true;};

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    gpg = {enable = true;};

    git = {
      enable = true;
      userName = "Thomas Khalil";
      userEmail = "tkhalil@gmail.com";
      aliases = {
        co = "checkout";
        st = "status - s - b";
        ci = "commit";
        sb = "show-branch";
        up = "!git fetch origin && git rebase origin/master";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %f %Cgreen(%cr)%Creset'";
        who = "log --format=\"'%ai %h %aN %s'\"";
        df = "difftool - -dir-diff";
        ba = "branch - a";
        br = "branch - r";
        rpo = "remote prune origin";
        undo = "reset --soft HEAD~1";
        wip = "commit - am WIP";
        spull = "!git pull && git submodule sync - -recursive && git submodule update - -init - -recursive";
        spush = "push --recurse-submodules=on-demand";
      };

      extraConfig = {
        branch.autosetuprebase = "always";
        push.autoSetupRemote = true;
        log.decorate = true;
        showbranch.default = "--all";
        push.followTags = true;
        diff.tool = "diffmerge";
        diff.submodule = "log";
        diff.wsErrorHighlight = "all";
        core.excludesfile = "~/.gitignore";
        core.editor = "/usr/bin/vim -f";
        rebase.autoStash = true;
        status.submoduleSummary = true;
        init.defaultBranch = "main";
        init.templateDir = "/Users/tkhalil/.git-template";
      };
    };
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
    # https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/
    tmux = {
      enable = true;

      terminal = "tmux-256color";
      historyLimit = 100000;

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
      ];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      oh-my-zsh.enable = true;

      plugins = [
        {
          name = "pi-theme";
          file = "pi.zsh-theme";
          src = pkgs.fetchFromGitHub {
            owner = "tobyjamesthomas";
            repo = "pi";
            rev = "96778f903b79212ac87f706cfc345dd07ea8dc85";
            sha256 = "0zjj1pihql5cydj1fiyjlm3163s9zdc63rzypkzmidv88c2kjr1z";
          };
        }
      ];
      initExtra = ''
        export SSH_AUTH_SOCKET=$(gpgconf --list-dirs agent-ssh-socket)
      '';
    };
    alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        window = {
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
            # family = "Berkeley Mono";
            family = "Menlo";
            style = "Regular";
          };
          bold = {
            family = "Menlo";
            style = "Bold";
          };
          italic = {
            family = "Menlo";
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

        window.opacity = 1;
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
        live_config_reload = true;
        shell = {
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
  };
  services = {
    gpg-agent = {
      enable = pkgs.hostPlatform.isLinux;
      enableExtraSocket = true;
      enableSshSupport = true;
      pinentryPackage = "mac";
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
    };
  };
}
