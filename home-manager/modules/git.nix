{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Thomas Khalil";
    userEmail = "KernelPanicAUS@users.noreply.github.com";
    aliases = {
      co = "checkout";
      st = "status -s -b";
      ci = "commit";
      sb = "show-branch";
      up = "!git fetch origin && git rebase origin/master";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %f %Cgreen(%cr)%Creset'";
      who = "log --format=\"'%ai %h %aN %s'\"";
      df = "difftool - -dir-diff";
      ba = "branch -a";
      br = "branch -r";
      rpo = "remote prune origin";
      undo = "reset --soft HEAD~1";
      wip = "commit - am WIP";
      spull = "!git pull && git submodule sync - -recursive && git submodule update - -init - -recursive";
      spush = "push --recurse-submodules=on-demand";
    };
    ignores = [
      # System Files
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Thumbnail Cache Files
      "._*"
      "Thumbs.db"

      # Files on External Disks
      ".Spotlight-V100"
      ".Trashes"

      # Directories
      ".idea/"
      ".vscode/"
      "__pycache__/"
      "node_modules/"
      "venv/"

      # Compiled Files
      "*.pyc"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"

      # Logs and Databases
      "*.log"
      "*.sqlite"

      # OS-generated Files
      "Icon?"
      "ehthumbs.db"
      "Desktop.ini"

      # Application-specific Files
      ".sass-cache"
      "*.swp"
      ".ipynb_checkpoints"

      ".direnv/**"
      ".envrc"
    ];

    extraConfig = {
      core.pager = "${pkgs.delta}/bin/delta";
      core.editor = "emacsclient -c -a ''";
      delta = {
        side-by-side = true;
        navigate = true;
        dark = true;
      };
      interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
      merge.conflictstyle = "zdiff3";
      branch.autosetuprebase = "always";
      push.autoSetupRemote = true;
      log.decorate = true;
      showbranch.default = "--all";
      push.followTags = true;
      diff.tool = "diffmerge";
      diff.submodule = "log";
      diff.wsErrorHighlight = "all";
      core.excludesfile = "~/.gitignore";
#      core.editor = "/usr/bin/vim -f";
      rebase.autoStash = true;
      status.submoduleSummary = true;
      init.defaultBranch = "main";
      init.templateDir = "/Users/tkhalil/.git-template";
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };
}
