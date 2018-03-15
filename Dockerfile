From archlinux/base:latest

WORKDIR /root
RUN echo "Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.xjtu.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist && \
    echo "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
RUN cat /etc/pacman.d/mirrorlist
RUN pacman -Sy && pacman -S --noconfirm git zsh tree tmux python python-pip go rust nodejs-lts-carbon npm vim clang ripgrep make cmake
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
VOLUME ["/root/Projects", "/root/go"]

RUN mkdir ~/.vim/plugins
WORKDIR /root/.vim/plugins
RUN vim +PlugInstall +qall
WORKDIR /root/.vim/plugins/YouCompleteMe
RUN git submodule update --init --recursive
RUN python3 install.py --clang-completer --go-completer --js-completer --rust-completer --system-libclang
WORKDIR /root/.vim/plugins/tern_for_vim
RUN npm install
