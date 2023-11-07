if type -q home-manager
    cd $XDG_CONFIG_HOME/home-manager
    nix flake update
    home-manager switch
    cd -
end
if type -q brew
    brew update
    brew upgrade
    brew upgrade --cask
    brew cleanup
end
if type -q paru
    paru -Syu --noconfirm
else if type -q yay
    yay -Syu --noconfirm
else if type -q pacman
    sudo pacman -Syu --noconfirm
end
if type -q flatpak
    sudo flatpak upgrade -y
end
if type -q fisher
    fisher update
end
if type -q npm
    if test "null" != (npm -g list --json | jq '.dependencies' | string join0)
        for pkg in (npm -g list --json | jq '.dependencies | keys | join(" ")' | string trim -c '"' | string split ' ')
            npm install -g $pkg
        end
    end
end
if type -q cargo
    for pkg in (cargo install --list)
        set words (string split -n ' ' $pkg)
        if test (count $words) -gt 1
            cargo install $words[1]
        end
    end
end
if test -d $XDG_DATA_HOME/plum
    cd $XDG_DATA_HOME/plum && git pull && cd -
    $XDG_DATA_HOME/plum/rime-install luna-pinyin
    $XDG_DATA_HOME/plum/rime-install double-pinyin
    $XDG_DATA_HOME/plum/rime-install emoji
end
if test -d go-global-update
    go-global-update
end
if test -d opam
    opam update --upgrade -y
end
