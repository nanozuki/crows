function sync_tmux
    title "sync tmux"
    # install tmux
    if test $os = archlinux
        paru_install tmux
    else if test $os = macos
        brew_install tmux
    end

    # link configs
    mkdir -p $config/tmux
    for file in (ls $dots/tmux/)
        ln -sf $dots/tmux/$file $config/tmux/$file
    end
end
