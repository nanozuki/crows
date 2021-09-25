function sync_system
    title "sync system"
    if test $os = archlinux
        sync_archlinux
    else if test $os = macos
        sync_macos
    end
end

function sync_archlinux
    sudo pacman -S --needed --noconfirm base-devel
    if not type -q paru
        gitget "https://aur.archlinux.org/paru.git"
        makepkg -si --noconfirm
        cd -
    end
    paru -Syu
    paru_install go tree direnv
    set PATH ~/.local/bin /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin
end

function sync_macos
    brew_install make go tree direnv gnu-sed
    brew update && brew upgrade && brew cleanup
    brew upgrade --cask
    set PATH ~/.local/bin /opt/homebrew/bin /usr/local/bin /usr/bin /bin /usr/sbin /sbin /Library/Apple/usr/bin
end
