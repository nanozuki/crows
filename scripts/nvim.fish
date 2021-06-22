function sync_nvim
    title "sync nvim"

    # install nvim and language environment
    if test $os = archlinux
        yay_install neovim-nightly-bin
        pacman_install python-pynvim nodejs npm ripgrep fzf
        sudo npm -g install neovim
        yay_install lua-language-server
    else if test $os = macos
        brew_head luajit neovim
        brew_install node python ripgrep fzf
        pip3 install pynvim
        npm -g install neovim
    end

    # update nvim and language environment
    if test $os = archlinux
        sudo npm -g update neovim
    else if test $os = macos
        pip3 install -U pynvim
        npm -g update neovim
        macos_lua_lsp
    end

    # link config
    link_dir $dots/nvim $config/nvim

    # install and clean plugins
    if not test -f $config/nvim/autoload/plug.vim
        curl -fLo $config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    end
    nvim +PlugClean +PlugInstall +qall

    # update plugins
    nvim +PlugUpgrade +PlugUpdate +qall
end

function macos_lua_lsp
    set repo https://github.com/sumneko/lua-language-server.git
    set repo_path (git_latest $repo); or return 1
    if test -z $repo_path
        return 0
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