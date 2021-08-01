function sync_system
    title "sync system"
    if test $os = archlinux
        sync_archlinux
    else if test $os = macos
        sync_macos
    end
end

function sync_archlinux
    pacman_install go tree
    if not type -q yay
        gitget "~/Projects/aur.archlinux.org/yay"
        makepkg -si --noconfirm
        cd -
    end
    yay_install direnv
    yay -Syu
    set PATH ~/.local/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
end

function sync_macos
    brew_install make go tree direnv gnu-sed
    brew update && brew upgrade && brew cleanup
    brew upgrade --cask
    set PATH ~/.local/bin /opt/homebrew/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /Library/Apple/usr/bin
end
