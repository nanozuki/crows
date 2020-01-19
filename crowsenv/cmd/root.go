package cmd

import (
	"fmt"
	"log"
	"os"
	"os/user"
	"path"

	"github.com/nanozuki/CrowsEnv/crowsenv/plat"
	"github.com/nanozuki/CrowsEnv/crowsenv/task"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "crows",
	Short: "crows is a tool for build/update/upgrade my environment",
	Long: `
crows is a tool for build/update/upgrade my environment:

	bootstrap: install environment in new machine
	upgrade:   upgrade environment config
	update:    update environment.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("hello, world")
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initEnv)
	rootCmd.AddCommand(bootstrapCmd)
}

func initEnv() {
	cur, err := user.Current()
	if err != nil {
		log.Fatal(errors.Wrap(err, "get user"))
	}
	task.Env.HomePath = cur.HomeDir
	task.Env.ConfigPath = path.Join(cur.HomeDir, ".config")
	task.Env.RepoPath = path.Join(task.Env.HomePath, ".local/share/CrowsEnv")

	plat, err := plat.GetPlatform()
	if err != nil {
		log.Fatal(errors.Wrap(err, "get platform"))
	}
	task.Env.Platform = plat
}
