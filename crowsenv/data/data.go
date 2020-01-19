package data

import (
	"log"
	"os"
	"os/exec"

	"github.com/pkg/errors"
)

func EnsureDataProject(repo, path string) error {
	_, err := os.Stat(path)
	if err == nil {
		return nil
	}
	log.Print("download data project")
	_, err = exec.Command("git", "clone", repo, path).Output()
	return errors.Wrap(err, "download data project")
}
