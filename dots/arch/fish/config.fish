set -x GOPATH $HOME/.go
set -x CARGO_HOME $HOME/.cargo
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin $CARGO_HOME/bin

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
gpg-connect-agent updatestartuptty /bye > /dev/null

alias tree="tree -L 3"
alias psg="ps aux | grep"

if type -q nvim
    alias vim="nvim"
    alias vimdiff="nvim -d"
end
if type -q direnv
    direnv hook fish | source
end

# history across fishes
function save_history --on-event fish_preexec
    history --save
    history --merge
end
alias hr 'history --merge'  # read and merge history from disk
bind \e\[A 'history --merge ; up-or-search'

alias appadd "sudo pacman -S"
alias appup "sudo pacman -Syu"
alias appsch "pacman -Ss"
alias appdel "sudo pacman -Rs"
alias appclean "sudo pacman -Scc && pacman -Qdtq | pacman -Rs -"
alias appinfo "pacman -Si"

alias appextadd "yay -S"
alias appextup "yay -Syu"
alias appextsch "yay -Ss"
alias appextdel "yay -Rs"
