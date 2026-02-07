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

USER ${USER_NAME}

ENV CI=1 \
  CHEZMOI_MANAGE_PACKAGES=1 \
  PAGER= \
  MISE_HTTP_RETRIES=5

# Install paru early (cached layer - bind mount only needed files)
RUN \
  --mount=type=bind,source=.chezmoi.toml.tmpl,target=/tmp/src/.chezmoi.toml.tmpl \
  --mount=type=bind,source=dot_config/zsh/dot_zshenv,target=/tmp/src/dot_config/zsh/dot_zshenv \
  --mount=type=bind,source=.chezmoiscripts/run_onchange_before_05-archlinux-install-paru.sh.tmpl,target=/tmp/src/.chezmoiscripts/run_onchange_before_05-archlinux-install-paru.sh.tmpl \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/home/${USER_NAME}/.cache,uid=${USER_UID},gid=${USER_GID} \
  --mount=type=cache,target=/home/${USER_NAME}/.local/share/cargo,uid=${USER_UID},gid=${USER_GID} \
  BASH_ENV=/tmp/src/dot_config/zsh/dot_zshenv \
  chezmoi execute-template --source /tmp/src \
  < /tmp/src/.chezmoiscripts/run_onchange_before_05-archlinux-install-paru.sh.tmpl \
  | bash

# Copy full source and apply all dotfiles
COPY --chown=${USER_UID}:${USER_GID} . /home/${USER_NAME}/.local/share/chezmoi

ENV BASH_ENV=/home/${USER_NAME}/.local/share/chezmoi/dot_config/zsh/dot_zshenv

RUN chezmoi init && mkdir -p ~/.local/share/mise ~/.cache ~/.npm
RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=cache,target=/var/cache/dnf \
  --mount=type=cache,target=/home/${USER_NAME}/.cache,uid=${USER_UID},gid=${USER_GID} \
  --mount=type=cache,target=/home/${USER_NAME}/.npm,uid=${USER_UID},gid=${USER_GID} \
  --mount=type=cache,target=/home/${USER_NAME}/.local/share/mise/downloads,uid=${USER_UID},gid=${USER_GID} \
  --mount=type=cache,target=/home/${USER_NAME}/.local/share/mise/http-tarballs,uid=${USER_UID},gid=${USER_GID} \
  chezmoi apply --force

CMD ["zsh"]
