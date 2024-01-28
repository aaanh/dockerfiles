FROM ubuntu:latest

WORKDIR /

# The basic housekeeping

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y
RUN apt install -y --no-install-recommends curl wget git build-essential jq ca-certificates zsh gpg apt-transport-https
RUN chsh -s /usr/bin/zsh
RUN exec zsh

SHELL ["/usr/bin/zsh", "-ec"]

WORKDIR /home

# Install tools

## Github CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install -y gh

## Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
RUN install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
RUN rm -f packages.microsoft.gpg
RUN apt update && apt install -y code

## Oh my zsh + Syntax highlighting
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git && bash -c echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# ----------

# Install programming languages (compilers and whatnots)

## Golang
RUN GO_VERSION=$(curl -s https://go.dev/dl/\?mode\=json | jq -r '.[0].version') && curl -LO "https://go.dev/dl/$GO_VERSION.linux-amd64.tar.gz" && tar -C /usr/local -xzf "$GO_VERSION.linux-amd64.tar.gz"
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc
RUN rm -rf *.gz

## Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN echo "source $RUSTUP_HOME/env" >> /etc/profile.d/rust.sh

## Node Version Manager
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN echo `export NVM_DIR="$HOME/.nvm"` >> ~/.zshrc
RUN echo `[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm` >> ~/.zshrc
RUN echo `[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion` >> ~/.zshrc

SHELL [ "/bin/sh", "-ec" ]

## Java Development Kit (JDK)
RUN apt install -y --no-install-recommends default-jdk
RUN mkdir /home/.java
ENV JAVA_HOME=/home/.java

# -----------

# More tools

## Neovim
RUN curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep "browser_download_url.*nvim.appimage" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
RUN mv nvim.appimage /usr/bin

## LunarVim
RUN bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

# -----------

ENV DONT_PROMPT_WSL_INSTALL=true

# CONTAINER START
ENTRYPOINT [ "/usr/bin/zsh" ]
