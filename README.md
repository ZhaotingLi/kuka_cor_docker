
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

1. build nvidia_ros

sudo docker build -t nvidia_ros:latest -f dockerfile_nvidia_ros .

2.
