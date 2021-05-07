function install_rime
    if test $os = archlinux
        echo "Install rime..."
        pacman_install fcitx-rime
        mkdir -p $config/fcitx/rime
        ln -sf $dots/rime/default.custom.yaml $config/fcitx/rime/default.custom.yaml
    end
end

function update_rime
end
