function install_fish
    echo "Install fish..."
    # link config
    mkdir -p $config/fish/conf.d
    ln -sf $dots/fish/config.fish $config/fish/config.fish
    # link functions
    mkdir -p $config/fish/functions
    for func in (ls $dots/fish/functions/)
        ln -sf $dots/fish/functions/$func $config/fish/functions/$func
    end
    install_fisher
end

function install_fisher
    if not type -q fisher
        echo "install fisher"
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end
    ln -sf $dots/fish/fish_plugins $config/fish/fish_plugins
    fisher update
end

function update_fish
    fisher update
end
