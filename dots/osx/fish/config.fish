set -x GOPATH $HOME/.go
set -x CARGO_HOME $HOME/.cargo
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin $CARGO_HOME/bin

set -x LC_ALL en_US.UTF-8
set -x LANG en_US.UTF-8

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent.ssh
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

alias appadd "brew install"
alias appup "brew update && brew upgrade && brew cleanup"
alias appsch "brew search"
alias appdel "brew uninstall"
alias appclean "brew cleanup"
alias appinfo "brew info"

alias appextadd "brew cask install"
alias appextsch "brew search"
alias appextdel "brew cask uninstall"
alias appextup "brew cask upgrade"
