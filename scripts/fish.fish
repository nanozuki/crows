function install_fish
    # link config
    mkdir -p $config/fish/conf.d
    ln -sf $dots/fish/config.fish $config/fish/config.fish
    # link functions
    mkdir -p $config/fish/functions
    for func in (ls $dots/fish/functions/)
        ln -sf $dots/fish/functions/func $config/functions/func
    end
    install_omf
end

function install_omf
    ln -sfF $dots/omf $config/omf
    if not test -d $data/omf
        curl -L https://get.oh-my.fish > /tmp/install
        fish /tmp/install --path=$data/omf --config=$config/omf
    end
    omf install
end

function update_fish
    update_omf
end

function update_omf
    omf update
end
