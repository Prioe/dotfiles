FROM archlinux:base-devel

ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=eve

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  pacman -Sy --needed --noconfirm chezmoi git

RUN \
  groupadd -g ${USER_GID} ${USER_NAME}; \
  useradd -l -m -u ${USER_UID} -g ${USER_GID} -G wheel ${USER_NAME}; \
  echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}

COPY --chown=${USER_UID}:${USER_GID} . /home/${USER_NAME}/.local/share/chezmoi
USER ${USER_NAME}

RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/home/${USER_NAME}/.cache,uid=${USER_UID},gid=${USER_GID} \
  <<EOF /bin/bash -euo pipefail

# Apply our fixed zshenv so everything is set up correctly
. /home/${USER_NAME}/.local/share/chezmoi/dot_config/zsh/dot_zshenv
unset PAGER

# Our chezmoi config knows about the CI environment and will not prompt
export CI=1

chezmoi apply --init --force --verbose
EOF
