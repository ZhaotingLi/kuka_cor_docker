
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

