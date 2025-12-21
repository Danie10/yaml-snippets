#
# ~/.bashrc
#
 
# Use bash-completion, if available, with <TAB> <TAB> - from https://github.com/scop/bash-completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
 
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
 
# Show system stats
alias stats='neofetch'
 
# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
 
# Directory listings
alias lsall='exa -l --all --icons --group-directories-first --header'
alias lsdir='exa --tree --only-dirs --level=3'
alias ls='ls -g --group-directories-first --color=auto'  # Default if ls used
 
# Directory space usage
alias space='ncdu -x --exclude /run/media --color dark /'
 
# Search command line history then i=use !no to execute line no
alias h="history|grep "
 
# Search running processes
alias p="ps aux|grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
 
# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
 
# Show current network connections to the server
alias ipview="netstat -anpl | grep :80 | awk {'print \$5'} | cut -d\":\" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
 
# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
 
# Enable history appending instead of overwriting.  #139609
shopt -s histappend
# Ignore duplicates for History
export HISTCONTROL=ignoredups
 
# Run Autojump folder navigation with letter 'j'
. /usr/share/autojump/autojump.bash
 
# Run starship command prompt
eval "$(starship init bash)"
