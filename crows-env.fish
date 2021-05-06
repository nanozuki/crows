#!/usr/bin/env fish
set project (status dirname)

source $project/dots/common/fish/functions/detect_os.fish
source $project/dots/common/fish/functions/gitget.fish
detect_os

switch $argv[1]
    case upgrade
        source $project/upgrade.fish
        exit 0
    case update
        source $project/update.fish
        exit 0
    case bootstrap
        echo "== Crows Env Bootstrap  =="
        echo ""
    case '*'
        echo "Invalid Argument"
        echo "crows-env.sh <bootstrap|upgrade|update>"
        exit 1
end

# == Crows Env Bootstrap ==

if test $os = archlinux
    sudo pacman -S --noconfirm base-devel tmux neovim go python python-pip nodejs npm rustup gnupg fcitx-rime ripgrep
    rustup update stable
    sudo pip install pynvim neovim
    sudo npm -g install neovim
    gitget "~/Projects/aur.archlinux.org/yay"
	makepkg -si --noconfirm
	cd -
    yay -S --noconfirm direnv
else if test $os = macos
    brew install make tmux neovim go python node rustup-init gnupg tree ripgrep pinentry-mac direnv
    brew cask install squirrel
    rustup-init
    pip3 install pynvim neovim
    npm -g install neovim
end

#install omf
curl -L https://get.oh-my.fish > /tmp/install
fish /tmp/install --path=$target_path/.local/share/omf --config=$target_path/.config/omf

# git
md $target_path/.config/git
cp $config_path/git/* $target_path/.config/git
if test -f $HOME/.config/git/config_local
    touch $HOME/.config/git/config_local
fi

# ssh
mkdir -p $HOME/.ssh
cp $config_path/sshkeys/* $target_path/.ssh

# gpg keys
# echo "Import gpg public keys..."
# for file in `ls $config_path/gpgkeys/*_pb.gpg`; do
#     gpg --import $file
# done
# echo "Import secret keys..."
# for file in `ls $config_path/gpgkeys/*_sec.gpg`; do
#     gpg --allow-secret-key-import --import $file
# done

# link config file
source $project/upgrade.sh

# vim plugins
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
vim temp.go +GoInstallBinaries +qall

# tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
