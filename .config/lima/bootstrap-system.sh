#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
  zsh git curl ca-certificates unzip xz-utils stow \
  build-essential pkg-config jq \
  zsh-syntax-highlighting zsh-autosuggestions \
  bat fd-find fzf

ln -sf /usr/bin/fdfind /usr/local/bin/fd || true
ln -sf /usr/bin/batcat /usr/local/bin/bat || true

if ! grep -q '^/usr/bin/zsh$' /etc/shells; then
  echo /usr/bin/zsh >> /etc/shells
fi

if [ ! -d /usr/local/share/powerlevel10k ]; then
  git clone --depth=1 \
    https://github.com/romkatv/powerlevel10k.git \
    /usr/local/share/powerlevel10k
fi

if [ ! -d /usr/share/zsh/plugins/zsh-vi-mode ]; then
  mkdir -p /usr/share/zsh/plugins
  git clone \
    https://github.com/jeffreytse/zsh-vi-mode \
    /usr/share/zsh/plugins/zsh-vi-mode
fi
