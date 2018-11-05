#!/bin/bash

# check os
OS="Unknown"
if [[ `uname -s` == "Darwin" ]]; then
    OS="macOS"
elif [ -f "/etc/issue" ]; then
    if [[ `cat /etc/issue` =~ '^Arch Linux' ]]; then
        OS="ArchLinux"
    elif [[ `cat /etc/issue` =~ '^Ubuntu' ]]; then
        OS="Ubuntu"
    fi
fi
if [[ "$OS" == "Unknown" ]]; then
    echo "Unknown OS"
    exit
fi

# macOS
if [[ "$OS" == "macOS" ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install git zsh tree tmux python go rust node npm yarn nvim ripgrep cmake
    mkdir $HOME/Source
    git clone https://github.com/CrowsT/CrowsEnv.git
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "source ~/Source/CrowsEnv/zsh/.crows-zsh" >> .zshrc
    echo "source ~/Source/CrowsEnv/zsh/.crows-mac-zsh" >> .zshrc
    ln -sf $HOME/Source/CrowsEnv/tmux/.tmux.conf $HOME/.tmux.conf
    ln -sf $HOME/Source/CrowsEnv/vim/.vimrc $HOME/.vimrc
    rm -rf $HOME/.vim
    ln -sf $HOME/Source/CrowsEnv/vim/.vim $HOME/.vim
    ln -sf $HOME/Source/CrowsEnv/tern/.tern-config.js $HOME/.tern-configs.js
    source .zshrc
    pip install flake8 ipython

    #vim
    mkdir $HOME/.vim/plugins
    mkdir -p $HOME/.config/nvim
    ln -sf $HOME/Source/CrowsEnv/nvim/init.vim $HOME/.config/nvim/init.vim
    vim +PlugInstall +qall
    cd $HOME/.vim/plugins/YouCompleteMe
    git submodule update --init --recursive
    python3 install.py --clang-completer --go-completer --js-completer --rust-completer --system-libclang
    cd $HOME/.vim/plugins/tern_for_vim
    npm install
    cd $HOME
fi
