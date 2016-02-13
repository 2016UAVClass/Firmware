#!/bin/bash
# For automated install, set permissions to avoid sudo/passwd. On standalone VM, run sudo visudo and add the following line to your sudoers file (or use sudo visudo to enter the editor):
# Defaults        !tty_tickets

export DEBIAN_FRONTEND=noninteractive

#PX4 MIDDLEWARE AND SITL STACK
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
wget https://cmake.org/files/v3.3/cmake-3.3.2-Linux-x86_64.sh
chmod +x cmake-3.3.2-Linux-x86_64.sh
sudo mkdir /opt/cmake-3.3.2)
sudo ./cmake-3.3.2-Linux-x86_64.sh --prefix=/opt/cmake-3.3.2 --exclude-subdir
rm cmake-3.3.2-Linux-x86_64.sh
make 
make px4fmu-v2_default
cd ~/

#GAZEBO 6
wget -O /tmp/gazebo6_install.sh http://osrf-distributions.s3.amazonaws.com/gazebo/gazebo6_install.sh 
sed -i 's/apt-get install/apt-get -q -y install/g' /tmp/gazebo6_install.sh
sudo sh /tmp/gazebo6_install.sh
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116
sudo apt-get update
sudo apt-get -q -y install ros-indigo-desktop python-prettytable
sudo rosdep init
rosdep update
source /opt/ros/indigo/setup.bash

# GAZEBO MODEL FOLDER 
echo "export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:$HOME/src/Firmware/Tools/sitl_gazebo/Build" >> ~/.bashrc
echo "export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:$HOME/src/Firmware/Tools/sitl_gazebo/models" >> ~/.bashrc

# UPDATE .BASHRC
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc
mkdir -p ~/.config/ros.org/
cp ~/src/Firmware/rqt_gui.ini ~/.config/ros.org/
 
wget -O /tmp/setup-mavros.sh https://raw.githubusercontent.com/darknight-007/Firmware/master/setup-mavros.sh
bash /tmp/setup-mavros.sh 

