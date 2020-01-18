package cmd

import (
	"fmt"
	"log"
	"path"

	"github.com/nanozuki/CrowsEnv/crowsenv/data"
	"github.com/nanozuki/CrowsEnv/crowsenv/task"
	"github.com/spf13/cobra"
)

var bootstrapCmd = &cobra.Command{
	Use:   "bootstrap",
	Short: "Install environment in new machine",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("bootstrap!")
		if err := bootstrap(); err != nil {
			log.Fatal(err)
		}
	},
}

func bootstrap() error {
	if err := task.Env.Platform.Prepare(); err != nil {
		return err
	}
	if err := initConfig(); err != nil {
		return err
	}
	if err := initDataRepo(); err != nil {
		return err
	}
	fmt.Printf("env:\n%+v\nconfig:\n%+v\n", task.Env, *task.Env.Config)
	return nil
}

func initConfig() error {
	cfgFile := path.Join(task.Env.RepoPath, fmt.Sprintf("%s.toml", task.Env.Platform.Name()))
	config, err := data.LoadConfigFile(cfgFile)
	if err != nil {
		return err
	}
	task.Env.Config = config
	return nil
}

func initDataRepo() error {
	return data.EnsureDataProject(task.Env.DataRepo, task.Env.RepoPath)
}
