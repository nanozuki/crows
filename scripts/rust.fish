function sync_rust
    title "sync rust"

    set_env CARGO_HOME $XDG_DATA_HOME/cargo
    set_env RUSTUP_HOME $XDG_DATA_HOME/rustup
    add_path $CARGO_HOME/bin
    
    # install or update
    if not type -q rustup
        echo "install rustup"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        if not test (date_cache get rustup_update)
            rustup -q update
            date_cache set rustup_update
        end
    end

    # install rust-analyzer
    if test $os = archlinux
        paru_install rust-analyzer
    else if test $os = macos
        brew_install rust-analyzer
    end
end
