_complete_ssh_hosts () {
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
  cut -f 1 -d ' ' | \
  sed -e s/,.*//g | \
  grep -v ^# | \
  uniq | \
  grep -v "\[" ;
  cat ~/.ssh/config | \
  grep "^Host " | \
  awk '{print $2}'
  `
  COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
  return 0
}

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip


rgc() {
  git commit -am"`curl -s http://whatthecommit.com/index.txt`"
}

64encode() {
  echo $1 | base64
}

64decode() {
  echo $1 | base64 --decode
}

cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}
