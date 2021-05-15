# date_cache get <key>
# date_cache set <key>
function date_cache
    if test $argv[1] = "get"
        get_date_cache $argv[2]
    else if test $argv[1] = "set"
        set_date_cache $argv[2]
    end
end

set date_cache_file ~/.cache/CrowsEnv/date_cache

function set_date_cache
    mkdir -p ~/.cache/CrowsEnv
    if not test -f $date_cache_file
        touch $date_cache_file
    end
    set key (string replace -a '/' '\/' $argv[1])
    set now (date -u +"%Y-%m-%d")
    for line in (cat $date_cache_file)
        set words (string split ' ' $line)
        if test $words[2] = $key
            set chstr "s/$words[1]/$now/"
            if test $os = macos
                gsed -i "$chstr" "$date_cache_file"
            else if test $os = archlinux
                sed -i "$chstr" "$date_cache_file"
            end
            return 0
        end
    end
    echo (date -u +"%Y-%m-%d") $key >> $date_cache_file
end

function get_date_cache
    mkdir -p ~/.cache/CrowsEnv
    if not test -f $date_cache_file
        touch $date_cache_file
    end
    set key (string replace -a '/' '\/' $argv[1])
    set now (date -u +"%Y-%m-%d")
    for line in (cat $date_cache_file)
        set words (string split ' ' $line)
        if test $words[2] = $key
            if test $words[1] = $now
                echo $words[2]
            end
            return 0
        end
    end
end
