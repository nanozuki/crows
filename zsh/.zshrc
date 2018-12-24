####################
## CUSTOM SETTING ##
####################
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$GOPATH/bin
### Alias
## Normal
alias zshup="source ~/.zshrc"
alias tree="tree -L 2"
alias reboot="sudo reboot"
alias psg="ps aux | grep"
alias vim="nvim"
## Python
alias vpy="source venv/bin/activate"
alias rpy="deactivate"
alias pipup="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias pipinstall="pip install -r requirements.txt"
alias piprequire="pip freeze --local | grep -v '^\-e' | cut -d = -f 1 > requirements.txt"
source ~/.zsh-local
# GO
export GOPATH=$HOME/.go
# direnv
eval "$(direnv hook zsh)"
# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

#############
## ANTIGEN ##
#############
source /usr/local/share/antigen/antigen.zsh
# Load the oh-my-zsh's library
antigen use oh-my-zsh
# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle brew
antigen bundle docker
antigen bundle git
antigen bundle node
antigen bundle pip
antigen bundle python
antigen bundle tmux
antigen bundle yarn
# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
# Fish-like auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
# Extra zsh completions
antigen bundle zsh-users/zsh-completions
# Load the theme
antigen theme ys
# Tell antigen that you're done
antigen apply
