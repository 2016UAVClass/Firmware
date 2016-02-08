#!/bin/bash
# For automated install, set permissions to avoid sudo/passwd. On standalone VM, run sudo visudo and add this line to your sudoers file:
# Defaults        !tty_tickets

Defaults        !tty_tickets
export DEBIAN_FRONTEND=noninteractive
sudo usermod -a -G dialout $USER
sudo add-apt-repository ppa:george-edison55/cmake-3.x -y
sudo apt-get update
sudo apt-get -q -y install python-argparse git-core wget zip python-empy qtcreator cmake build-essential genromfs -y
sudo apt-get -q -y install ant protobuf-compiler libeigen3-dev libopencv-dev openjdk-7-jdk openjdk-7-jre clang-3.5 lldb-3.5 -y
sudo add-apt-repository ppa:terry.guo/gcc-arm-embedded -y	
sudo apt-get update
sudo apt-get -q -y install python-serial openocd flex bison libncurses5-dev autoconf texinfo build-essential libftdi-dev libtool zlib1g-dev python-empy gcc-arm-none-eabi -y
mkdir -p ~/src
cd ~/src
git clone https://github.com/darknight-007/Firmware.git
cd Firmware
make px4fmu-v2_default
cd ~/
wget -O /tmp/gazebo6_install.sh http://osrf-distributions.s3.amazonaws.com/gazebo/gazebo6_install.sh; sudo sh /tmp/gazebo6_install.sh
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
sudo apt-get update
sudo apt-get install ros-indigo-desktop
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
sudo apt-get update
sudo apt-get -q -y install ros-indigo-desktop
sudo rosdep init
rosdep update
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt-get -q -y install python-wstool python-rosinstall-generator python-catkin-tools
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init ~/catkin_ws/src
wget https://raw.githubusercontent.com/darknight-007/mavros/master/mavros.rosinstall
wstool merge -t src mavros.rosinstall
wstool update -t src
rosdep install --from-paths src --ignore-src --rosdistro indigo -y
catkin build
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
sudo apt-get -q -y install python-prettytable



