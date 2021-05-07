#!/usr/bin/env fish

## -- load project --

set project (dirname (realpath (status filename)))
set dots $project/dots
set scripts $project/scripts
set config $XDG_CONFIG_HOME
set data $XDG_DATA_HOME

for func in (ls $dots/fish/functions/*.fish)
    source $func
end
for file in (ls $scripts/*.fish)
    source $file
end

## -- init ---

set_env_nx XDG_CONFIG_HOME $HOME/.config
set_env_nx XDG_CACHE_HOME $HOME/.cache
set_env_nx XDG_DATA_HOME $HOME/.local/share
set_env_nx LC_ALL en_US.UTF-8
set_env_nx LANG en_US.UTF-8

detect_os

## -- works --

set subcmd install update upgrade
set subjects system fish git ssh gpg rime tmux nvim go rust

function install
    if test -n $argv[1]
        set subs $argv
    else
        set subs $subjects
    end
    for subject in $subs
        install_$subject; or exit 1
    end
    exit 0
end

function update
    if test -n $argv[1]
        set subs $argv
    else
        set subs $subjects
    end
    for subject in $subs
        update_$subject; or exit 1
    end
    exit 0
end

function upgrade
    cd $project
    git pull
    set code $status
    cd -
    exit code
end

## -- opts --

switch $argv[1]
    case install
        install $argv[2..]
        exit $status
    case update
        update $argv[2..]
        exit $status
    case '*'
        echo "Usage:"
        echo ""
        echo \t"crows-env.sh <subcmd> [<subjects>]"
        echo ""
        echo "Subcmds are: $subcmd"
        echo ""
        echo "Subjects are: $subjects"
        echo "subcmd 'install', 'update' support subjects"
        echo ""
end
