# `local` uses the local repo
# `remote` clones the remote repo, this also accepts ssh_keys to authorize the clone
ARG build_mode=local


FROM ubuntu:22.04 AS base

# hadolint ignore=DL3008
RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  sudo \
  build-essential \
  procps \
  file \
  vim \
  git \
  openssh-client \
  curl \
  ca-certificates \
  zsh \
  locales \
  # pyenv dependencies for asdf (https://github.com/pyenv/pyenv/wiki#suggested-build-environment)
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  && rm -rf /var/lib/apt/lists/*

# Allow user to run sudo without password
# You should not allow this on an actual machine
RUN adduser --disabled-password --gecos '' user \
  && adduser user sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 


##
## Local build
##
FROM base AS local

COPY . /home/user/.dotfiles
RUN chown -R user:user /home/user/.dotfiles

USER user
RUN \
  --mount=type=cache,target=/home/user/.asdf/downloads \
  --mount=type=cache,target=/home/user/.config/cache/Homebrew \
  sudo chown -R user:user /home/user/.asdf /home/user/.config  \
  && /home/user/.dotfiles/bootstrap

##
## Remote build
##
FROM base AS remote
SHELL ["/bin/bash", "-c"]

ARG ssh_private_key
ARG ssh_public_key

RUN mkdir -p /home/user/.ssh \
  && echo "$ssh_private_key" > /home/user/.ssh/id_rsa \
  && echo "$ssh_public_key" > /home/user/.ssh/id_rsa.pub \
  && chmod 600 /home/user/.ssh/id_rsa \
  && chmod 644 /home/user/.ssh/id_rsa.pub \
  && chown -R user:user /home/user/.ssh \
  && printf "Host github.com\n\tStrictHostKeyChecking no\n" > /home/user/.ssh/config

USER user

COPY ./bootstrap /tmp/bootstrap

RUN bash <(/tmp/bootstrap) \
  && rm -rf /tmp/bootstrap


##
## Final build
##
# hadolint ignore=DL3006
FROM ${build_mode} AS final

# cleanup homebrew
RUN /home/linuxbrew/.linuxbrew/bin/brew cleanup --prune=all -s \
  && rm -rf "$(/home/linuxbrew/.linuxbrew/bin/brew --cache)"

USER user
WORKDIR /home/user

CMD ["/home/linuxbrew/.linuxbrew/bin/zsh"]
