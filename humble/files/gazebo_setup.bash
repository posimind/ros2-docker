if [ ! -d "${PWD}/src/simulation_pkg/models" ]; then
    echo "src/simulation_pkg/models folder does not exist."
    return
fi

# cp -r ${PWD}/src/simulation_pkg/models/* ${HOME}/.gazebo/models
SOURCE_MODELS_DIR="${PWD}/src/simulation_pkg/models"
GAZEBO_DIR="${HOME}/.gazebo"
ROSDEP_DIR="${HOME}/.ros/rosdep"
MODELS_DIR="${GAZEBO_DIR}/models"
COPY_DONE_FILE="${GAZEBO_DIR}/copy_autonomous_models.done"

if [ -e "${COPY_DONE_FILE}" ]; then
    echo "Models are already copied. Skipping copy operation."
else
    if [ -d "${GAZEBO_DIR}" ]; then
        echo # Check if .gazebo folder exists
    else
        echo "Creating .gazebo folder as it does not exist."
        mkdir "${GAZEBO_DIR}"
    fi
    if [ -d "${MODELS_DIR}" ]; then
        echo # Check if .gazebo/models folder exists
    else
        echo "Creating models folder as it does not exist."
        mkdir "${MODELS_DIR}"
    fi

    # Copy all contents from package folder to .gazebo/models folder
    if [ -d "${SOURCE_MODELS_DIR}" ]; then
        echo "Copying contents from ${SOURCE_MODELS_DIR} to ${MODELS_DIR}"
        cp -r "${SOURCE_MODELS_DIR}/"* "${MODELS_DIR}/"
    else
        echo "${SOURCE_MODELS_DIR} folder does not exist."
    fi

    # Delete etc folder inside .gazebo/models folder
    if [ -d "${MODELS_DIR}/etc" ]; then
        echo "Deleting ${MODELS_DIR}/etc folder"
        rm -rf "${MODELS_DIR}/etc"
    else
        echo "${MODELS_DIR}/etc folder does not exist."
    fi

    touch "${COPY_DONE_FILE}"
fi

if [ ! -d "${ROSDEP_DIR}" ]; then
    echo "Initializing and updating rosdep"
    rosdep update
fi
rosdep check -i --from-path src --rosdistro humble

function qqq() {
    PIDS=$(ps aux | grep '[g]zserver' | awk '{print $2}')

    for pid in $PIDS; do
        kill -9 $pid
    done
}
export -f qqq

AMENT_PREFIX_PATH_BACKUP=${AMENT_PREFIX_PATH}
function simulation_build() {
    if [ ! -d "${PWD}/src/simulation_pkg" ]; then
        echo "Current directory is not a simulation project path."
        echo "Please navigate to the simulation project directory."
        return 1
    fi

    if [ "$1" == "cleanbuild" ]; then
        echo "Performing clean build."
        AMENT_PREFIX_PATH=${AMENT_PREFIX_PATH_BACKUP}
        rm -rf install/ build/ log/
    fi

    colcon build --packages-select interfaces_pkg || {
        echo "Failed to build interfaces_pkg"
        return 1
    }
    source install/local_setup.bash

    colcon build --symlink-install --packages-select camera_perception_pkg || {
        echo "Failed to build camera_perception_pkg"
        return 1
    }
    source install/local_setup.bash

    colcon build --symlink-install --packages-select decision_making_pkg || {
        echo "Failed to build decision_making_pkg"
        return 1
    }
    source install/local_setup.bash

    colcon build --symlink-install --packages-select debug_pkg || {
        echo "Failed to build debug_pkg"
        return 1
    }
    source install/local_setup.bash

    colcon build --symlink-install --packages-select simulation_pkg || {
        echo "Failed to build simulation_pkg"
        return 1
    }
    source install/local_setup.bash

    colcon build --symlink-install --packages-select lidar_perception_pkg || {
        echo "Failed to build lidar_perception_pkg"
        return 1
    }
    source install/local_setup.bash
}
export -f simulation_build

function run_monotonous_simulation() {
    echo "Running monotonous simulation..."

    echo "Killing existing gazebo processes..."
    killall -9 gazebo gzserver gzclient

    echo "Starting simulation..."
    ros2 launch simulation_pkg driving_sim.launch.py
}
export -f run_monotonous_simulation

function run_complex_simulation() {
    echo "Running complex simulation with obstacles and traffic lights..."

    echo "Killing existing gazebo processes..."
    killall -9 gazebo gzserver gzclient

    echo "Starting simulation..."
    ros2 launch simulation_pkg mission_sim.launch.py
}
export -f run_complex_simulation

function simulation_usage() {
    echo
    echo "How to run simulation:"
    echo "1. Build simulation packages using 'simulation_build' command."
    echo "2. Run monotonous simulation using 'run_monotonous_simulation' command."
    echo "3. Run complex simulation using 'run_complex_simulation' command."
    echo
}
export -f simulation_usage

unset SOURCE_MODELS_DIR
unset GAZEBO_DIR
unset ROSDEP_DIR
unset MODELS_DIR
unset COPY_DONE_FILE

alias MOVE='ros2 service call /go std_srvs/srv/SetBool\"{data: true}\"'
alias STOP='ros2 service call /go std_srvs/srv/SetBool\"{data: false}\"'

export ROS_DOMAIN_ID=0

if [ -d "${PWD}/src/simulation_pkg/models" ]; then
    if [ -s "${PWD}/src/install/local_setup.bash" ]; then
        source ${PWD}/src/install/local_setup.bash
    fi
    echo
    echo "### Welcome to the Autonomous Vehicle Simulation Environment ###"
    simulation_usage
    echo "Enjoy your simulation experience!"
    echo
fi
