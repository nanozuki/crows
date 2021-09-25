function sync_zig
    title "sync zig"
    if test $os = archlinux
        paru_install zig zls-bin
        ln -sf $dots/lsp/zls_arch.json $config/zls.json
    else if test $os = macos
        brew_install zig
        macos_zls
    end
end

function macos_zls
    set repo https://github.com/zigtools/zls.git
    set repo_path (git_latest $repo); or return 1
    if test -z $repo_path
        return 0
    end

    set cur_dir (pwd)
    cd $repo_path
    git submodule update --init --recursive
    zig build -Drelease-safe
    # ./zig-out/bin/zls config # Configure ZLS
    ln -sf $dots/lsp/zls_osx.json $HOME/Library/Application\ Support/zls.json
    ln -sf (realpath ./zig-out/bin/zls) /usr/local/bin/zls
    cd $cur_dir
end
