#!/bin/bash

INSTALL="sudo apt install -y"
UPDATE="sudo apt update -y"

$UPDATE && $INSTALL locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

$INSTALL software-properties-common
sudo add-apt-repository -y universe
 
$UPDATE && $INSTALL curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

$UPDATE && sudo apt upgrade

$INSTALL ros-humble-desktop
$INSTALL ros-humble-ros-base
$INSTALL ros-dev-tools

source /opt/ros/humble/setup.bash

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source /opt/ros/humble/setup.zsh" >> ~/.zshrc
