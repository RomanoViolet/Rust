# Adapted from https://github.com/RomanoViolet/Rust
FROM public.ecr.aws/lts/ubuntu:24.04

# On single RUN command: https://coderwall.com/p/4g8znw/things-i-learned-while-writing-a-dockerfile
LABEL RustTools.version="0.2"
LABEL vendor="RomanoViolet, 19875252+RomanoViolet@users.noreply.github.com"
LABEL RustTools.release-date="2026-04-01"
LABEL RustTools.version.is-production="No"

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000
ENV LANGUAGE=en_US:en
ENV LANG=en_US.UTF-8
ENV LANG=C.UTF-8
ENV DISPLAY=:0
ENV LC_ALL=C.UTF-8

# Tell debian that we are running non-interactively
ENV DEBIAN_FRONTEND=noninteractive

# Install Core components.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt --fix-broken install && \
  apt-get install -qqy  ca-certificates && \
  apt-get -qqy upgrade && \
  apt-get -y install --no-install-recommends apt-utils dialog 2>&1 && \
  apt-get install -y build-essential && \
  apt-get install -y cmake && \
  apt-get install -y software-properties-common && \
  apt-get install -y sudo && \
  apt-get install -qqy libz-dev && \
  apt-get install -qqy curl unzip && \
  apt-get install -qqy gnupg && \
  apt-get install -qqy net-tools && \
  apt-get install -qqy wget && \
  apt-get install -qqy pkg-config && \
  apt-get install -qqy libssl-dev  && \
  apt-get install -qqy openssl && \
  apt-get install -qqy bash && \
  apt-get install -qqy git git-lfs && \
  apt-get install -qqy lsof && \
  apt-get install -qqy curl && \
  apt-get install -qqy apt-transport-https && \
  apt-get install -qqy locales && \
  apt-get install -qqy powerline powerline-gitstatus fonts-powerline && \
  #
  #
  # Setup locales
  # RUN \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8 && \
  #
  # Update the existing 'ubuntu' user to match the host UID/GID
  # groupadd --gid $USER_GID $USERNAME && \
  # useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
  # echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  # chmod 0440 /etc/sudoers.d/$USERNAME && \
  #
  # Ensure home directory ownership is correct BEFORE heavy installs
  chown -R $USERNAME /home/$USERNAME && \
  #
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME



# Add default home for the non-admin user
USER $USERNAME
WORKDIR /home/$USERNAME
ADD --chown=$USERNAME Configurations/.bashrc /home/$USERNAME/.bashrc

RUN \
  chmod +x /home/$USERNAME/.bashrc && \
  mkdir /home/$USERNAME/.config && \
  # mkdir /home/$USERNAME/.config/powerline-shell && \
  mkdir /home/$USERNAME/.config/themes

# COPY --chown=$USERNAME Configurations/powerline-shell/ /home/$USERNAME/.config/powerline-shell/
ADD --chown=$USERNAME Configurations/themes/ /home/$USERNAME/.config/themes/

# Rust components
RUN \
  curl -sS https://sh.rustup.rs -sSf | sh -s -- -y && \
  export PATH="/home/${USERNAME}/.cargo/bin:$PATH" && \
  echo "export PATH=\"/home/${USERNAME}/.cargo/bin:$PATH\"" >> /home/${USERNAME}/.bashrc && \
  rustup component add clippy && \
  chmod +x /home/${USERNAME}/.bashrc && \
  PATH=/home/${USERNAME}/.cargo/bin:$PATH && \
  cargo install cargo-watch && \
  cargo install cargo-llvm-cov && \
  cargo install grcov && \
  cargo install cargo-checkmate && \
  cargo install cargo-unused-features && \
  cargo install cargo-bloat && \
  rustup component add llvm-tools-preview

# Cleanup
USER root
RUN \
  apt -y autoremove && \
  apt-get purge -y --auto-remove build-essential && \
  apt-get purge -y --auto-remove software-properties-common && \
  apt-get purge -y --auto-remove curl wget && \
  apt-get purge -y --auto-remove xz-utils && \
  apt-get purge -y --auto-remove apt-transport-https && \
  apt autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Define default command.
CMD ["/bin/bash"]
