

# Docker image building instruction
This README explains how to set up the required dependencies and build the Docker images for the KUKA CoR environment.

## Step 1 Preparing dependencies

### Step 1-1: Structure of the files
To build the docker successfully, the dependencies should be organized as the following structure. 

```text
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
├── iiwa-ros-imitation-learning  # code with python script to control the robot
```

### Step 1-2: Set up the dependencies
We use setup_dependencies.sh to automatically download most of the dependencies. 
```bash
cd kuka_cor_docker/
mkdir kuka_cor_dependencies
bash setup_dependencies.sh
```

### Step 1-3: Clone kuka_ros

**iiwa-ros-imitation-learning** package is the main interface that control the robot. Example codes can be found under '
    iiwa-ros-imitation-learning/cor_tud_controllers/python
'.
```bash
cd kuka_cor_docker/

git clone git@gitlab.tudelft.nl:kuka-iiwa-7-cor-lab/iiwa-ros-imitation-learning.git

cd iiwa-ros-imitation-learning/

git checkout e41c8e6fa8fec8b973012b9ffb8224eaa8d14a9c  # the latest version has conflicts with our code and 500HZ control in kuka

```

## Step 2: Pull the base docker image

Pull the prebuilt `turtlebot3_base` image from Docker Hub before building the KUKA Docker image. The image is available at https://hub.docker.com/repository/docker/zhaoting123/turtlebot3_base/general.

```bash
sudo docker pull zhaoting123/turtlebot3_base:latest
```


You could also build it locally, but it's not recommended: 

1. build nvidia_ros (takes around 804.1s)

```bash
sudo docker build -t nvidia_ros:latest -f dockerfile_nvidia_ros .
```

2. build turtlebot3_base [TODO: should intergrated with nvidia_ros or kuka]


```bash
sudo docker build -t turtlebot3_base:latest -f dockerfile_tb3_base .
```


## Step 3: Build the dockers


```bash
cd kuka_cor_docker/
sudo docker build -t kuka_robot_refactor:v1 -f dockerfile_kuka_cor_dependencies .
```


## Next step:

Once the image is built successfully, follow the steps in [useful_commands.md](useful_commands.md) to control the robot.



## Build the dockerfile of CLIC (not relevant if you do not use CLIC code)
dependencies: nvidia Container Toolkit. Otherwise, you will see the following errors: 'docker: Error response from daemon: could not select device driver "" with capabilities: [[gpu]]'

Follow https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html, install the NVIDIA Container Toolkit. Then run 'sudo systemctl restart docker' to restart the docker and apply the changes. 

After that, go the the CLIC project folder and build the docker:

```bash
cd /home/zhaoting/TUD_Projects/BD-COACH/Files
sudo docker build -t bd-coach-image -f dockerfile_bd_coach .
```
