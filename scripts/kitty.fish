function sync_kitty
    title "sync kitty"
    if test $os = archlinux
        paru_install kitty
    else if test $os = macos
        brew_install kitty
    end

    link_dir $dots/kitty $config/kitty
    if not test -f $config/kitty/local.conf
        touch $config/kitty/local.conf
    end
end
