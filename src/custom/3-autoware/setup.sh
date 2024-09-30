#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname $0))

print_info "Download autoware"

install_if_dne python3.10-venv apt-utils

cd ~
git clone https://github.com/autowarefoundation/autoware.git -b release/2024.03
cd ~/autoware

print_info "Install autoware"

echo "export PATH=\$PATH:/home/shiritai/.local/bin" >> ~/.bashrc
echo "export PATH=\$PATH:/home/shiritai/.local/bin" >> ~/.zshrc
source ~/.bashrc

./setup-dev-env.sh -y --no-nvidia

# Compile autoware
print_info "Preparing compilation environment of autoware"

mkdir src
# error may occur at the first time, run twice if needed may solve the issue
vcs import src < autoware.repos || vcs import src < autoware.repos

print_info "Autoware src prepared"

# override buggy file
cp $SCRIPT_DIR/package.xml \
    ~/autoware/src/universe/autoware.universe/evaluator/perception_online_evaluator

print_info "Install ros packages"

. /opt/ros/humble/setup.bash
sudo apt-get update -y && sudo apt-get upgrade -y
rosdep update
rosdep install -y --from-paths src \
                  --ignore-src \
                  --rosdistro $ROS_DISTRO \
                  > /dev/null 2>&1

print_info "Autoware repo is ready"

print_info "Setup ccache..."

mkdir -p ~/.cache/ccache
touch ~/.cache/ccache/ccache.conf
echo "max_size = 60G" >> ~/.cache/ccache/ccache.conf

echo "export CC=/usr/lib/ccache/gcc" >> ~/.bashrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.bashrc
echo "export CCACHE_DIR=\${HOME}/.cache/ccache/" >> ~/.bashrc

echo "export CC=/usr/lib/ccache/gcc" >> ~/.zshrc
echo "export CXX=/usr/lib/ccache/g++" >> ~/.zshrc
echo "export CCACHE_DIR=\${HOME}/.cache/ccache/" >> ~/.zshrc

print_info "Setup ccache successfully"

# Run compilation
print_info "Compile autoware"
colcon build --symlink-install \
             --parallel-workers 32 \
             --cmake-args \
             -DCMAKE_BUILD_TYPE=Release

print_info "Autoware compiled successfully"
