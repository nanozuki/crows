function install_tmux
    echo "Install tmux..."
    if test $os = archlinux
        pacman_install tmux
    else if test $os = macos
        brew_install tmux
    end
    mkdir -p $config/tmux
    for file in (ls $dots/tmux/)
        ln -sf $dots/tmux/$file $config/tmux/$file
    end
    install_tpm
end

function install_tpm
    if not test -d $config/tmux/plugins/tpm
        echo "install tpm"
        git clone https://github.com/tmux-plugins/tpm $config/tmux/plugins/tpm
    end
    $config/tmux/plugins/tpm/bin/install_plugins
    $config/tmux/plugins/tpm/bin/clean_plugins
end

function update_tmux
    echo "Install tmux..."
    update_tpm
end

function update_tpm
    $config/tmux/plugins/tpm/bin/update_plugins all
end
