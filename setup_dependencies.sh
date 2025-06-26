#!/bin/bash

# Exit on any error
set -e


cd kuka_cor_dependencies

echo "GCC version:"
gcc --version
echo "G++ version:"
g++ --version

echo "Cloning KUKA FRI..."
git clone https://gitlab.tudelft.nl/kuka-iiwa-7-cor-lab/kuka_fri.git || true
cd kuka_fri && git checkout legacy && cd ..

echo "Cloning SpaceVecAlg..."
git clone --recursive https://github.com/costashatz/SpaceVecAlg.git || true

echo "Cloning RBDyn..."
git clone --recursive https://github.com/costashatz/RBDyn.git || true

echo "Cloning mc_rbdyn_urdf..."
git clone --recursive https://github.com/costashatz/mc_rbdyn_urdf.git || true

echo "Cloning Corrade..."
git clone https://github.com/mosra/corrade.git || true
cd corrade && git checkout 0d149ee9f26a6e35c30b1b44f281b272397842f5 && cd ..

echo "Cloning robot_controllers..."
git clone https://github.com/epfl-lasa/robot_controllers.git || true

echo "Cloning relaxed_ik..."
git clone https://github.com/uwgraphics/relaxed_ik_ros1.git || true
cd relaxed_ik_ros1 && git submodule update --init --recursive && cd ..

echo "Cloning qbhand..."
git clone https://github.com/ros-o/qbhand-ros.git || true
git clone https://bitbucket.org/qbrobotics/qbdevice-ros.git || true

# echo "Cloning robotics-toolbox-python..."
git clone https://github.com/petercorke/robotics-toolbox-python.git

# Optional: if you meant to clone this instead of 'robotics-toolbox-python'
# echo "Cloning robotics-toolbox-python..."
# git clone https://github.com/petercorke/robotics-toolbox-python.git

