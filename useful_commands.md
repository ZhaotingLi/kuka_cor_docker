############### !!! IMPORTANT !!! #####################
robot name should be correct!! 7 or 14


### Steps 

1.connect the wires, start robot, lab computer  

1.0 Check the network setting in the lab computer[kuka_lab]: D-Link -> kuka (lower port)  

1.1 Run bringup_remote on the lab computer  

2.start a terminal on my own pc, kill existing spacemouse program  

3.use ping to check connections  

4.Start Docker terminals. Source the ros master with docker.  
  
4.1 Check the ros connection in docker terminal, use rostopic list  

5.Run kuka python controller (local) roslaunch cor_tud_controllers bringup_local.launch model:=14  

6.Run spacemouse launch file spacenavd -v -d & roslaunch spacenav_node classic.launch  

6.1 Check the ros connection in lab computer terminal, use rostopic list 
[May 06] 6.2 also check the output of spacemouse, sometimes it may output non-zero commands even not touched. This issue can be solved by unplug the usb cable and plugging again. 

7.Run kuka programs 

### ros master

source /catkin_ros1_ws/devel/setup.bash 
export ROS_MASTER_URI=http://192.180.1.5:30202 
export ROS_IP=192.180.1.15

conda run -n conda-env-CLIC --no-capture-output python main-kuka-cleaned.py --config-name train_IBC_image_Ta1

conda run -n conda-env-CLIC --no-capture-output python main-kuka-cleaned.py --config-name train_CLIC_Diffusion_image_Ta1



### Run KUKA python controller
roslaunch cor_tud_controllers bringup_remote.launch model:=7 # for lab computer
roslaunch cor_tud_controllers bringup_local.launch model:=14 # for your pc

python3 /catkin_ros1_ws/src/iiwa-ros-imitation-learning/cor_tud_controllers/python/spacenav_control.py iiwa14 
python3 /catkin_ros1_ws/src/iiwa-ros-imitation-learning/cor_tud_controllers/python/spacenav_control_position.py iiwa14 
python3 /catkin_ros1_ws/src/iiwa-ros-imitation-learning/cor_tud_controllers/python/request_joint_position.py iiwa14

## For the cartesian controller,First run the request_joint_posotion.py to make the end-effector at the same pose 

### Docker run ros
sudo docker run -it --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --device=/dev/input/event21 --device=/dev/input/js0 --device=/dev/ttyUSB0  kuka_robot_refactor:v1 bash 

sudo docker run -it --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"  --device=/dev/ttyUSB0  kuka_robot_refactor:v1 bash 

sudo docker run -it --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --device=/dev/input/event8 --device=/dev/input/js0 kuka_robot_refactor:v1 bash 

#### Docker run with entire dev access (for realsense cameras)
sudo docker run -it --net=host --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --privileged -v /dev:/dev kuka_robot_refactor:v1 bash

##### use this one to avoid stuck issue caused by two realsense cameras
sudo docker run -it --rm   --net=host   -e DISPLAY=$DISPLAY   -e QT_X11_NO_MITSHM=1   -v /tmp/.X11-unix:/tmp/.X11-unix:rw   -v /dev/bus/usb:/dev/bus/usb:rw   --group-add video   kuka_robot_refactor:v1   bash

### Docker build ros 
cd /home/zhaoting/ros_docker_packages/kuka_iiwa_ros
sudo docker build -t kuka_robot_refactor:v1 -f dockerfile_kuka_cor_dependencies .

sudo docker build -t kuka_robot:v1 -f dockerfile_kuka_cor_dependencies .  # old, base of BD-COACH image


#### Docker build BD-COACH 
cd /home/zhaoting/TUD_Projects/BD-COACH/Files
sudo docker build -t bd-coach-image -f dockerfile_bd_coach .


### Docker run BD-COACH
xhost +local:docker
sudo docker run -it --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --device=/dev/input/event21 --device=/dev/input/js0 bd-coach-image bash 

conda run -n conda-env-CLIC --no-capture-output python main-receding_horizon_new_config.py --config-name train_CLIC_Diffusion_image_Ta8 

conda run -n conda-env-CLIC --no-capture-output python main-kuka-cleaned.py --config-name train_CLIC_Diffusion_image_Ta1

conda run -n conda-env-CLIC --no-capture-output python env/realsense_Image_receiver.py

### Docker run BD-COACH with GPU
sudo docker run -it --gpus=all --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --device=/dev/input/event8 --device=/dev/input/js0 bd-coach-image bash 

sudo docker run -it --gpus=all --net=host --env="NVIDIA_DRIVER_CAPABILITIES=all" --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"  bd-coach-image bash

### launch real robot 
roslaunch cor_tud_controllers bringup.launch robot_name:=iiwa model:=7 controller:=TorqueController # old


### launch simulation
xhost + local:docker
roslaunch cor_tud_controllers simulation_bringup.launch robot_name:=iiwa model:=7 controller:=TorqueController # old
roslaunch cor_tud_controllers bringup_remote.launch model:=14 simulation:=true 

### space mouse
ls -l /dev/input/by-id/
sudo lsof /dev/input/event23
spacenavd -v -d &
roslaunch spacenav_node classic.launch


### Realsense cameras
roslaunch realsense2_camera rs_multiple_devices.launch serial_no_camera1:=317222075615 serial_no_camera2:=336222073305 
 
### qb hand 
For docker to access it: --device=/dev/ttyUSB0 
roslaunch qb_hand_control control_qbhand.launch standalone:=true activate_on_initialization:=true 
 
### Copy files from docker into local
sudo docker ps
sudo docker cp cdb38dda8c08:app/saved_data/kuka-push-BD-COACH-1027-1505  /home/zhaoting/Documents 

sudo docker cp caef08815862:/catkin_ros1_ws/src/relaxed_ik_ros1/relaxed_ik_core/trajectory_buffer_0.hdf5 ~/outputs/


sudo docker cp b870b092a521:/catkin_ros1_ws/src/relaxed_ik_ros1/relaxed_ik_core/saved_data/ /home/zhaoting/Documents/kuka_box_0411
sudo docker cp b870b092a521:/catkin_ros1_ws/src/relaxed_ik_ros1/relaxed_ik_core/results/ /home/zhaoting/Documents/results

#### locate files location in a container
sudo docker exec -it caef08815862 find / -type f -name "trajectory_buffe*" 2>/dev/null

####  fix permissions of the copied folders 
sudo chown -R $(whoami):$(whoami) outputs/

### Delete non-used docker images
sudo docker container prune 
sudo docker images -a | grep none | awk '{ print $3; }' | sudo xargs docker rmi –force

sudo docker system df    # check the docker memory usage
 sudo docker builder prune # remove unused cache

#### Things/ Parameters need to be changed if the desk positions changes:
spacenav_control
1. x&y limits of end effecotr
2. Goal of the orientation 
jonit_position_control
goal_joint_position

goal_object_position
