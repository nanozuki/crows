function gitget
    if test (count $argv) -lt 1
        echo "[usage: gitget <repository>]"
    end
    set repo $argv[1]
    set words (string match -r "(git@|https?://)(.*)/(.*)(.git)+?" $repo)
    echo "words: $words"
    if test (count $words) -lt 4
        echo "invalid repository path"
        return 1
    end
    set ppath "$HOME/Projects/$words[3]"
    if test $words[2] = "git@"
        set ppath (string replace : / $ppath)
    end
    set path "$ppath/$words[4]"
    if test -e $path
        echo "repository is already exist"
        return 0
    end
    mkdir -p $ppath
    git clone $repo $path
    cd $path
end
