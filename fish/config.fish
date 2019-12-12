set -x GOPATH $HOME/.go
set -x CARGO_HOME $HOME/.cargo
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin $CARGO_HOME/bin

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent.ssh

alias tree="tree -L 2"
alias psg="ps aux | grep"

if type -q nvim
    alias vim="nvim"
    alias vimdiff="nvim -d"
end
if type -q direnv
    direnv hook fish | source
end

#mac
alias appadd="brew install"
alias appup="brew update && brew upgrade && brew cleanup"
alias appsch="brew search"
alias appdel="brew uninstall"
alias appclean="brew cleanup"
alias appinfo="brew info"

alias appextadd="brew cask install"
alias appextsch="brew cask search"
alias appextdel="brew cask uninstall"
alias appextup="brew cask upgrade"
