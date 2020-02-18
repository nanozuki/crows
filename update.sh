#!/bin/bash
if [[ "$platform" == "osx" ]]; then
    brew update && brew upgrade && brew cleanup
    brew cask upgrade
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U
elif [[ "$platform" == "arch" ]]; then
    sudo pacman -Syu
    yay -Syu
    sudo pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 sudo pip install -U
fi

rustup update
yarn global upgrade
nvim temp.go +PlugUpgrade +PlugUpdate +GoUpdateBinaries +qall
