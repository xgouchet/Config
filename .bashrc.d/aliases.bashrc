
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -FlG --color'
alias la='ls -FlAG --color'

alias weather='curl wttr.in'
alias gw='./gradlew'

export EDITOR="nano"
setxkbmap -option "nbsp:none"



keys=$(ssh-add -l | grep -c gouchet)
if [ "$keys" -eq "0" ]; then
    ssh-add -k
fi
