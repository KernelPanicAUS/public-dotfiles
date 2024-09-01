{
  config,
  pkgs,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/tmux.nix
    ./modules/alacritty.nix
  ];
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
    syncthing
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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
    #".emacs".source = config.lib.file.mkOutOfStoreSymlink ../.emacs;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/emacs/tree-sitter".source = pkgs.runCommand "grammars" {} ''
      mkdir -p $out
      ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList
          (name: src: "name=${name}; ln -s ${src}/parser $out/\lib${name}${
            if pkgs.system == "aarch64-darwin"
            then ".dylib"
            else ".so"
          }")
          pkgs.tree-sitter.builtGrammars)};
    '';
  };

  home.sessionVariables = {
    TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Programs natively supported by home-manager.
  programs = {
    bat.enable = true;
    bat.config.theme = "OneHalfDark";
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    htop.enable = true;
    bash.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    gpg.enable = true;
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
    syncthing = {
      enable = true;
      #user = "tkhalil";
      #dataDir = "~/Documents"; # Default folder for new synced folders
      #configDir = "~/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };
}
