function set_env_nx
    set -q $argv[1]; or set -Ux $argv
end

function brew_install
    for pkg in $argv
        echo "brew install $pkg"
        brew list | grep pkg > /dev/null
        or brew install pkg
    end
end

function pacman_install
    for pkg in $argv
        echo "pacman install $pkg"
        #TODO: check installed
        sudo pacman -S --noconfirm pkg
    end
end

function yay_install
    echo "yay install $pkg"
    for pkg in $argv
        #TODO: check installed
        yay -S --noconfirm direnv
    end
end
