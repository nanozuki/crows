#!/bin/bash
if [[ "$platform" == "osx" ]]; then
    brew update && brew upgrade && brew cleanup
    brew cask upgrade
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
    npm -g update
elif [[ "$platform" == "arch" ]]; then
    sudo pacman -Syu
    yay -Syu
    pip list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --user -U
    sudo npm -g update
fi

rustup update
nvim temp.go +PlugUpgrade +PlugUpdate +GoUpdateBinaries +qall