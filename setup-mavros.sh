#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
source $HOME/.bashrc
sudo apt-get -q -y install python-wstool python-rosinstall-generator python-catkin-tools ros-indigo-gazebo6-ros
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init ~/catkin_ws/src
wget https://raw.githubusercontent.com/darknight-007/mavros/master/mavros.rosinstall
wstool merge -t src mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro indigo -y
source $HOME/.bashrc
catkin build
echo "source $HOME/catkin_ws/devel/setup.bash" >> ~/.bashrc

