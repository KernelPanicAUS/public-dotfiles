{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = ["git" "gcloud" "kubectl" "git-prompt"];
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-256color";
        src = pkgs.fetchFromGitHub {
          owner = "chrissicool";
          repo = "zsh-256color";
          rev = "9d8fa1015dfa895f2258c2efc668bc7012f06da6";
          sha256 = "sha256-Qd9pjDSQk+kz++/UjGVbM4AhAklc1xSTimLQXxN57pI=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.0";
          sha256 = "sha256-eRTk0o35QbPB9kOIV0iDwd0j5P/yewFFISVS/iEfP2g=";
        };
      }
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
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCKET=$(gpgconf --list-dirs agent-ssh-socket)
      export ZSH_THEME="pi"
      autoload -U history-search-end #needed for -end
      zle -N history-beginning-search-backward-end history-search-end
      zle -N history-beginning-search-forward-end history-search-end

      #when going up go up only beggining of curr word history
      bindkey '\e[A' history-beginning-search-backward-end
      bindkey '\e[B' history-beginning-search-forward-end
      #ctrl + arrow forward/backward word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      #alt + arrow forward/backward word
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      #alt + delete delete whole word
      bindkey "\e\x7f" backward-kill-word
    '';
  };
}
