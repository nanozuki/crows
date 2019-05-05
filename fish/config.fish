set -x GOPATH $HOME/.go
set -x PATH /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin $GOPATH/bin
set -x XDG_CONFIG_HOME "$HOME/.config/"

set -x XDG_CACHE_HOME "$HOME/.cache/"
set -x XDG_DATA_HOME "$HOME/.data/"

set -x HOMEBREW_GITHUB_API_TOKEN 5e3a008b84a0e66ecd4110d9a59753129f5a0bc4

set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK /Users/crows/.gnupg/S.gpg-agent.ssh

alias tree="tree -L 2"
alias psg="ps aux | grep"

if type -q vim
    alias vim="nvim"
end
if type -q direnv
    direnv hook fish | source
end

#mac
alias appadd="brew install"
alias appup="brew update -v && brew upgrade && brew cleanup"
alias appsch="brew search"
alias appdel="brew uninstall"
alias appclean="brew cleanup"
alias appinfo="brew info"

alias appextadd="brew cask install"
alias appextsch="brew cask search"
alias appextdel="brew cask uninstall"
