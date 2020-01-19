package plat

import (
	"os/exec"

	"github.com/nanozuki/CrowsEnv/crowsenv/task"
)

type Arch struct{}

func (a *Arch) Name() string {
	return "arch"
}

func (a *Arch) Prepare() error {
	if _, err := exec.LookPath("yay"); err == nil {
		return nil
	}
	return doMultiCommands([]string{
		"sudo pacman -S --noconfirm base-devel",
		"mkdir -p ~/Projects/aur.archlinux.org/yay",
		"cd ~/Projects/aur.archlinux.org/yay",
		"git clone https://aur.archlinux.org/yay.git .",
		"cd yay",
		"makepkg -si --noconfirm ",
		"cd -",
	})
}

var archPackages = map[string]task.PkgConfig{
	"node": task.PkgConfig{
		OsName: "nodejs",
	},
	"rust": task.PkgConfig{
		ExecName: "rustup",
		Commands: func() error {
			return doCommand(`bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"`)
		},
	},
	"gnupg": task.PkgConfig{
		ExecName: "gpg",
	},
	"ripgrep": task.PkgConfig{ExecName: "rg"},
	"rime": task.PkgConfig{
		ExecName: "rime_deployer",
		Commands: func() error {
			return doCommand("pacman -S --noconfirm fcitx-rime")
		},
	},
}

func (a *Arch) PkgConfigs() map[string]task.PkgConfig {
	return archPackages
}

func (a *Arch) AddPkg(pkg string) error {
	return doCommandf("pacman -S --noconfirm %s", pkg)
}

func (a *Arch) AddExtPkg(pkg string) error {
	return doCommandf("yay -S --noconfirm --answerdiff=None %s", pkg)
}
