# Setting paths
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/bin/lib:$HOME/.local/bin/:$HOME/.bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"

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

export PS1='\[\e[33;40m\][$(date "+%H:%M")] \w \[\e[35;40m\]$(__git_ps1 "[%s]")\[\e[33;1m\]\[\e[0m\] $(kube_ps1) > '

[[ -s ~/.bashrc ]] && source ~/.bashrc

# Separate aliases file
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Separate functions file
if [ -f ~/.bash_functions ]; then
  . ~/.bash_functions
fi

source ~/.git-prompt.sh

. "/usr/local/opt/nvm/nvm.sh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
