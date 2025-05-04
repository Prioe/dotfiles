# FROM archlinux:base-devel-20250427.0.341977
FROM greyltc/archlinux-aur:paru-20250427.0.371

RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/var/lib/pacman \
  # FIXME: --overwrite seems like a workaround needed for caching (?)
  pacman -Sy --needed --noconfirm --overwrite "*" chezmoi git

# TODO: Add a non-root user
# RUN useradd -m -G wheel eve
# COPY --chown=eve:eve . /home/eve/.local/share/chezmoi
# USER eve

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

COPY . /root/.local/share/chezmoi
RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/var/lib/pacman \
  <<EOF
yes | chezmoi apply --verbose --force
EOF
