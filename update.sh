#!/bin/bash

#fish
echo "Linking fish config..."
ln -sf $source_path/dots/$platform/fish/config.fish $target_path/.config/fish/config.fish
ln -sf $source_path/dots/common/before.init.fish $target_path/.config/fish/conf.d/before.init.fish
#omf
ln -sf $source_path/dots/common/omf $target_path/.config/omf
#git
echo "Linking global git config..."
ln -sf $source_path/dots/common/git/config $target_path/.config/git/config
#tmux
echo "Linking tmux config..."
ln -sf $source_path/dots/common/tmux/config $target_path/.tmux.conf
#nvim
echo "Linking nvim config..."
ln -sf $source_path/dots/$platform/nvim/init.vim $target_path/.config/nvim/init.vim
ln -sf $source_path/dots/common/vim/vim $target_path/.vim
ln -sf $source_path/dots/common/vim/vimrc $target_path/.vimrc
#rime
echo "Linking rime config..."
if [[ "$platform" == "osx" ]]; then
    ln -sf $source_path/dots/common/rime/default.custom.yaml $target_path/Library/Rime/default.custom.yaml
elif [[ "$platform" == "arch" ]]; then
    ln -sf $source_path/dots/common/rime/default.custom.yaml $target_path/.config/fcitx/rime/default.custom.yaml
fi
echo ""
echo "Update complete!"
