function install_system
    if test $os archlinux
        install_archlinux
    else if test $os macos
        install_macos
    end
end

function update_system
    if test $os archlinux
        update_archlinux
    else if test $os macos
        update_macos
    end
end

function install_archlinux
    pacman_install base-devel go rustup tree
    rustup update stable
    if test -q yay
        gitget "~/Projects/aur.archlinux.org/yay"
        makepkg -si --noconfirm
        cd -
    end
    yay_install direnv
end

function install_macos
    brew_install make go rustup-init tree direnv
    rustup-init
end

function update_archlinux
    #TODO: update mirror list
    yay -Syu
    rustup update
end

function update_macos
    brew update && brew upgrade && brew cleanup
    brew upgrade --cask
    rustup update
end
