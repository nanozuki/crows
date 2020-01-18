package task

import (
	"os"
	"path"
	"strings"
)

func LinkFlie(src, target string) error {
	if err := os.MkdirAll(path.Dir(target), 0777); err != nil {
		return err
	}
	return os.Symlink(src, target)
}

func noSlashEndDir(dir string) string {
	if strings.HasSuffix(dir, "/") {
		return dir[:(len(dir) - 1)]
	}
	return dir
}

func LinkDir(src, target string) error {
	src = noSlashEndDir(src)
	target = noSlashEndDir(target)
	if err := os.RemoveAll(target); err != nil {
		return err
	}
	if err := os.MkdirAll(path.Dir(target), 0777); err != nil {
		return err
	}
	return os.Symlink(src, target)
}
