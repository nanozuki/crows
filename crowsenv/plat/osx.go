package plat

import (
	"os/exec"

	"github.com/nanozuki/CrowsEnv/crowsenv/task"
)

type OSX struct{}

func (o *OSX) Name() string {
	return "osx"
}

func (o *OSX) Prepare() error {
	if _, err := exec.LookPath("brew"); err == nil {
		return nil
	}
	// install homebrew
	return doMultiCommands([]string{
		"xcode-select --install",
		`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`,
		"brew install git",
	})

}

var osxPackages = map[string]task.PkgConfig{
	"rust": task.PkgConfig{
		ExecName: "rustup",
		Commands: func() error {
			return doCommand(`bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"`)
		},
	},
	"gnupg": task.PkgConfig{
		ExecName: "gpg",
		Commands: func() error {
			return doMultiCommands([]string{"brew install gnupg", "brew install pinentry-mac"})
		},
	},
	"ripgrep": task.PkgConfig{ExecName: "rg"},
	"rime": task.PkgConfig{
		Commands: func() error {
			return doCommand("brew cask install squirrel")
		},
	},
}

func (o *OSX) PkgConfigs() map[string]task.PkgConfig {
	return osxPackages
}

func (o *OSX) AddPkg(pkg string) error {
	return doCommandf("brew install %s", pkg)
}

func (o *OSX) AddExtPkg(pkg string) error {
	return doCommandf("brew cask install %s", pkg)
}
