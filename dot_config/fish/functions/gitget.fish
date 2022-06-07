function gitget
    if test (count $argv) -lt 1
        echo "[usage: gitget <repository>]"
    end
    set path (find_git_repo_path $argv[1])
    or echo "Invalid repository: $argv[1]" && return 1
    if not test -e $path
        git clone $argv[1] $path
    end
    cd $path
end
