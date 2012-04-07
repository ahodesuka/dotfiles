alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ \1/'"

alias irssi="screen irssi"

alias ls="ls --color=always"
alias ll="ls -l"

function ___padding()
{
    ret="─"
    mWIDTH="104"
    uhL="$(echo ┌[$USER@$HOSTNAME] | awk '{print length}')"
    pwdL="$(echo [$PWD$(__git_ps1)] | sed -e 's/\/home\/mokou/~/' | awk '{print length}')" # I A SHIT
    let MAX=$mWIDTH-$uhL-$pwdL-1
    for i in `seq 1 $MAX`; do ret="${ret}─"; done
    echo -n $'\e[0;31m'$ret
}

export PS1="\[\e[0;31m\]┌\[\e[0;37m\][\[\e[1;31m\]\u\[\e[0;37m\]@\[\e[0;35m\]\h\[\e[0;37m\]]\$(___padding)\[\e[0;37m\][\[\e[0;31m\]\w\[\e[0;35m\]\$(__git_ps1)\[\e[0;37m\]]
\[\e[0;31m\]└──\[\e[0;31m\]─\[\e[1;31m\]$ \[\e[0m\]"

