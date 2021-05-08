function install_rust
    echo "Install rust..."
    set_env_nx CARGO_HOME $HOME/.cargo
    fish_add_path $CARGO_HOME/bin
    if not type -q rustup
        echo "install rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    end
    if test $os = archlinux
        pacman_install rust-analyzer
    else if test $os = macos
        brew_install rust-analyzer
    end
end

function update_rust
    echo "Update rust..."
    rustup update
end
