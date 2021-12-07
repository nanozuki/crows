#!/usr/bin/env fish
if not test -f $XDG_CONFIG_HOME/git/config_local
    touch $XDG_CONFIG_HOME/git/config_local
end
