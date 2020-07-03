source ~/.zplug/init.zsh
source /usr/share/git/git-prompt.sh

export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

alias byzm1="byz -x 0 -y 0 -w 1680 -h 1050"
alias byzm2="byz -x 1680 -y 0 -w 1920 -h 1080"
alias grep="grep --color=auto"
alias ls="ls++ --psf"
alias ll="ls++ --potsf"
alias cue2flac="find -type f -name '*.cue' -execdir cue2tracks -R -n 19 -o '%N. %p ─ %t' {} \;"
alias patchAnime="find -type f -name '*.xdelta' -maxdepth 1 -exec xdelta3 -d '{}' \;"
alias make="make -j7"
alias gdb="gdb -q"
alias du="cdu -d ch"

function base64decode()
{
    echo "$1" | base64 -d
}

function u2space()
{
    for file in *; do
        if [ "$file" != "${file//_/ }" ]; then
            mv -v "$file" "${file//_/ }"
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

# Colorize man pages
function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;34m") \
        LESS_TERMCAP_md=$(printf "\e[1;34m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;33m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        PAGER="${commands[less]:-$PAGER}" \
        man "$@"
}

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "Valodim/zsh-curl-completion"
zplug "gentoo/gentoo-zsh-completions"
zplug "lukechilds/zsh-better-npm-completion", defer:2

autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

zle_highlight+=(paste:none)

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

setopt inc_append_history
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt prompt_subst

stty -ixon -ixoff

unsetopt equals

if [ "$TERM" != "linux" ]; then
    eval $(dircolors -b ~/.dircolors)
fi

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
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
bindkey "[5~" history-substring-search-up
# Pg Down
bindkey "[6~" history-substring-search-down

# Ctrl+Space
bindkey "^ " autosuggest-accept

typeset -Ag FG BG
RESET="%{[00m%}"
for color in {0..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

function __powerline_ps1
{
    local out=""

    # Root
    if [[ ${UID} -eq 0 ]]; then
        out+="$FG[15]$BG[160] ROOT $RESET"
    fi

    # SSH Lock icon
    if [ "$SSH_CONNECTION" ]; then
        if [[ ${UID} -eq 0 ]]; then
            out+="$FG[160]$BG[12]$RESET"
        fi
        out+="$FG[0]$BG[12]  $FG[12]$BG[235]$RESET"
    else
        if [[ ${UID} -eq 0 ]]; then
            out+="$FG[160]$BG[235]$RESET"
        else
            out+="$FG[236]$BG[235]$RESET"
        fi
    fi

    # PWD
    local pwd=$(pwd)
    local path="${pwd/$HOME/~}"
    local parts=(${(s:/:)path})

    if [ $path != "/" ] && [ $path != "~" ]; then
        local i=1
        path=""
        for p in $parts; do
            if [[ ${#parts[@]} == 1 ]]; then
                path="${parts[@]}"
            elif [[ ${#parts[@]} -gt 4 && $i == 2 ]]; then
                path="$path…"
            elif [ ${#parts[@]} -lt 4 ] || [ $i -lt 3 ] || (( $i >= ${#parts[@]} - 1)); then
                path="$path${parts[$i]}"
            else
                ((i += 1))
                continue
            fi

            [ $i != ${#parts[@]} ] && path+="$FG[234] $FG[9]"

            ((i += 1))
        done
    fi
    out+="$FG[9]$BG[235] $path $RESET"

    # Git info
    out+="$FG[235]$BG[9]$FG[0]\$(__git_ps1 '  %s')$RESET$FG[9]$RESET "

    export PS1=$out
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __powerline_ps1

function precmd { print -Pn "\e]0;%n@%M:%~\a" }

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
export ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red,bold,underline"
export ZSH_HIGHLIGHT_STYLES[arg0]="fg=green,bold"
export ZSH_HIGHLIGHT_STYLES[path]="fg=blue,bold"
export ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=magenta,bold"
export ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=magenta,bold"
