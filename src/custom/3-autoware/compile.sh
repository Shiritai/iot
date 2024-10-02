#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname $0))

print_info "Download autoware"

WD=${$WD:-${HOME}}

cd $WD
git clone https://github.com/autowarefoundation/autoware.git -b release/2024.03
cd $WD/autoware

print_info "Install autoware"

./setup-dev-env.sh -y --no-nvidia

# Compile autoware
print_info "Preparing compilation environment of autoware"

mkdir src
# error may occur at the first time, run twice if needed may solve the issue
vcs import src < autoware.repos || vcs import src < autoware.repos

print_info "Autoware src prepared"

# override buggy file
cp $SCRIPT_DIR/package.xml \
    $WD/autoware/src/universe/autoware.universe/evaluator/perception_online_evaluator

print_info "Install ros packages"

. /opt/ros/humble/setup.bash
sudo apt-get update -y && sudo apt-get upgrade -y
rosdep update
rosdep install -y --from-paths src \
                  --ignore-src \
                  --rosdistro $ROS_DISTRO \
                  > /dev/null 2>&1

print_info "Autoware repo is ready, compile autoware"

# Run compilation
colcon build --symlink-install \
             --parallel-workers 32 \
             --cmake-args \
             -DCMAKE_BUILD_TYPE=Release

print_info "Autoware compiled successfully"
