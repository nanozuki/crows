cd $project
git pull
cd -

# fish
echo "Linking fish config..."
mkdir -p $HOME/.config/fish/conf.d
mkdir -p $HOME/.config/fish/functions
ln -sf $project/dots/common/fish/config.fish $HOME/.config/fish/config.fish
# fish functions
ln -sf $project/dots/common/fish/functions/gitget.fish $HOME/.config/fish/functions/gitget.fish
ln -sf $project/dots/common/fish/functions/detect_os.fish $HOME/.config/fish/functions/detect_os.fish
# omf
ln -sfF $project/dots/common/omf $HOME/.config/omf

# git
echo "Linking global git config..."
mkdir -p $HOME/.config/git
ln -sf $project/dots/common/git/config $HOME/.config/git/config

# tmux
echo "Linking tmux config..."
mkdir -p $HOME/.config/tmux
ln -sf $project/dots/common/tmux/config $HOME/.config/tmux/tmux.conf
ln -sf $project/dots/common/tmux/config.light $HOME/.config/tmux/tmux.conf.light
ln -sf $project/dots/common/tmux/config.dark $HOME/.config/tmux/tmux.conf.dark
$HOME/.config/tmux/plugins/tpm/bin/install_plugins #TODO
$HOME/.config/tmux/plugins/tpm/bin/clean_plugins #TODO

# gnupg-agent
mkdir -p $HOME/.gnupg
ln -sf $project/dots/$platform/gnupg/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf

# rime
if test $os = archlinux
    echo "Linking rime config..."
    mkdir -p $HOME/.config/fcitx/rime
    ln -sf $project/dots/common/rime/default.custom.yaml $HOME/.config/fcitx/rime/default.custom.yaml
end

# nvim
echo "Linking nvim config..."
ln -sfF $project/dots/common/nvim $HOME/.config/nvim
nvim +PlugClean +PlugInstall +qall

echo ""
echo "Upgrade complete!"
