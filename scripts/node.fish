function sync_node
    title "sync node"

    if test $os = archlinux
        paru_install nodejs-lts-gallium npm
    else if test $os = macos
        brew_install node@16
        brew link --overwrite --force node@16
    end
    set_env NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
    npm config set prefix      $XDG_DATA_HOME/npm
    npm config set cache       $XDG_CACHE_HOME/npm
    npm config set tmp         $XDG_RUNTIME_DIR/npm
    npm config set init-module $XDG_CONFIG_HOME/npm/config/npm-init.js
end
