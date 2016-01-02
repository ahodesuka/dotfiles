source ~/.git-prompt.sh

export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

alias byzm1="byz -x 0 -y 0 -w 1680 -h 1050"
alias byzm2="byz -x 1680 -y 0 -w 1920 -h 1080"
alias grep="grep --color=auto"
alias ls="ls --color=always -h"
alias ll="ls -l"
alias cue2flac="find -type f -name '*.cue' -execdir cue2tracks -R -n 19 -o '%N. %p ─ %t' {} \;"
alias patchAnime="find -type f -name '*.xdelta' -maxdepth 1 -exec xdelta3 -d '{}' \;"
alias make="make -j5"
alias gdb="gdb -q"
alias du="cdu -d ch"
alias mpv="mpv --msg-level=ffmpeg=error"

function u2space()
{
    for file in *; do
        if [ "$file" != "${file/_/ }" ]; then
            mv -v "$file" "${file/_/ }"
        fi
    done
}

function rAnime()
{
    anime=(~/Anime/*)
    printf "You should watch %s.\n" "${anime[RANDOM % ${#anime[@]}]##*/}"
}

function mkcdir()
{
    /bin/mkdir -p $@ && cd "$_"
}

autoload -U compinit && compinit
source ~/.npm-completion.sh

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt promptsubst

stty -ixon

unsetopt equals

zstyle ":completion::complete:*" use-cache 1

# Home
bindkey "[1~" beginning-of-line
# End
bindkey "[4~" end-of-line
# Ins
bindkey "[2~" overwrite-mode
# Del
bindkey "[3~" delete-char
# Pg Up
bindkey "[5~" history-beginning-search-backward
# Pg Down
bindkey "[6~" history-beginning-search-forward

function precmd { print -Pn "\e]0;%n@%M:%~\a" }

typeset -Ag FG BG
RESET="%{[00m%}"
for color in {0..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

export PS1="$FG[236]$BG[235]$FG[9] %~ $FG[235]$BG[1]$FG[0]\$(__git_ps1 '  %s')$RESET$FG[1] $RESET"

unset FG BG RESET

if ! [[ `tty` =~ ^/dev/tty.* ]]; then
    eval $(dircolors -b ~/.dircolors)
fi
