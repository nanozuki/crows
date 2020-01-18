package plat

import (
	"os/exec"
	"strings"

	"github.com/nanozuki/CrowsEnv/crowsenv/task"
	"github.com/pkg/errors"
)

var plats = map[string]task.Platform{
	"osx":  &OSX{},
	"arch": &Arch{},
}

func GetPlatform() (task.Platform, error) {
	platName, err := checkPlatform()
	if err != nil {
		return nil, err
	}
	plat, ok := plats[platName]
	if !ok {
		return nil, errors.New("unsupport platform")
	}
	return plat, nil
}

func checkPlatform() (string, error) {
	stdout, err := exec.Command("uname").Output()
	if err != nil {
		return "", errors.Wrap(err, "uname")
	}
	switch string(stdout[:5]) {
	case "Darwi":
		return "osx", nil
	case "Linux":
		stdout, err := exec.Command("cat", "/etc/issue").Output()
		if err != nil {
			return "", errors.Wrap(err, "cat /etc/issue")
		}
		if strings.Contains(string(stdout), "Arch Linux") {
			return "arch", nil
		}
	}
	return "", errors.New("unsupport platform")
}
