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

# Add openembedded metalayers
#bitbake-layers add-layer ../meta-openembedded/meta-oe
#bitbake-layers add-layer ../meta-openembedded/meta-filesystems
#bitbake-layers add-layer ../meta-openembedded/meta-python
#bitbake-layers add-layer ../meta-openembedded/meta-networking

# Add virtualization metalayer
#bitbake-layers add-layer ../meta-virtualization

# Add xilinx metalayers
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-core
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-standalone
bitbake-layers add-layer ../meta-xilinx/meta-microblaze
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-bsp
bitbake-layers add-layer ../meta-xilinx/meta-xilinx-contrib
#bitbake-layers add-layer ../meta-xilinx/meta-xilinx-standalone-experimental
#bitbake-layers add-layer ../meta-xilinx/meta-xilinx-vendor

# Add robodog metalayer
bitbake-layers add-layer ../meta-robodog

# Export BOARD and MACHINE architecture type
#export BOARD='zybo-zynq7'
#export MACHINE='zynq-generic'

export MACHINE='zynq-generic'
export BOARD='zybo-zynq7'

# Add zynq-zybo-z7 DTB path to CONFIG_DTFILE since
# poky/meta-xilinx/meta-xilinx-core/recipes-bsp/device-tree/device-tree.bb depends
# on it.
# export CONFIG_DTFILE="/home/$USR/workspace/poky/meta-robodog/recipes-core/images/zynq-zybo-z7.dtb"

# The BB_ENV_PASSTHROUGH_ADDITIONS var was exported when the oe-init-build-env
# script was sourced above. It is responsable for passing through certain shell
# env vars to the poky build system.
# export BB_ENV_PASSTHROUGH_ADDITIONS="CONFIG_DTFILE $BB_ENV_PASSTHROUGH_ADDITIONS"

# Build RoboDog image
bitbake robodog-image

# Build toaster webserver dependencies and source it
# pip3 install -r $POKYDIR/bitbake/toaster-requirements.txt
# source toaster start webport=0.0.0.0:8000
