# CrowsEnv

Develop Enviroment of Nanozuki Crows

## Usage

```bash
$ crows-env upgrade
$ crows-env sync [subjects]
```

Subjects are: system fish git ssh gpg tmux nvim go rust zig

## Installing

### Arch Linux

```bash
pacman -S git fish
git clone git@github.com:nanozuki/CrowsEnv.git ~/.local/share/CrowsEnv
sudo ln -s ~/.local/share/CrowsEnv/crows-env.fish /usr/local/bin/crows-env
chsh -s /bin/fish
```

### macOS

Make sure xcode command line tools is installed. If not:

```bash
xcode-select --install
```

Install homebrew: https://brew.sh/. And:

```bash
brew install git fish
git clone git@github.com:nanozuki/CrowsEnv.git ~/.local/share/CrowsEnv
ln -s ~/.local/share/CrowsEnv/crows-env.fish /usr/local/bin/crows-env
chsh -s /usr/local/bin/fish
```
