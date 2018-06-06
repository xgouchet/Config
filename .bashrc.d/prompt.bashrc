
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    xterm) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# Configure Git PS1
GIT_PS1_DESCRIBE_STYLE='describe'
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_SHOWUPSTREAM='verbose git'
GIT_PS1_STATESEPARATOR=' '

# pretty_git_ps1=`__git_ps1`
pretty_git_ps1() {
    __git_ps1 |
        sed 's/</∇/'    | # upstream ahead
        sed 's/>/∆/'    | # upstream behind
        sed 's/[$]/Σ/'  | # sigma = stash available
        sed 's/*/δ/'    | # delta = dirty files
        sed 's/%/υ/'    | # upsilon = untracked files
        sed 's/+/ι/'    | # iota = indexed files
        sed 's/#/·/'    | # pound = orphan branch
        sed 's/=/✓/'    | # upstream identical to local
        sed 's/ uι/ +/' | # upstream change count
        sed 's/ u/ /'   | # upstream info
        sed 's/#/·/'    | # pound = orphan branch
        sed 's/(/⫯ /'   | # prefix
        sed 's/)//'
}

# Prompt
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[1;37m\](\D{%H:%M}) ${debian_chroot:+($debian_chroot)}\[\033[1;31m\]\u\[\033[1;37m\]@\[\033[1;36m\]\h\[\033[1;37m\]:\[\033[01;32m\]\w\[\033[01;33m\]$(pretty_git_ps1)\[\033[00m\]\n\[\033[1;36m\]→ \[\033[00m\]'
else
    PS1='(\D{%H:%M}) ${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi


unset color_prompt force_color_prompt
