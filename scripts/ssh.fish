function install_ssh
    echo "Install ssh..."
    mkdir -p $HOME/.ssh
    # TODO: import ssh keys
    # cp $config_path/sshkeys/* $target_path/.ssh
end

function update_ssh
    echo "Update ssh..."
end
