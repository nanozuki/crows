function install_zig
    echo "Install zig..."
    if test $os = archlinux
        pacman_install zig
        yay_install zls-bin
    else if test $os = macos
        brew_head zig
        macos_zls
    end
end

function update_zig
    echo "Update zig..."
    if test $os = macos
        brew_head zig
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
        ./zig-out/bin/zls config # Configure ZLS
        ln -sf (realpath ./zig-out/bin/zls) /usr/local/bin/zls
    cd $cur_dir
end
