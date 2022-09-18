#!/bin/bash

echo "[INFO] build stage started"

usr=$(whoami)
echo "[INFO] running as user: ${usr}"
echo "[INFO] current working directory:"
pwd

if [ $usr = "root" ]; then
	echo "[ERROR] This script should be run as a non-root user"
	exit 1
fi

DEFAULT_BUILD_DIR=/home/$usr/workspace/

# Use default build directory unless user specified another
if [ "$#" -ne 1 ]; then
	echo "[INFO] Using default build directory: "$DEFAULT_BUILD_DIR
	mkdir -p $DEFAULT_BUILD_DIR
	cd $DEFAULT_BUILD_DIR
else
	echo "[INFO] Using provided build directory: "$1
	mkdir -p $1
	cd $1
	set -- "" # Unset to prevent issues with source calls later
fi

# Define workspace
workspace=$(pwd)
echo "[INFO] Workspace: "$workspace

# Define poky directory
pokydir=$workspace/poky
echo "[INFO] Poky directory: "$pokydir

# Prevent git from prompting us such that this requires no user intervention
git config --global color.ui false
git config --global user.name foo
git config --global user.email foo@bar.com

# Get Yocto
git clone -b kirkstone git://git.yoctoproject.org/poky.git
cd $pokydir
