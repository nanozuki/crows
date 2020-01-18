package plat

import (
	"fmt"
	"os/exec"
	"strings"

	"github.com/pkg/errors"
)

// doCommand dont care result
func doCommand(command string) error {
	words := strings.SplitN(command, "bash -c", 2)
	if len(words) == 2 {
		_, err := exec.Command("bash", "-c", words[1]).Output()
		return errors.Wrapf(err, "exec '%s'", command)
	}
	words = strings.Split(command, " ")
	_, err := exec.Command(words[0], words[1:]...).Output()
	return errors.Wrapf(err, "exec '%s'", command)
}

func doCommandf(format string, args ...interface{}) error {
	command := fmt.Sprintf(format, args...)
	return doCommand(command)
}

func doMultiCommands(commands []string) error {
	for _, command := range commands {
		if err := doCommand(command); err != nil {
			return err
		}
	}
	return nil
}

type pkgConfig struct {
	OsName   string
	ExecName string
	IsExt    bool
	Commands []string
}
