# This Dockerfile is based on Open Robotics' ROS Humble Dockerfile from:
# https://github.com/osrf/docker_images/blob/master/ros/humble/ubuntu/jammy/desktop/Dockerfile
FROM osrf/ros:humble-desktop

# ROS simulation project dependencies
RUN apt-get update
RUN apt-get install -y python3-pip

RUN pip install opencv-python pyserial \
    ultralytics==8.2.69 \
    setuptools==58.2.0 \
    pynput

RUN apt install -y \
    gazebo \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-xacro \
    ros-humble-gazebo-ros \
    ros-humble-gazebo-msgs \
    ros-humble-gazebo-plugins

RUN pip install transformers
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN pip install huggingface_hub

RUN apt-get install -y \
    ros-humble-gazebo-ros2-control \
    ros-humble-ackermann-msgs \
    ros-humble-ros-gz-sim \
    ros-humble-ros-gz-bridge \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui

# Install psmisc to use killall. It is required by the simulation package
RUN apt-get update && apt install -y \
    psmisc

# Install additional packages for development
RUN apt-get install -y \
    build-essential \
    wget \
    vim \
    net-tools \
    lsb-release \
    apt-utils \
    htop

COPY files/gazebo_setup.bash /opt/ros/humble/gazebo_setup.bash
RUN echo "source /opt/ros/humble/gazebo_setup.bash" >> /opt/ros/humble/setup.bash

## Misc setting for convenience
# Allow all users to run sudo without a password
RUN echo "ALL   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Node.js to enable using Claude Code installed on the host machine
# by mounting the HOME directory into the Docker container
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
SHELL ["/bin/bash", "-c"]
RUN source ~/.nvm/nvm.sh && nvm install 22
