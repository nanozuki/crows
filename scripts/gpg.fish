function sync_gpg
    title "sync gpg"

    set_env_nx GNUPGHOME $XDG_DATA_HOME/gnupg
    mkdir -p $GNUPGHOME

    if test $os = archlinux
        paru_install gnupg pinentry
    else if test $os = macos
        brew_install gnupg pinentry-mac
    end

    if test $os = archlinux
        ln -sf $dots/gnupg/gpg-agent_arch.conf $GNUPGHOME/gpg-agent.conf
    else if test $os = macos
        ln -sf $dots/gnupg/gpg-agent_osx.conf $GNUPGHOME/gpg-agent.conf
    end

    # gpg keys
    echo "Import gpg public keys..."
    for file in (ls $project/secret/gpgkeys/*pub.gpg)
        gpg --import $file
    end
    echo "Import secret keys..."
    for file in (ls $project/secret/gpgkeys/*sec.gpg)
        gpg --allow-secret-key-import --import $file
    end
end
