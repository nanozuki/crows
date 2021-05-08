function install_nvim
    if test $os = archlinux
        pacman_install neovim pynvim nodejs npm ripgrep fzf
        sudo npm -g install neovim
    else if test $os = macos
        brew_install neovim node python luajit ripgrep fzf
        pip3 install pynvim
        npm -g install neovim
    end
    link_dir $dots/nvim $config/nvim
    if not test -f $config/nvim/autoload/plug.vim
        curl -fLo $config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    end
    lua_lsp
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
    lua_lsp
    sudo npm -g update neovim
    nvim +PlugUpgrade +PlugUpdate +qall
end

function lua_lsp
    set repo https://github.com/sumneko/lua-language-server.git
    set repo_path (find_git_repo_path $repo)
    if test -e $repo_path
        if test (git pull | grep 'Already up to date')
            return 0
        end
    else
        echo "git clone $repo $repo_path"
        git clone $repo $repo_path
        or return 1
    end

    set cur_dir (pwd)
    cd $repo_path
        git submodule update --init --recursive
        cd 3rd/luamake
        compile/install.sh
        cd ../..
        ./3rd/luamake/luamake rebuild
    cd $cur_dir
end
