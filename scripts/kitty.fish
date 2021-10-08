function sync_kitty
    title "sync kitty"
    if test $os = archlinux
        paru_install kitty
    else if test $os = macos
        brew_install kitty
    end

    link_dir $dots/kitty $config/kitty
end
