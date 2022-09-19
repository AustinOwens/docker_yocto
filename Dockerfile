#title           :Dockerfile
#description     :This file contains instructions for building a docker image.
#author          :Austin Owens
#date            :9/18/2022
#common_usage    :docker build --build-arg USERNAME=<usr> -t yocto-img .
#==============================================================================

# Download latest base image from Ubuntu
FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# Install dependancies for Yocto
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        gawk \
        wget \
        git-core \
        diffstat \
        unzip \
        texinfo \
        gcc-multilib \
        build-essential \
        chrpath \
        socat \
        libsdl1.2-dev \
        xterm

# Install dependancies for user dev
RUN apt-get -y install sudo vim git python3 python3-pip tzdata


# Add USERNAME arg and set to "user" by default unless changed. Dockerfile args
# can be changed by passing in the argument when building the docker image. For
# example: docker build --build-arg USERNAME=<your-username> -t yocto-img .
ARG USERNAME=user

# Add a non-root user with following details:
# username: $USERNAME
# password: $USERNAME
# Home dir: /home/$USERNAME
# Groups: sudo, $USERNAME
RUN /usr/sbin/useradd -m -s /bin/bash -G sudo $USERNAME \
    && echo $USERNAME:$USERNAME | usr/sbin/chpasswd

# Add build.sh to user's home dir
ADD build.sh /home/$USERNAME

# Set USERNAME to default user when docker is launched
USER $USERNAME
