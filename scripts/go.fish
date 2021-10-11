function sync_go
    title "sync go"

    set_env_nx GOPATH $HOME/.go
    fish_add_path $GOPATH/bin

    if test $os = archlinux
        paru_install go gopls golangci-lint
    else if test $os = macos
        brew_install go gopls golangci-lint
    end
    get_go_pkg $go_pkgs

    # golangci-lint config
    ln -sf $dots/lsp/golangci.yml ~/.golangci.yml
end

function get_go_pkg
    for pkg in $argv
        echo "  goinstall $pkg"
        if not test (date_cache get goget_$pkg)
            go install $pkg
            date_cache set goget_$pkg
        end
    end
end

set gonvim \
    github.com/davidrjenni/reftools/cmd/fillstruct@master \
    golang.org/x/tools/cmd/goimports@master \
    github.com/fatih/gomodifytags@master \
    github.com/segmentio/golines \
    mvdan.cc/gofumpt/gofumports \
    mvdan.cc/gofumpt
set gotests github.com/cweill/gotests/... 
set wire github.com/google/wire/cmd/wire
set swagger github.com/go-swagger/go-swagger/cmd/swagger
set grpc \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc \
    github.com/golang/protobuf/{proto,protoc-gen-go}
set lint_lsp github.com/nametake/golangci-lint-langserver

set go_pkgs $gonvim $gotests $wire $swagger $grpc $lint_lsp
