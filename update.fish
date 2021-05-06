if test $os = archlinux
    sudo pacman -Syu
    yay -Syu
    sudo npm -g update
else if test $os = macos
    brew update && brew upgrade && brew cleanup
    brew upgrade --cask
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
    npm -g update
end

rustup update
nvim +PlugUpgrade +PlugUpdate +qall
nvim $project/refer/gotmp/main.go +GoUpdateBinaries +3sleep +qall
$HOME/.config/tmux/plugins/tpm/bin/update_plugins all
