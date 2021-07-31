set -x GPG_TTY (tty)
if test $os = archlinux
    set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
else if test $os = macos
    set -x SSH_AUTH_SOCK $HOME/.gnupg/S.gpg-agent.ssh
end
gpg-connect-agent updatestartuptty /bye >/dev/null

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
alias hr 'history --merge' # read and merge history from disk
bind \e\[A 'history --merge ; up-or-search'

if test $os = archlinux
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
else if test $os = macos
    alias appadd "brew install"
    alias appup "brew update && brew upgrade --force-bottle && brew cleanup"
    alias appsch "brew search"
    alias appdel "brew uninstall"
    alias appclean "brew cleanup"
    alias appinfo "brew info"

    alias appextadd "brew install --cask"
    alias appextsch "brew search"
    alias appextdel "brew uninstall --cask"
    alias appextup "brew upgrade --cask"
end
