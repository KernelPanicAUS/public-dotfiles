# Setting paths
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin/lib:$HOME/.local/bin/:$HOME/.bin:$PATH
export PATH="$HOME/google-cloud-sdk/bin:$HOME/.cargo/bin:/Users/tkhalil/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$HOME/.pyenv/shims:$PATH"
export PATH="$HOME/.tfenv/bin:$PATH:$HOME/.sdkman/candidates/maven/current/bin"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"

# Github
export GITHUB_TOKEN=$(gh auth token)

# Golang
export GOPATH="$(go env GOPATH)"
export PATH="${PATH}:${GOPATH}/bin"
# Terraform
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Locale
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# AWS
export AWS_SDK_LOAD_CONFIG=1

#Git PS1 terminal configs
GIT_PS1_SHOWDIRTYSTATE="true"
GIT_PS1_SHOWSTASHSTATE="true"
GIT_PS1_SHOWUNTRACKEDFILES="true"
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS="true"

complete -F _complete_ssh_hosts ssh

export HISTCONTROL=ignoredups:erasedups:ignoreboth
export HISTIGNORE="exit*:stejdk*:ls:ll*"
export HISTSIZE=10000000


source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"

case $TERM in
  (xterm*) set_title='\[\e]0;\u@\h: \w\a\]';;
  (*) set_title=
esac

export PS1=$set_title'\[[m\]\[\033[38;5;5m\][\A]\[[m\] \[[m\]\[\033[38;5;11m\]\w\[[m\]\[[m\] $(kube_ps1) > '

#[[ -s ~/.bashrc ]] && source ~/.bashrc

if [[ ! -v INSIDE_EMACS ]]; then
    bind '"^[[A":history-search-backward'
    bind '"^[[B":history-search-forward'
fi

# Separate aliases file
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Separate functions file
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

source ~/.git-prompt.sh

#. "/usr/local/opt/nvm/nvm.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tkhalil/google-cloud-sdk/path.bash.inc' ]; then . '/Users/tkhalil/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tkhalil/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/tkhalil/google-cloud-sdk/completion.bash.inc'; fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(direnv hook bash)"
