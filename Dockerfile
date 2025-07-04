ARG DISTRO=arch
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=eve

FROM archlinux:base-devel AS arch
ARG USER_UID
ARG USER_GID
ARG USER_NAME

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  pacman -Sy --needed --noconfirm chezmoi git

RUN \
  groupadd -g ${USER_GID} ${USER_NAME}; \
  useradd -l -m -u ${USER_UID} -g ${USER_GID} -G wheel ${USER_NAME}; \
  echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}

FROM fedora:latest AS fedora
ARG USER_UID
ARG USER_GID
ARG USER_NAME

RUN --mount=type=cache,target=/var/cache/dnf dnf install -y coreutils util-linux findutils git

RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

RUN \
  groupadd -g ${USER_GID} ${USER_NAME}; \
  useradd -l -m -u ${USER_UID} -g ${USER_GID} -G wheel ${USER_NAME}; \
  echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}

FROM ${DISTRO} AS final
ARG USER_UID
ARG USER_GID
ARG USER_NAME

COPY --chown=${USER_UID}:${USER_GID} . /home/${USER_NAME}/.local/share/chezmoi
USER ${USER_NAME}

RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/var/cache/dnf \
  --mount=type=cache,target=/home/${USER_NAME}/.cache,uid=${USER_UID},gid=${USER_GID} \
  <<EOF /bin/bash -euo pipefail

# Apply our fixed zshenv so everything is set up correctly
. /home/${USER_NAME}/.local/share/chezmoi/dot_config/zsh/dot_zshenv
unset PAGER

# Our chezmoi config knows about the CI environment and will not prompt
export CI=1

chezmoi init --promptBool managePackages=true
chezmoi apply --force --verbose
EOF
