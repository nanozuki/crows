package task

var Env = struct {
	DataRepo string

	HomePath    string
	ConfigPath  string
	ProjectPath string

	Config   *Config
	Platform Platform
}{
	DataRepo: "https://github.com/nanozuki/CrowsEnv.git",
}

type Platform interface {
	Name() string
	Prepare() error
	PkgManager
}

type Config struct {
	Packages []string          `toml:"packages"`
	Links    map[string]string `toml:"links"`
	LinkDirs map[string]string `toml:"link_dirs"`
}
