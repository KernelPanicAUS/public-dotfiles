## GIT ##
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gh="grep github ./.git/config | sed -e 's/^.*\(github.com.*\)\.git$/\1/' -e 's/.*github\.com:*\/*/https:\/\/github.com\//' | xargs open"
alias gd='git diff'
alias gf='git fetch'
alias gk='gitk --all&'
alias gx='gitx --all'
alias gp='git push'
alias gl='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'

alias ls='gls -G'
alias ll='gls -FGlAhp --time-style=+"%d %B %Y %H:%M:%S" --color=auto'                       # Preferred 'ls' implementation
alias less='less -FSNRXc'                                                                   # Preferred 'less' implementation
alias ~="cd ~"

alias kl="kubectl"

alias grep="rg"

alias myip="curl -s http://ip-api.com/json | jq -r '.query'"                    # myip:         Public facing IP Address
alias netCons='lsof -i'                                                         # netCons:      Show all open TCP/IP sockets
alias lsock='sudo /usr/sbin/lsof -i -P'                                         # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'                               # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'                               # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'                                          # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'                                          # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'                                    # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                                              # showBlocked:  All ipfw rules inc/ blocked IPs

alias finder='open `pwd`'

alias ws='python -m SimpleHTTPServer'

alias rmlog='rm -rfv target/*.log'
alias rmsock='rm -rfv ~/.ssh/sockets/*'
alias reload='exec $SHELL -l'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"

## GRAILS ##
alias gt='grails test-app'
alias openTest='open target/test-reports/html/failed.html'
alias watchlog="tail -f target/"$(pwd | xargs basename)"-*-local.log"

## VAGRANT ##
alias vu="vagrant up"
alias vs="vagrant ssh"
alias vh="vagrant halt"
alias vd="vagrant destroy"


#eval "$(thefuck --alias)"
