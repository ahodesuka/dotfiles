alias __git_ps1="git branch 2> /dev/null | grep '*' | sed 's/* \(.*\)/  \1/'"
alias byzm1="byz -x 0 -y 0 -w 1680 -h 1050"
alias byzm2="byz -x 1680 -y 0 -w 1920 -h 1080"
alias ls="ls --color=always"
alias ll="ls -l"
alias cue2flac="find -type f -name '*.cue' -execdir cue2tracks -R -n 19 -o '%N. %p ─ %t' {} \;"
alias patchAnime="find -type f -name '*.xdelta' -maxdepth 1 -exec xdelta3 -d '{}' \;"
alias make="make -j5"

u2space()
{
    for file in *; do
        if [ "$file" == "${file//_/}" ]; then continue; fi
        echo Renaming "$file" to "${file//_/ }"
        mv "$file" "${file//_/ }"
    done
}

rAnime()
{
    anime=(~/Anime/*)
    printf "You should watch %s.\n" "${anime[RANDOM % ${#anime[@]}]##*/}"
}

mkcdir()  { /bin/mkdir -p "$@" && cd "$_";  }

autoload -U compinit && compinit
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zshistory
setopt inc_append_history
setopt promptsubst
unsetopt equals
zstyle ':completion::complete:*' use-cache 1

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[2~" overwrite-mode
bindkey "^[[3~" delete-char
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

function precmd { print -Pn "\e]0;%n@%M:%~\a" }

export PS1="%{[38;05;236;48;05;235m%}%{[38;05;9;48;05;235m%} %~ %{[38;05;235;48;05;1m%}%{[00m%}%{[38;05;0;48;05;1m%}\$(__git_ps1)%{[00m%}%{[38;05;1m%} %{[00m%}"

