source "${HOME}/.bashrc"
PATH=$HOME/bin:$PATH

export BROWSER="nightly"
export EDITOR="gvim"

if [[ -z $DISPLAY ]] && ! [[ -e /tmp/.X11-unix/X0 ]] && (( EUID )); then
    exec startx -- vt7 >& '~/.xsession-errors' &
fi

