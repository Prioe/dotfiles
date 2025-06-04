FROM archlinux:base-devel

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  pacman -Sy --needed --noconfirm chezmoi git

RUN \
  useradd -m -G wheel eve; \
  echo "eve ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/eve

COPY --chown=eve:eve . /home/eve/.local/share/chezmoi
USER eve

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/home/eve/.cache \
  <<EOF
# Apply chezmoi!

# Docker bind-mounts are always owned by root, so we need to fix the ownership
sudo chown eve:eve /home/eve/.cache

# Apply our fixed zshenv so everything is set up correctly
. /home/eve/.local/share/chezmoi/dot_config/zsh/dot_zshenv
unset PAGER

# Our chezmoi config knows about the CI environment and will not prompt
export CI=1

chezmoi apply --force --verbose
EOF
