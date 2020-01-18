package task

import "os/exec"

func AddPkgs(pm PkgManager, pkgs ...string) error {
	for _, pkg := range pkgs {
		if err := addPkg(pm, pkg); err != nil {
			return err
		}
	}
	return nil
}

func addPkg(pm PkgManager, pkg string) error {
	cfg, ok := pm.PkgConfigs()[pkg]
	if !ok {
		cfg = PkgConfig{}
	}
	if cfg.OsName == "" {
		cfg.OsName = pkg
	}
	if cfg.ExecName == "" {
		cfg.ExecName = cfg.OsName
	}
	if _, err := exec.LookPath(cfg.ExecName); err != nil {
		return nil
	}
	if cfg.Commands != nil {
		return cfg.Commands()
	}
	if !cfg.IsExt {
		if err := pm.AddPkg(pkg); err == nil {
			return nil
		}
	}
	return pm.AddExtPkg(pkg)
}

type PkgConfig struct {
	OsName   string
	ExecName string
	IsExt    bool
	Commands func() error
}

type PkgManager interface {
	PkgConfigs() map[string]PkgConfig
	AddPkg(string) error
	AddExtPkg(string) error
}
