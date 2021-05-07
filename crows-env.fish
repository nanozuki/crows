#!/usr/bin/env fish

## -- load project --

set project (dirname (realpath (status filename)))
set dots    $project/dots 
set scripts $project/scripts 
set config  $XDG_CONFIG_HOME
set data    $XDG_DATA_HOME

for func in (ls $dots/fish/functions/*.fish)
    source $func
end
for file in (ls $scripts/*.fish)
    source $file
end

## -- init ---

set_env_nx XDG_CONFIG_HOME  $HOME/.config
set_env_nx XDG_CACHE_HOME   $HOME/.cache
set_env_nx XDG_DATA_HOME    $HOME/.local/share
set_env_nx LC_ALL           en_US.UTF-8
set_env_nx LANG             en_US.UTF-8

detect_os

## -- works --

set subjects system fish git ssh gpg rime tmux nvim go rust

function install
    cd $project
    git pull; or exit 1
    cd -
    for subject in $subjects
        install_$subject; or exit 1
    end
    exit 0
end

function update
    for subject in $subjects
        update_$subject; or exit 1
    end
    exit 0
end

## -- opts --

switch $argv[1]
    case install
        install
        exit $status
    case update
        update
        exit $status
    case '*'
        echo "Invalid Argument"
        echo "crows-env.sh <install|update>"
        exit 1
end
