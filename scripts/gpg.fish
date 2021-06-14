function sync_gpg
    title "sync gpg"

    if test $os = archlinux
        pacman_install gnupg pinentry
    else if test $os = macos
        brew_install gnupg pinentry-mac
    end

    mkdir -p $HOME/.gnupg
    if test $os = archlinux
        ln -sf $dots/gnupg/gpg-agent_arch.conf $HOME/.gnupg/gpg-agent.conf
    else if test $os = macos
        ln -sf $dots/gnupg/gpg-agent_osx.conf $HOME/.gnupg/gpg-agent.conf
    end

    # TODO: import gpg keys
    # gpg keys
    # echo "Import gpg public keys..."
    # for file in `ls $config_path/gpgkeys/*_pb.gpg`; do
    #     gpg --import $file
    # done
    # echo "Import secret keys..."
    # for file in `ls $config_path/gpgkeys/*_sec.gpg`; do
    #     gpg --allow-secret-key-import --import $file
    # done
end
