# CrowsEnv

Develop Enviroment of Nanozuki Crows

## bootstrap

put configure files to `$HOME/.config/CrowsEnv`, the structure of config like this:

```bash
├── git
│   ├── config_local
│   └── config_work
├── gpgkeys
│   ├── crows_pub.gpg
│   ├── crows_sec.gpg
│   ├── work_pub.gpg
│   └── work_sec.gpg
└── sshkeys
    ├── config
    ├── id_ed25519
    ├── id_ed25519.pub
    ├── id_work
    └── id_work.pub
```

and then:

```bash
curl -L https://raw.githubusercontent.com/nanozuki/CrowsEnv/master/crows-env.sh | bash -s bootstrap
```

## update

modify files or do git operator in $HOME/.data/CrowsEnv, and: 

```bash
crows-env.sh update
```
