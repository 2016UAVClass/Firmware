## NSF Student Competition SITL Gazebo test environment 

To install on a fresh Ubuntu VM, open a terminal and go through the following steps.

* wget https://raw.githubusercontent.com/darknight-007/Firmware/master/setup-install.sh
* bash setup-install.sh

(you will be asked for your password in the beginning)

### Without camera plugins
Once installation is over, 
* cd ~/src/Firmware
* make posix_sitl_default gazebo 

It will take a bit the first time you run this. Also, if the build fails, try again. 
You should see a Gazebo client window with the F450 at the center. 

In another terminal, run the mavros node
* roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557"

and, in yet another terminal 
* cd ~/catkin_ws/src/mavros/test_mavros/scripts
* python mavros_wpmission_test.py

You will now see the UAV takeoff, fly a mission, and land again. 

On a terminal, you can look at the list of mavros topics,
* rostopic list

And maybe check out the state of the FMU, 
* rostopic echo /mavros/state


### With camera plugins
<b>GAZEBO ROS</b><br/>
To acquire gazebo camera pugin data, we need to start the SITL stack with no_sim=1. In terminal 1, 
* make no_sim=1 posix_sitl_default gazebo

In a bit, you should see the ASCII PX4 art, and a message 
"Waiting for initial data on UDP. Please start the flight simulator to proceed.."

At this time open another terminal, and use 
* roslaunch mavros gazebo-mavros.launch gui:=true

You should now see both the Gazebo client, and an RQT window showing the camera inage panels, and a line plot for UAV height. 
You will have to click the refresh buttons for the camera image view panels, and choose the front and down camera respectively from the dropdown. The height plot should start updating on its own.

The next step is the same as non gazebo_ros mode. That is, in another terminal 
* cd ~/catkin_ws/src/mavros/test_mavros/scripts
* python mavros_wpmission_test.py

You should now see the UAV take off, and the camera images update accordingly. 

*** It's advised that you close gazebo client at this time so that the controller simultion has maximum fidelity. <br/>
*** do not use gui:=true when starting the gazebo-mavros.launch file for actual simulation use.


------ UPSTREAM INFO-----
## PX4 Flight Core and PX4 Middleware ##

[![Build Status](https://travis-ci.org/PX4/Firmware.svg?branch=master)](https://travis-ci.org/PX4/Firmware) [![Coverity Scan](https://scan.coverity.com/projects/3966/badge.svg?flat=1)](https://scan.coverity.com/projects/3966?tab=overview)

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/PX4/Firmware?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This repository contains the [PX4 Flight Core](http://px4.io), with the main applications located in the src/modules directory. It also contains the PX4 Drone Platform, which contains drivers and middleware to run drones.

*   Official Website: http://px4.io
*   License: BSD 3-clause (see [LICENSE.md](https://github.com/PX4/Firmware/blob/master/LICENSE.md))
*   Supported airframes (more experimental are supported):
  * [Multicopters](http://px4.io/portfolio_category/multicopter/)
  * [Fixed wing](http://px4.io/portfolio_category/vtol/)
  * [VTOL](http://px4.io/portfolio_category/plane/)
*   Releases
  * [Downloads](https://github.com/PX4/Firmware/releases)

### Users ###

Please refer to the [user documentation](http://px4.io) and [user forum](http://discuss.px4.io) for flying drones with the PX4 flight stack.

### Developers ###

  * [Developer Forum / Mailing list](http://groups.google.com/group/px4users)
  * [Guide for Contributions](https://github.com/PX4/Firmware/blob/master/CONTRIBUTING.md)
  * [Developer guide](http://dev.px4.io)


This repository contains code supporting these boards:
  * [Snapdragon Flight](http://dev.px4.io/hardware-snapdragon.html)
  * FMUv1.x
  * FMUv2.x ([Pixhawk](http://dev.px4.io/hardware-pixhawk.html), Pixhawk 2 and [Pixfalcon](http://dev.px4.io/hardware-pixfalcon.html))
  * FMUv4.x (Pixhawk X and [Pixracer](http://dev.px4.io/hardware-pixracer.html))
  * AeroCore (v1 and v2)
  * STM32F4Discovery (basic support) [Tutorial](https://pixhawk.org/modules/stm32f4discovery)
