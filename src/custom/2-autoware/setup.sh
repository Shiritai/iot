#!/bin/bash

sudo apt update -y && sudo apt install -y python3.10-venv apt-utils

cd ~
git clone https://github.com/autowarefoundation/autoware.git -b release/2024.03
cd ~/autoware

./setup-dev-env.sh -y --no-nvidia

# Compile autoware
mkdir src
vcs import src < autoware.repos

# override buggy file
cp ~/scripts/dev/autoware/package.xml \
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
colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release
