if test (count $argv) -lt 1
    echo "[usage: gitget <repository>]"
end

# calculate the path of the repository
set trim_dot_git (string match -r '^(.*?)(\.git)?$' $argv[1])
set words (string match -r "(git@|https?://)(.*)/(.*)" $trim_dot_git[2])
if test (count $words) -lt 4
    echo "invalid repository path: $argv[1]"
    return 1
end
set dirpath (string replace -ar '~' '_' $words[3])
set ppath "$HOME/Projects/$dirpath"
if test $words[2] = "git@"
    set ppath (string replace : / $ppath)
end
set path "$ppath/$words[4]"

if not test -e $path
    git clone $argv[1] $path
end
cd $path
