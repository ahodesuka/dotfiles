alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ \1/'"

alias byzm1="byz -x 0 -y 0 -w 1680 -h 1050"
alias byzm2="byz -x 1680 -y 0 -w 1920 -h 1080"

alias ls="ls --color=always"
alias ll="ls -l"
alias global_sync="sudo emerge --sync && sudo layman -S"

u2space()
{
    for file in *; do
        if [ "$file" == "${file//_/}" ]; then continue; fi
        echo Renaming "$file" to "${file//_/ }"
        mv "$file" "${file//_/ }"
    done
}

mkdir(){ /bin/mkdir -p "$@" && cd "$_"; }

export PS1="\[\e[0;31m\]┌\[\e[0;37m\][\[\e[1;31m\]\u\[\e[0;37m\]@\[\e[0;35m\]\h\[\e[0;37m\]]\[\e[0;31m\]─\[\e[0;37m\][\[\e[1;37m\]\w\[\e[0;35m\]\$(__git_ps1)\[\e[0;37m\]]
\[\e[0;31m\]└─\[\e[1;31m\]$ \[\e[0m\]"

