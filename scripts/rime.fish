function sync_rime
    title "sync rime"

    if test $os = archlinux
        pacman_install fcitx-rime
        mkdir -p $config/fcitx/rime
        ln -sf $dots/rime/default.custom.yaml $config/fcitx/rime/default.custom.yaml
    end
end
