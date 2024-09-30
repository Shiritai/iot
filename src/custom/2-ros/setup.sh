#!/bin/bash

set -e

print_info "Installing ROS2, run pre-install commands"

install_if_dne locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

install_if_dne software-properties-common
sudo add-apt-repository -y universe
 
install_if_dne curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt-get update -y && sudo apt-get upgrade

print_info "Ready to install ROS2"

install_if_dne ros-humble-desktop \
               ros-humble-ros-base \
               ros-dev-tools

source /opt/ros/humble/setup.bash

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source /opt/ros/humble/setup.zsh" >> ~/.zshrc

print_info "ROS2 installed successfully"
