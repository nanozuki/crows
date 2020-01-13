#!/bin/bash

if [[ "$1" == "bootstrap" ]]; then
    echo "== Crows Env Bootstrap  =="
    echo ""
elif [[ "$1" == "upgrade" ]]; then
    echo "== Crows Env Upgrade =="
    echo ""
elif [[ "$1" == "update" ]]; then
    echo "== Crows Env Update =="
    echo ""
else
    echo "Invalid Argument"
    echo "crows-env.sh <bootstrap|upgrade|update>"
    exit 1
fi

platform=
uname=`uname`
if [[ "$uname" == 'Darwin' ]]; then
   platform='osx'
elif [[ "$uname" == 'Linux' ]]; then
   issue=`cat /etc/issue`
   if [[ "$issue" == Arch* ]]; then
       platform="arch"
   fi
else
    echo "unsupport platform"
    exit 1
fi
echo "Platform is $platform"

target_path="$HOME"
source_path="$HOME/.data/CrowsEnv"
config_path="$HOME/.config/CrowsEnv"

echo "target_path: $target_path"
echo "source_path: $source_path"
echo "config_path: $config_path"
echo ""

if [[ "$1" == "upgrade" ]]; then
    source $source_path/upgrade.sh
    exit 0
elif [[ "$1" == "update" ]]; then
    source $source_path/update.sh
    exit 0
fi

md () {
    mkdir -p $1 &> /dev/null || true
}


echo "Platform is $platform, install basic dependencies..."
if [[ "$platform" == "osx" ]]; then
    xcode-select --install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install git make fish tmux neovim go python node yarn rustup-init gnupg tree ripgrep pinentry-mac direnv
    brew cask install squirrel
    rustup-init
    pip3 install pynvim neovim
    yarn global add neovim
elif [[ "$platform" == "arch" ]]; then
    sudo pacman -S --noconfirm base-devel fish tmux neovim go python nodejs yarn rustup gnupg fcitx-rime ripgrep direnv
    rustup set profile complete
    rustup update stable
    sudo pip install pynvim neovim
    yarn global add neovim
fi

echo "Getting CrowsEnv Data..."
md $source_path
git clone https://github.com/nanozuki/CrowsEnv.git $source_path

echo "Preparing files..."
#fish
md $target_path/.config/fish/conf.d
#fish omf
curl -L https://get.oh-my.fish > install
fish install --path=$target_path/.data/omf --config=$target_path/.config/omf

# git
md $target_path/.config/git
cp $config_path/git/* $target_path/.config/git
if [[ -f "$target_path/.config/git/config_local" ]]; then
    touch $target_path/.config/git/config_local
fi

# gnupg sshconfig
md $target_path/.gnupg

# nvim
md $target_path/.config/nvim

# ssh
md $target_path/.ssh
cp $config_path/sshkeys/* $target_path/.ssh

# TODO: gpg keys

# link config file
source $source_path/update.sh

# vim plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
vim temp.go +GoInstallBinaries +qall

if [[ "$platform" == "osx" ]]; then
    ln -sf $source_path/crows-env.sh /usr/local/bin/crows-env
    echo "Bootstrap completed! Have fun from fresh new fish!"
    echo '/usr/local/bin/fish' | sudo tee -a /etc/shells
    chsh -s /usr/local/bin/fish
elif [[ "$platform" == "arch" ]]; then
    sudo ln -sf $source_path/crows-env.sh /usr/local/bin/crows-env
    echo "Bootstrap completed! Have fun from fresh new fish!"
    chsh -s /bin/fish
fi
