alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ \1/'"

alias irssi="screen irssi"
alias byzm1="byz -x 0 -y 0 -w 1680 -h 1050"
alias byzm2="byz -x 1680 -y 0 -w 1920 -h 1080"

alias ls="ls --color=always"
alias ll="ls -l"

alias portkeys="sudo vim /etc/portage/package.keywords"
alias portuse="sudo vim /etc/portage/package.use"
alias portunmask="sudo vim /etc/portage/package.unmask"
alias portmask="sudo vim /etc/portage/package.mask"
alias portlicense="sudo vim /etc/portage/package.license"

function u2space()
{
    for file in *; do
        echo Renaming "$file" to "${file//_/ }"
        mv "$file" "${file//_/ }"
    done
}

export PS1="\[\e[0;31m\]┌\[\e[0;37m\][\[\e[1;31m\]\u\[\e[0;37m\]@\[\e[0;35m\]\h\[\e[0;37m\]]\[\e[0;31m\]─\[\e[0;37m\][\[\e[0;33m\]\w\[\e[0;35m\]\$(__git_ps1)\[\e[0;37m\]]
\[\e[0;31m\]└─\[\e[1;31m\]$ \[\e[0m\]"

