function install_nvim
    if test $os = archlinux
        pacman_install neovim pynvim nodejs npm ripgrep fzf
        sudo npm -g install neovim
    else if test $os = macos
        brew_install neovim node python luajit ripgrep fzf
        pip3 install pynvim
        npm -g install neovim
    end
    if not test -f $config/nvim/autoload/plug.vim
        curl -fLo $config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    end
    ln -sfF $dots/nvim $config/nvim
    nvim +PlugClean +PlugInstall +qall
end

function update_nvim
    if test $os = archlinux
        sudo npm -g update neovim
    else if test $os = macos
        brew_install neovim node python luajit ripgrep fzf
        npm -g update neovim
        pip3 install -U pynvim
    end
    sudo npm -g update neovim
    nvim +PlugUpgrade +PlugUpdate +qall
end
