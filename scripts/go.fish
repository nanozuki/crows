function sync_go
    title "sync go"

    set_env_nx GOPATH $HOME/.go
    fish_add_path $GOPATH/bin

    if test $os = archlinux
        pacman_install go gopls
        yay_install golangci-lint go-swagger
    else if test $os = macos
        brew_install go gopls golangci-lint go-swagger
    end
    get_go_pkg $go_pkgs
end

function get_go_pkg
    for pkg in $argv
        echo "  goget $pkg"
        if not test (date_cache get goget_$pkg)
            go get -u $pkg
            date_cache set goget_$pkg
        end
    end
end

set vim_go \
    github.com/klauspost/asmfmt/cmd/asmfmt@master \
    github.com/go-delve/delve/cmd/dlv@master \
    github.com/kisielk/errcheck@master \
    github.com/davidrjenni/reftools/cmd/fillstruct@master \
    github.com/rogpeppe/godef@master \
    golang.org/x/tools/cmd/goimports@master \
    golang.org/x/lint/golint@master \
    honnef.co/go/tools/cmd/staticcheck@latest \
    github.com/fatih/gomodifytags@master \
    golang.org/x/tools/cmd/gorename@master \
    github.com/jstemmer/gotags@master \
    golang.org/x/tools/cmd/guru@master \
    github.com/josharian/impl@master \
    honnef.co/go/tools/cmd/keyify@master \
    github.com/fatih/motion@master \
    github.com/koron/iferr@master

set gotests github.com/cweill/gotests/... 
set wire github.com/google/wire/cmd/wire
set grpc \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc \
    github.com/golang/protobuf/{proto,protoc-gen-go}

set lint_lsp github.com/nametake/golangci-lint-langserver

set go_pkgs $vim_go $gotests $wire $grpc $lint_lsp
