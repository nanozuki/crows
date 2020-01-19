package data

import (
	"github.com/BurntSushi/toml"
	"github.com/nanozuki/CrowsEnv/crowsenv/task"
	"github.com/pkg/errors"
)

func LoadConfigFile(path string) (*task.Config, error) {
	var config task.Config
	if _, err := toml.DecodeFile(path, &config); err != nil {
		return nil, errors.Wrap(err, "load config file")
	}
	return &config, nil
}
