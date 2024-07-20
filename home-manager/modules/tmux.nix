{
  config,
  pkgs,
  ...
}: {
    # https://haseebmajid.dev/posts/2023-07-10-setting-up-tmux-with-nix-home-manager/
    programs.tmux = {
      enable = true;

      terminal = "tmux-256color";
      historyLimit = 100000;
      shell = "${pkgs.zsh}/bin/zsh";

      extraConfig = ''

        # Index Start
        set -g base-index 1

        # Mouse
        set-option -g -q mouse on

        # Force reload of config file
        unbind r
        bind r source-file ~/.tmux.conf


        ### Keybinds
        ###########################################################################

        # Unbind C-b as the default prefix
        unbind C-b

        # Set new default prefix
        set-option -g prefix `

        # Return to previous window when prefix is pressed twice
        bind C-a last-window
        bind ` send-prefix

        # Allow swapping C-a and ` using F11/F12
        bind F11 set-option -g prefix C-a
        bind F12 set-option -g prefix `

        # Keybind preference
        setw -g mode-keys vi
        set-option -g status-keys vi

        # Moving between panes with vim movement keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Window Cycle/Swap
        bind e previous-window
        bind f next-window
        bind E swap-window -t -1
        bind F swap-window -t +1

        # Easy split pane commands
        bind = split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Activate inner-most session (when nesting tmux) to send commands
        bind a send-prefix


        ### Theme
        ###########################################################################

        # Statusbar Color Palatte
        set-option -g status-justify left
        set-option -g status-bg black
        set-option -g status-fg white
        set-option -g status-left-length 80
        set-option -g status-right-length 180

        # Pane Border Color Palette
        set-option -g pane-active-border-style fg=green,bg=black
        set-option -g pane-border-style fg=white,bg=black

        # Message Color Palette
        set-option -g message-style fg=black,bg=green

        # Window Status Color Palette
        setw -g window-status-style bg=black
        setw -g window-status-current-style fg=green
        setw -g window-status-bell-style fg=red,default
        setw -g window-status-activity-style fg=yellow,default

        ### UI
        ###########################################################################

        # Notification
        setw -g monitor-activity on
        set -g visual-activity on
        set-option -g bell-action any
        set-option -g visual-bell off

        # Automatically set window titles
        set-option -g set-titles on
        set-option -g set-titles-string '#H:#S.#I.#P #W #T' # window number,program name,active (or not)

        set -g status-interval 10

        # Statusbar Adjustments
        set -g status-left "#[fg=red] #H#[fg=green]:#[fg=white]#S#[fg=green] |#[fg=colour161]#{simple_git_status}#[fg=green] "

        set -g status-right "#{airpods_battery} | #[default]Net: #[fg=colour223]#{wifi_ssid}#[fg=default] #{wifi_icon}| #[fg=colour22]Battery:#[fg=default] #{battery_icon}#{battery_percentage} #{battery_remain}#[default] | #[fg=colour33]%d %B %Y#[default] | #[fg=cyan]%H:%M #[default]"
      '';

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"

            set -g @catppuccin_window_default_fill "number"
            set -g @catppuccin_window_default_text "#W"

            set -g @catppuccin_window_current_fill "number"
            set -g @catppuccin_window_current_text "#W"

            set -g @catppuccin_status_modules_right "directory user host session"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
            set -g @catppuccin_status_right_separator_inverse "no"
            set -g @catppuccin_status_fill "icon"
            set -g @catppuccin_status_connect_separator "no"

            set -g @catppuccin_directory_text "#{pane_current_path}"
          '';
        }
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-save-shell-history 'on'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'off'
            set -g @continuum-boot 'off'
            set -g @continuum-boot-options 'alacritty'
            set -g @continuum-save-interval '10'
          '';
        }
        # {
        #   plugin = tmuxPlugins.tpm;
        # }
        {
          plugin = tmuxPlugins.better-mouse-mode;
        }
        {
          plugin = tmuxPlugins.battery;
          extraConfig = ''
          set -g @batt_charging_icon "🔌"
          set -g @batt_remain_short true
          '';
        }
        {
          plugin = tmuxPlugins.online-status;
        }
      ];
      
    };
}