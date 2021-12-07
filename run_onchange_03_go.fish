#!/usr/bin/env fish

# golang
set -Ux GOPATH $XDG_DATA_HOME/go
fish_add_path $GOPATH/bin; or return 0

#{{if eq .chezmoi.os "darwin" -}}
brew bundle --no-lock --file=- <<EOF
brew "go"
brew "gopls"
brew "golangci-lint"
EOF
#{{end}}
