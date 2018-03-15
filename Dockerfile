From archlinux/base:latest

WORKDIR /root

COPY docker/mirrorlist /etc/pacman.d/mirrorlist
RUN cat /etc/pacman.d/mirrorlist
RUN pacman -Sy && \
    pacman -S --noconfirm git zsh tree tmux python python-pip go rust nodejs-lts-carbon npm vim clang ripgrep make cmake

RUN git clone https://github.com/CrowsT/CrowsEnv.git
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN echo "source ~/CrowsEnv/zsh/.crows-docker-zsh" >> .zshrc
COPY tmux/.tmux.conf /root/.tmux.conf
COPY vim/.vimrc /root/.vimrc
COPY vim/.vim /root/.vim
COPY tern/.tern-config.js /root/.tern-configs.js

SHELL ["/bin/zsh", "-c"]
RUN source /root/.zshrc
RUN pip install flake8 ipython
VOLUME ["/root/Projects", "/root/go"]

RUN mkdir ~/.vim/plugins
WORKDIR /root/.vim/plugins
RUN vim +PlugInstall +qall
WORKDIR /root/.vim/plugins/YouCompleteMe
RUN git submodule update --init --recursive
RUN python3 install.py --clang-completer --go-completer --js-completer --rust-completer --system-libclang
WORKDIR /root/.vim/plugins/tern_for_vim
RUN npm install
WORKDIR /root/Projects
