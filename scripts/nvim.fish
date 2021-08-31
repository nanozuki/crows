function sync_nvim
    title "sync nvim"

    # install nvim and language environment
    if test $os = archlinux
        pacman_install neovim
        pacman_install python-pynvim nodejs-lts-fermium npm ripgrep fzf
        sudo npm -g install neovim
    else if test $os = macos
        brew_install neovim python node@14 ripgrep fzf
        brew link --force node@14
        pip3 install pynvim
        npm -g install neovim
    end

    # update nvim and language environment
    if test $os = archlinux
        sudo npm -g update neovim
    else if test $os = macos
        pip3 install -U pynvim
        npm -g update neovim
    end

    # link config
    link_dir $dots/nvim $config/nvim

    # install plugins manager
    set packer ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    if not test -d $packer
        git clone https://github.com/wbthomason/packer.nvim $packer
    end

    # sync components requirements
    sync_lua
    sync_bat
end

function sync_lua
    if test $os = archlinux
        yay_install lua-language-server
    else if test $os = macos
        macos_lua_lsp
    end
    cargo install stylua # lua formatter
end

function macos_lua_lsp
    brew_install ninja
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

function sync_bat # used by lsputils
    if test $os = archlinux
        pacman_install bat
    else if test $os = macos
        brew_install bat
    end
    mkdir -p $config/bat
    ln -sf $dots/bat/config $config/bat/config
end
