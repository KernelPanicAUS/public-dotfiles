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
}
