
## Structure

kuka_cor_docker/
├── Dockerfile
├── README.md
├── setup_dependencies.sh
├── kuka_cor_dependencies/
│   ├── kuka_fri/                # Cloned repo
│   ├── SpaceVecAlg/
│   ├── RBDyn/
│   ├── mc_rbdyn_urdf/
│   ├── corrade/
│   └── robot_controllers/


## Set up the dependencies

bash setup_dependencies.sh


## Build the dockers

1. build nvidia_ros (takes around 804.1s)

sudo docker build -t nvidia_ros:latest -f dockerfile_nvidia_ros .

2.build turtlebot3_base [TODO: should intergrated with nvidia_ros or kuka]

sudo docker build -t turtlebot3_base:latest -f dockerfile_tb3_base .

3. build kuka

sudo docker build -t kuka_robot_refactor:v1 -f dockerfile_kuka_cor_dependencies .


## Build the dockerfile of CLIC
dependencies: nvidia Container Toolkit. Otherwise, you will see the following errors: 'docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]]'

Follow https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html, install the NVIDIA Container Toolkit. Then run 'sudo systemctl restart docker' to restart the docker and apply the changes. 

After that, go the the CLIC project folder and build the docker:

cd /home/zhaoting/TUD_Projects/BD-COACH/Files
sudo docker build -t bd-coach-image -f dockerfile_bd_coach .

