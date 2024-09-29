#!/bin/bash

set -e

SCRIPT_DIR=$(realpath $(dirname $0))

print_info "Download autoware"

install_if_dne python3.10-venv apt-utils

cd ~
git clone https://github.com/autowarefoundation/autoware.git -b release/2024.03
cd ~/autoware

print_info "Install autoware"

./setup-dev-env.sh -y --no-nvidia

# Compile autoware
print_info "Preparing compilation environment of autoware"

mkdir src
vcs import src < autoware.repos

# override buggy file
cp $SCRIPT_DIR/package.xml \
    ~/autoware/src/universe/autoware.universe/evaluator/perception_online_evaluator

source /opt/ros/humble/setup.bash
rosdep update
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO

mkdir -p ~/.cache/ccache
touch ~/.cache/ccache/ccache.conf
echo "max_size = 60G" >> ~/.cache/ccache/ccache.conf

echo "export CC=/usr/lib/ccache/gcc" >> ~/.bashrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.bashrc
echo "export CCACHE_DIR=${HOME}/.cache/ccache/" >> ~/.bashrc

echo "export CC=/usr/lib/ccache/gcc" >> ~/.zshrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.zshrc
echo "export CCACHE_DIR=${HOME}/.cache/ccache/" >> ~/.zshrc

# Run compilation
print_info "Compile autoware"
colcon build --symlink-install \
             --parallel-workers 32 \
             --cmake-args \
             -DCMAKE_CUDA_ARCHITECTURES=native \
             -DCMAKE_BUILD_TYPE=Release

print_info "Autoware compiled successfully"
