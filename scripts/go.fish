function sync_go
    title "sync go"

    set_env GOPATH $XDG_DATA_HOME/go
    add_path $GOPATH/bin

    if test $os = archlinux
        paru_install go gopls golangci-lint
    else if test $os = macos
        brew_install go gopls golangci-lint
    end
    get_go_pkg $go_pkgs

    # golangci-lint config
    ln -sf $dots/lsp/golangci.yml ~/Projects/.golangci.yml
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
    github.com/davidrjenni/reftools/cmd/fillstruct@latest \
    golang.org/x/tools/cmd/goimports@latest \
    github.com/fatih/gomodifytags@latest \
    github.com/segmentio/golines@latest
set gotests github.com/cweill/gotests/...@latest
set wire github.com/google/wire/cmd/wire@latest
set swagger github.com/go-swagger/go-swagger/cmd/swagger@latest
set grpc \
    google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
    github.com/golang/protobuf/{proto,protoc-gen-go}@latest
set lint_lsp github.com/nametake/golangci-lint-langserver@latest

set go_pkgs $gonvim $gotests $wire $swagger $grpc $lint_lsp
