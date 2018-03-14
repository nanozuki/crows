From archlinux/base:latest

WORKDIR /root
RUN echo "Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.xjtu.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
RUN cat /etc/pacman.d/mirrorlist
RUN pacman -Sy && pacman -S --noconfirm git zsh tree tmux python go rust nodejs-lts-carbon npm vim clang ripgrep make cmake
RUN git clone https://github.com/CrowsT/CrowsEnv.git
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN echo "source ~/CrowsEnv/zsh/.crows-docker-zsh" >> .zshrc
RUN ln -s /root/CrowsEnv/tmux/.tmux.conf /root/.tmux.conf && \
    ln -s /root/CrowsEnv/vim/.vimrc /root/.vimrc && \
    ln -s /root/CrowsEnv/vim/.vim /root/.vim && \
    ln -s /root/CrowsEnv/tern/.tern-config.js /root/.tern-configs.js
SHELL ["/bin/zsh", "-c"]
RUN source /root/.zshrc
RUN pip install flake8 ipython
RUN go get 'github.com/klauspost/asmfmt/cmd/asmfmt' 'github.com/derekparker/delve/cmd/dlv'\
    'github.com/kisielk/errcheck' 'github.com/davidrjenni/reftools/cmd/fillstruct' 'github.com/nsf/gocode'\
    'github.com/rogpeppe/godef' 'github.com/zmb3/gogetdoc' 'golang.org/x/tools/cmd/goimports'\
    'github.com/golang/lint/golint' 'github.com/alecthomas/gometalinter' 'github.com/fatih/gomodifytags'\
    'golang.org/x/tools/cmd/gorename' 'github.com/jstemmer/gotags' 'golang.org/x/tools/cmd/guru'\
    'github.com/josharian/impl' 'github.com/dominikh/go-tools/cmd/keyify' 'github.com/fatih/motion'
RUN mkdir ~/.vim/plugins
WORKDIR /root/.vim/plugins
RUN git clone https://github.com/vim-airline/vim-airline && \
    git clone https://github.com/vim-airline/vim-airline-themes && \
    git clone https://github.com/edkolev/tmuxline.vim && \
    git clone https://github.com/nathanaelkane/vim-indent-guides && \
    git clone https://github.com/w0rp/ale && \
    git clone https://github.com/kshenoy/vim-signature && \
    git clone https://github.com/scrooloose/nerdcommenter && \
    git clone https://github.com/easymotion/vim-easymotion && \
    git clone https://github.com/tpope/vim-fugitive && \
    git clone https://github.com/terryma/vim-multiple-cursors && \
    git clone https://github.com/scrooloose/nerdtree && \
    git clone https://github.com/dyng/ctrlsf.vim && \
    git clone https://github.com/kien/ctrlp.vim && \
    git clone https://github.com/BurntSushi/ripgrep && \
    git clone https://github.com/Valloric/YouCompleteMe && \
    git clone https://github.com/SirVer/ultisnips && \
    git clone https://github.com/CrowsT/vim-snippets && \
    git clone https://github.com/nvie/vim-flake8 && \
    git clone https://github.com/pangloss/vim-javascript && \
    git clone https://github.com/ternjs/tern_for_vim && \
    git clone https://github.com/mattn/emmet-vim && \
    git clone https://github.com/mxw/vim-jsx && \
    git clone https://github.com/fatih/vim-go
WORKDIR /root/.vim/plugins/YouCompleteMe
RUN git submodule update --init --recursive
RUN python3 install.py --clang-completer --go-completer --js-completer --rust-completer --system-clang
WORKDIR /root/.vim/plugins/tern_for_vim
RUN npm install
RUN pacman -Rns
