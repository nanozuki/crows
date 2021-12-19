function setUx
    set -Ux $argv
    or return 0
end

function add_path
    fish_add_path $argv
    or return 0
end

function brew_install
    brew install $argv
    or return 0
end

function paru_install
    paru -S --needed --noconfirm $argv
end

function find_git_repo_path
    set repo (string trim -rc '.git' $argv[1])
    set words (string match -r "(git@|https?://)(.*)/(.*)" $repo)
    if test (count $words) -lt 4
        echo "invalid repository path"
        return 1
    end
    set ppath "$HOME/Projects/$words[3]"
    if test $words[2] = "git@"
        set ppath (string replace : / $ppath)
    end
    set path "$ppath/$words[4]"
    echo $path
end

function git_latest
    set repo_path (find_git_repo_path $argv[1])
    if test -e $repo_path
        set cur_dir (pwd)
        cd $repo_path
        set output (git pull); or cd $cur_dir && return 1
        cd $cur_dir
        if test (echo $output | grep 'Already up to date')
            return 1
        end
    else
        git clone $argv[1] $repo_path
        or return 0
    end
    echo $repo_path
end

function macos_sync_lua_lsp
    brew_install ninja
    set repo https://github.com/sumneko/lua-language-server.git
    set repo_path (git_latest $repo); or return 0
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

function macos_sync_zls
    set repo https://github.com/zigtools/zls.git
    set repo_path (git_latest $repo); or return 0
    if test -z $repo_path
        return 0
    end

    set cur_dir (pwd)
    cd $repo_path
    git submodule update --init --recursive
    zig build -Drelease-safe
    ln -sf (realpath ./zig-out/bin/zls) /usr/local/bin/zls
    cd $cur_dir
end

function sync_rime_schema
    bash $XDG_DATA_HOME/plum/rime-install :preset
    bash $XDG_DATA_HOME/plum/rime-install prelude
    bash $XDG_DATA_HOME/plum/rime-install essay
    bash $XDG_DATA_HOME/plum/rime-install luna-pinyin
    bash $XDG_DATA_HOME/plum/rime-install double-pinyin
    bash $XDG_DATA_HOME/plum/rime-install emoji
end
