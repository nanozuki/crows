function sync_git
    title "sync git"

    mkdir -p $config/git
    ln -sf $dots/git/config $config/git/config
    if test -f $config/git/config_local
        touch $config/git/config_local
    end
end
