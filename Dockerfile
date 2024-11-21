# Build environment for LineageOS

FROM ubuntu:latest

ENV \
# ccache specifics
    CCACHE_SIZE=100G \
    CCACHE_DIR=/srv/ccache \
    USE_CCACHE=1 \
    CCACHE_COMPRESS=1 \
# Configure Jack
    ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G" \
# Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

EXPOSE 8021

RUN sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list \
 #&& echo -e "\nTypes: deb\nURIs: http://deb.debian.org/debian\nSuites: buster\nComponents: main contrib non-free\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg" >> /etc/apt/sources.list.d/debian.sources \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update -y \
 && apt-get clean -y \
 && apt-get install -y locales \
 && locale-gen --purge en_US.UTF-8 \
 && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y \
# Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      software-properties-common \
      bison \
      build-essential \
      clang \
      curl \
      flex \
      git \
      git-core \
      git-lfs \
      gnupg \
      gperf \
      htop \
      kmod \
      lib32z1-dev \
      libc6-dev-i386 \
      libgl1-mesa-dev \
      liblz4-tool \
      libelf-dev \
      #libncurses5 \
      libncurses6 \
      libncurses5-dev \
      #libncursesw6 \
      libsdl1.2-dev \
      libssl-dev \
      #libwxgtk3.0-dev \
      libx11-dev \
      libxml2 \
      libxml2-utils \
      lld \
      lzop \
      maven \
      neofetch \
      #openjdk-8-jdk \
      openjdk-17-jdk-headless \
      openssh-server \
      pngcrush \
      procps \
      python-is-python3 \
      python3-pip \
      schedtool \
      squashfs-tools \
      unzip \
      x11proto-core-dev \
      xsltproc \
      zip \
      zlib1g-dev \
      zstd \ 
# For 64-bit systems
      g++-multilib \
      gcc-multilib \
      #lib32ncurses-dev \
      lib32readline-dev \
      lib32z1-dev \
# Install additional packages which are useful for building Android
      android-tools-adb \
      android-tools-fastboot \
      bash-completion \
      bc \
      bsdmainutils \
      #bsdtar \
      ccache \
      file \
      git \
      imagemagick \
      nano \
      rsync \
      sudo \
      screen \
      tig \
      tmux \
      vim \
      wget \
 && rm -rf /var/lib/apt/lists/*

ARG hostuid=1000
ARG hostgid=1000

ADD startup.sh /root/startup.sh
RUN groupadd --gid $hostgid --force emanuel \
 && useradd --gid $hostgid --uid $hostuid --non-unique emanuel \
 && rsync -a /etc/skel/ /home/emanuel/ \
 && curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo \
 && git config --system protocol.version 2 \
 && echo "emanuel ALL=NOPASSWD: ALL" > /etc/sudoers.d/emanuel \
 && chmod a+x /root/startup.sh \
 && chown -R emanuel:emanuel /home/emanuel

ENTRYPOINT /root/startup.sh
#ENTRYPOINT ["tail", "-f", "/dev/null"]
