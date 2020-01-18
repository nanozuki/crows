package cmd

import (
	"fmt"
	"log"

	"github.com/nanozuki/CrowsEnv/crowsenv/plat"
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
	plat, err := plat.GetPlatform()
	fmt.Println("platform: " + plat.Name())
	if err != nil {
		return err
	}
	if err := plat.Prepare(); err != nil {
		return err
	}
	//if err := task.AddPkgs(plat, cfg.Packages...); err != nil {
	//	return err
	//}
	return nil
}
