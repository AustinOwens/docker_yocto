#title        :Dockerfile
#description  :This file contains instructions for building a docker image.
#author       :Austin Owens
#date         :9/18/2022
#common_usage :docker build --build-arg USERNAME=<usr> --build-arg UID=<uid> -t yocto-img .
#common_usage :podman build --build-arg USERNAME=<usr> --build-arg UID=<uid> -t yocto-img .
#==========================================================================================

# Download latest base image from Ubuntu
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

# Install dependancies for Yocto
RUN apt-get update \
    && apt-get -y install \
        gawk \ 
        wget \
        git \
        diffstat \
        unzip \
        texinfo \
        gcc \
        build-essential \
        chrpath \
        socat \
        cpio \
        python3 \
        python3-pip \
        python3-pexpect \
        xz-utils \
        debianutils \
        iputils-ping \
        python3-git \
        python3-jinja2 \
        libegl1-mesa \
        libsdl1.2-dev \
        xterm \
        python3-subunit \
        mesa-common-dev \
        zstd \
        liblz4-tool \
        file \
        gcc-arm-none-eabi \
        locales \
        libncurses5 \
        libusb-1.0-0-dev

# Enabling en_US.UTF-8 locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Install dependancies for user dev
RUN apt-get -y install sudo vim tzdata tmux

# Add UID arg and set to 1000 by default unless changed. This should match the UID
# of the host. Check your UID with the command 'id -u'.
ARG UID=1000

# Add USERNAME arg and set to "user" by default unless changed. Dockerfile args
# can be changed by passing in the argument when building the docker image. For
# example: docker build --build-arg USERNAME=<your-username> -t yocto-img .
ARG USERNAME=user

# Add a non-root user with following details:
# username: $USERNAME
# password: $USERNAME
# uid: $UID
# Home dir: /home/$USERNAME
# Groups: sudo, $USERNAME
RUN /usr/sbin/useradd -m -s /bin/bash -u $UID -G sudo $USERNAME \
    && echo $USERNAME:$USERNAME | usr/sbin/chpasswd

# Add build.sh to user's home dir and make executable
ADD build.sh /home/$USERNAME
RUN chmod +x /home/$USERNAME/build.sh

# Set USERNAME to default user when docker is launched
USER $USERNAME
