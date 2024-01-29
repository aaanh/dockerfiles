# Dockerfiles

Dockerfiles to build container images of development environments.

Currently only support `amd64` architecture.

## Quickstart

```sh
docker pull ghcr.io/aaanh/dockerfiles/ubuntu.base:main
docker run -it ghcr.io/aaanh/dockerfiles/ubuntu.base:main
```

## Installed Languages/Runtimes

- Golang (latest)
- Rust (latest)
- Java (v17)
- Node (via `nvm`)
- Python (latest stable)

## Tools

- `zsh` + `oh-my-zsh`
- `git`
- `build-essential`:
  - `dpkg-dev`
  - `g++`
  - `gcc`
  - `libc6-dev`
  - `make`
- `code` (Visual Studio Code CLI)
  - Create a MSFT tunneled instance with
  ```sh
  code tunnel --no-sandbox --user-data-dir=/home
  ```
- `gh` (Github CLI)
- `nvim` + `lvim` (NeoVim + LunarVim)

# Manifest

- Ubuntu base tags:
  - [main](https://ghcr.io/aaanh/dockerfiles/ubuntu.base)
