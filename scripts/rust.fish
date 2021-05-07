function install_rust
    set_env_nx CARGO_HOME $HOME/.cargo
    fish_add_path $CARGO_HOME/bin
    if not type -q rustup
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    end
end

function update_rust
    rustup update
end
