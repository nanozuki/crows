function set_env_nx
    set -q $argv[1]; or set -Ux $argv
end

# link_dir source target
function link_dir
    if test -L $argv[2]
        rm $argv[2]
    else if test -e $argv[2]
        rm -i $argv[2]
    end
    ln -s $argv[1] $argv[2]
end

function brew_install
    for pkg in $argv
        echo "brew install $pkg"
        brew list | grep $pkg >/dev/null
        or brew install $pkg
    end
end

function brew_head
    for pkg in $argv
        echo "brew install $pkg"
        if not test (date_cache get brew_head_$pkg)
            brew list | grep $pkg >/dev/null
            or brew install --HEAD $pkg
            and brew reinstall $pkg
            date_cache set brew_head_$pkg
        end
    end
end

function paru_install
    for pkg in $argv
        echo "paru install $pkg"
        paru -S --needed --noconfirm $pkg
    end
end

function git_latest
    set repo_path (find_git_repo_path $argv[1])
    if test -e $repo_path
        set cur_dir (pwd)
        cd $repo_path
        set output (git pull); or cd $cur_dir && return 1
        cd $cur_dir
        if test (echo $output | grep 'Already up to date')
            return 0
        end
    else
        git clone $argv[1] $repo_path
        or return 1
    end
    echo $repo_path
end

function title
    echo ""
    echo "------->"
    echo ">>>>>>>>>>>>>>>> $argv[1] <<<<<<<<<<<<<<<<"
    echo "<-------"
    echo ""
end
