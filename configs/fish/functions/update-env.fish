if type -q home-manager
    echo "----==== Home Manager ====----"
    cd $XDG_CONFIG_HOME/home-manager
    if test -z (git status --porcelain); and test "master" = (git branch --show-current)
        git pull
        home-manager switch --flake .#$HM_CONFIG_NAME
    else
        echo "home-manager is not clean or not in master branch"
        return 1
    end
    cd -
end

if type -q darwin-rebuild
    echo "----==== Nix Darwin ====----"
    cd $XDG_CONFIG_HOME/nix-darwin
    if test -z (git status --porcelain); and test "main" = (git branch --show-current)
        git pull
        sudo rm -rf /etc/bashrc /etc/zshrc /etc/zshenv
        sudo darwin-rebuild switch --flake .#$OS_CONFIG_NAME
    else
        echo "nix-darwin is not clean or not in main branch"
        return 1
    end
    cd -
else if type -q brew
    brew update
    brew upgrade
    brew upgrade --cask
    brew cleanup
end

if type -q nixos-rebuild
    echo "----==== NixOS ====----"
    cd /etc/nixos
    if test -z (git status --porcelain); and test "main" = (git branch --show-current)
        git pull
        sudo nixos-rebuild switch --flake .#$OS_CONFIG_NAME
    else
        echo "/etc/nixos is not clean or not in main branch"
        return 1
    end
    cd -
end

if type -q nix-collect-garbage
    echo "----==== Nix Collect Garbage ====----"
    sudo nix-collect-garbage --delete-older-than 30d
end

if type -q paru
    echo "----==== Paru ====----"
    paru -Syu --noconfirm
else if type -q yay
    echo "----==== Yay ====----"
    yay -Syu --noconfirm
else if type -q pacman
    echo "----==== Pacman ====----"
    sudo pacman -Syu --noconfirm
end

if type -q flatpak
    echo "----==== Flatpak ====----"
    sudo flatpak upgrade -y
end

if test -d $XDG_DATA_HOME/plum
    echo "----==== Rime Plum ====----"
    cd $XDG_DATA_HOME/plum && git pull && cd -
    set -lx rime_frontend fcitx5-rime
    $XDG_DATA_HOME/plum/rime-install luna-pinyin
    $XDG_DATA_HOME/plum/rime-install double-pinyin
    $XDG_DATA_HOME/plum/rime-install emoji
end
