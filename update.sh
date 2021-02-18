#!/bin/bash
if [[ "$platform" == "osx" ]]; then
    brew update && brew upgrade && brew cleanup
    brew upgrade --cask
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
    npm -g update
elif [[ "$platform" == "arch" ]]; then
    sudo pacman -Syu
    yay -Syu
    pip list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --user -U
    sudo npm -g update
fi

rustup update
nvim +PlugUpgrade +PlugUpdate +qall
nvim $source_path/refer/gotmp/main.go +GoUpdateBinaries +3sleep +qall
$target_path/.config/tmux/plugins/tpm/bin/update_plugins all
