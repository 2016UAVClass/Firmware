#!/bin/bash

# MAVROS
sudo apt-get -q -y install python-wstool python-rosinstall-generator python-catkin-tools ros-indigo-gazebo6-ros ros-indigo-gazebo6-plugins 
source /opt/ros/indigo/setup.bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init ~/catkin_ws/src
wget https://raw.githubusercontent.com/darknight-007/mavros-nsf-student-competition/master/mavros.rosinstall
wstool merge -t src mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro indigo -y
catkin build
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc


