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

function find_git_repo_path
    set trim_dot_git (string match -r '^(.*?)(\.git)?$' $argv[1])
    set words (string match -r "(git@|https?://)(.*)/(.*)" $trim_dot_git[2])
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
