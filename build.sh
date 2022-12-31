#!/bin/bash

echo "[INFO] Build stage started"

USR=$(whoami)
echo "[INFO] Running as user: ${USR}"
echo "[INFO] Current working directory: ${pwd}"

if [ $USR = "root" ]; then
	echo "[ERROR] This script should be run as a non-root user"
	exit 1
fi

DEFAULT_BUILD_DIR=/home/$USR/workspace/

# Use default build directory
echo "[INFO] Using default build directory: "$DEFAULT_BUILD_DIR
mkdir -p $DEFAULT_BUILD_DIR
cd $DEFAULT_BUILD_DIR

# Define workspace
WORKSPACE=$(pwd)
echo "[INFO] Workspace: "$WORKSPACE

# Define poky directory
POKYDIR=$WORKSPACE/poky
echo "[INFO] Poky directory: "$POKYDIR

# Prevent git from prompting us such that this requires no user intervention
git config --global color.ui false
git config --global user.name foo
git config --global user.email foo@bar.com

# Source Yocto env
cd $POKYDIR
source oe-init-build-env

# Add xilinx metalayers
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-core
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-standalone
bitbake-layers add-layer ../meta-xilinx/meta-microblaze
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-bsp
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-contrib

# Add robodog metalayer
bitbake-layers add-layer ../meta-robodog

# Export env vars for Yocto
export MACHINE='zynq-generic'
export BOARD='zybo-zynq7'

# The BB_ENV_PASSTHROUGH_ADDITIONS var was exported when the oe-init-build-env
# script was sourced above. It is responsable for passing through certain shell
# env vars to the poky build system.
# export BB_ENV_PASSTHROUGH_ADDITIONS="CONFIG_DTFILE $BB_ENV_PASSTHROUGH_ADDITIONS"

# Build RoboDog image
bitbake robodog-image

# Build toaster webserver dependencies and source it
# pip3 install -r $POKYDIR/bitbake/toaster-requirements.txt
# source toaster start webport=0.0.0.0:8000
