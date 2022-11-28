# vi: ft=fish
function sync-env
    #### System settings
    ####
    setUx XDG_CONFIG_HOME $HOME/.config
    setUx XDG_CACHE_HOME  $HOME/.cache
    setUx XDG_DATA_HOME   $HOME/.local/share
    setUx LC_ALL          en_US.UTF-8
    setUx LANG            en_US.UTF-8
    setUx EDITOR          nvim
    #
    setUx XDG_RUNTIME_DIR $TMPDIR
    setUx fish_user_paths ~/.local/bin /opt/homebrew/bin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin /Library/Apple/usr/bin
    #

    #### Upgrade package managers
    ####
    #
    brew_update
    #
    fisher_update
    npm_update
    cargo_update

    #### Terminal tools
    ####
    #
    brew_install direnv exa bat btop starship tmux ripgrep fzf
    if not brew tap | grep wezterm
        brew tap wez/wezterm
    end
    brew_install --cask wezterm
    #
    fisher_install jethrokuan/z PatrickF1/fzf.fish

    #### GNUPG
    ####
    set -Ux GNUPGHOME $XDG_DATA_HOME/gnupg
    mkdir -p $GNUPGHOME
    #
    brew_install gnupg pinentry-mac
    #

    #### Rime
    #
    brew_install --cask squirrel
    #
    if not test -d $XDG_DATA_HOME/plum
        git clone --depth 1 https://github.com/rime/plum.git $XDG_DATA_HOME/plum
    end
    bash $XDG_DATA_HOME/plum/rime-install :preset
    bash $XDG_DATA_HOME/plum/rime-install prelude
    bash $XDG_DATA_HOME/plum/rime-install essay
    bash $XDG_DATA_HOME/plum/rime-install luna-pinyin
    bash $XDG_DATA_HOME/plum/rime-install double-pinyin
    bash $XDG_DATA_HOME/plum/rime-install emoji
    
    #### Languages developments
    ### golang
    setUx GOPATH $XDG_DATA_HOME/go
    add_path $GOPATH/bin
    #
    brew_install go 
    #
    ## golang code-gen tools
    go install github.com/google/wire/cmd/wire@latest
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest 
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest 

    ### rust
    install_rust

    ### frontend
    install_node_lts
    npm_install typescript

    ### zig
    #
    brew_install zig
    #
    
    ### deno
    #
    brew_install deno
    #

    ### terraform
    #
    brew_install terraform 
    #
    
    ### ocaml
    #
    brew_install opam 
    #
    setUx OPAMROOT $XDG_DATA_HOME/opam
    opam init --disable-shell-hook
    opam update -y && opam upgrade -y
    opam install ocamlformat

    ### others
    cargo_install typos-cli

    #### Neovim
    #
    brew_install neovim python
    pip3 install -U pynvim
    npm_install neovim
    #
    add_path $XDG_DATA_HOME/nvim/mason/bin
    ## update nvim/treesitter/mason packages
    nvim --headless "+Lazy! sync" "+TSUpdateSync" "+MasonToolsUpdate" +qa
end


#### Homebrew

function brew_install
    set params
    set pkgs
    for arg in $argv
        if string match -- '--*' $arg > /dev/null
            set -a params $arg
        else
            set -a pkgs $arg
        end
    end
    for pkg in $pkgs
        if not brew list --version $params $pkg
            brew install $params $pkg
        end
    end
end

function brew_update
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
end

#### Paru

function paru_install
    __ensure_paru
    paru -S --needed --noconfirm $argv
end

function paru_update
    __ensure_paru
    paru -Syu --noconfirm
end

function __ensure_paru
    if not type -q paru
        pacman -S --needed --noconfirm base-devel
        gitget "https://aur.archlinux.org/paru-bin.git"
        makepkg -si --noconfirm
        cd -
    end
end

#### Fisher

function fisher_install
    __ensure_fisher
    for pkg in $argv
        if not contains $pkg (fisher list) then
            fisher install $pkg
        end
    end
end

function fisher_update
    __ensure_fisher
    fisher update
end

function __ensure_fisher
    if not type -q fisher
        echo "install fisher"
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end
end

#### Cargo

function cargo_install
    install_rust
    cargo install $argv
end

function cargo_update
    rustup update
end

function install_rust
    setUx CARGO_HOME $XDG_DATA_HOME/cargo
    setUx RUSTUP_HOME $XDG_DATA_HOME/rustup
    add_path $CARGO_HOME/bin
    if not type -q cargo
        #
        brew install rustup
        rustup-init
        #
    end
end

#### Npm

function npm_install
    install_node_lts
    npm --location=global install $argv
end

function npm_update
    install_node_lts
    npm --location=global upgrade
end

function install_node_lts
    setUx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
    add_path $XDG_DATA_HOME/npm/bin

    set node_index "https://nodejs.org/download/release/index.json"
    #
    brew_install gron
    set ver (curl -s $node_index | grep -v 'lts":false' | sed -n '2p' | gron | grep version | cut -d= -f2 | cut -d v -f2 | cut -d. -f1)
    if not brew list --version "node@$ver"
        brew install "node@$ver"
        brew link --overwrite --force "node@$ver"
    end
    #
    npm config set prefix      $XDG_DATA_HOME/npm
    npm config set cache       $XDG_CACHE_HOME/npm
    npm config set init-module $XDG_CONFIG_HOME/npm/config/npm-init.js
end

#### Utils

function setUx 
    set -Ux $argv;or return 0
end

function add_path
    fish_add_path $argv;or return 0
end
