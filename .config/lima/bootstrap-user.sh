#!/usr/bin/env bash

set -euxo pipefail

DOTFILES_REPO="https://github.com/tbilou/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"

arch=$(dpkg --print-architecture)
case "$arch" in
  amd64)
    nvim_arch=x86_64
    lazygit_arch=x86_64
    eza_asset_suffix=x86_64-unknown-linux-gnu.tar.gz
    ;;
  arm64)
    nvim_arch=arm64
    lazygit_arch=arm64
    eza_asset_suffix=aarch64-unknown-linux-gnu.tar.gz
    ;;
  *)
    printf 'Unsupported architecture: %s\n' "$arch" >&2
    exit 1
    ;;
esac

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL \
  -o "$tmpdir/nvim.tar.gz" \
  "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz"
rm -rf "$HOME/.local/opt/nvim" "$HOME/.local/opt/nvim-linux-${nvim_arch}"
tar -C "$HOME/.local/opt" -xzf "$tmpdir/nvim.tar.gz"
mv "$HOME/.local/opt/nvim-linux-${nvim_arch}" "$HOME/.local/opt/nvim"
ln -sf "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"

lazygit_version=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name | sub("^v"; "")')
curl -fsSL \
  -o "$tmpdir/lazygit.tar.gz" \
  "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_${lazygit_arch}.tar.gz"
mkdir -p "$tmpdir/lazygit"
tar -C "$tmpdir/lazygit" -xzf "$tmpdir/lazygit.tar.gz"
install "$tmpdir/lazygit/lazygit" "$HOME/.local/bin/lazygit"

eza_url=$(curl -fsSL https://api.github.com/repos/eza-community/eza/releases/latest | jq -r --arg suffix "$eza_asset_suffix" '.assets[] | select(.name | endswith($suffix)) | .browser_download_url' | sed -n '1p')
if [ -z "$eza_url" ]; then
  printf 'Unable to resolve eza asset for %s\n' "$arch" >&2
  exit 1
fi
curl -fsSL -o "$tmpdir/eza.tar.gz" "$eza_url"
mkdir -p "$tmpdir/eza"
tar -C "$tmpdir/eza" -xzf "$tmpdir/eza.tar.gz"
install "$tmpdir/eza/eza" "$HOME/.local/bin/eza"

if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi

if [ ! -x "$HOME/.opencode/bin/opencode" ]; then
  curl -fsSL https://opencode.ai/install | bash
fi

if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

rm -f "$HOME/.zshrc"

cd "$DOTFILES_DIR"
stow .

sudo chsh -s "$(command -v zsh)" "$USER"

"$HOME/.local/bin/mise" use -g node@lts python@latest go@latest
"$HOME/.local/bin/mise" install
