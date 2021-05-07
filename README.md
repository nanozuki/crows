# CrowsEnv

Develop Enviroment of Nanozuki Crows

## Usage

```bash
crows-env <subcmd> [<subjects>]
```

Subcmds are: install update upgrade.

Subjects are: system fish git ssh gpg rime tmux nvim go rust.
Subcmd 'install', 'update' support subjects.

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
