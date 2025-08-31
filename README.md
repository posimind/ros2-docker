
# ROS 2 Humble Docker Environment

Docker environment setup for autonomous vehicle development using ROS 2 Humble with Gazebo simulation support.

## Overview

This repository provides a containerized ROS 2 Humble environment with autonomous vehicle simulation capabilities, including:

- Gazebo simulation with ROS 2 integration
- Computer vision libraries (OpenCV, YOLO)
- Machine learning frameworks (Transformers, Hugging Face)
- Development tools and VS Code DevContainer support

## Architecture

- **humble/Dockerfile**: ROS 2 Humble environment with simulation and ML dependencies
- **humble/docker-compose.yml**: Docker Compose configuration for development
- **humble/devcontainer.json**: VS Code DevContainer configuration
- **humble/run-compose**: Docker Compose launcher script
- **humble/run-docker**: Direct Docker launcher script
- **humble/files/**: Configuration files (bashrc, gazebo_setup.bash)

## Quick Start

### Option 1: Direct Docker (Recommended)

```bash
# Run interactive shell (builds image if needed)
./humble/run-docker

# Run specific command
./humble/run-docker <command>
```

### Option 2: Docker Compose

```bash
# Run interactive shell
./humble/run-compose

# Run specific command
./humble/run-compose <command>
```

### Option 3: VS Code DevContainer

You can integrate DevContainer by creating a symbolic link in your ROS 2 project directory:

```bash
# Run from your ROS 2 development project directory
ln -sf /path/to/docker/humble/.devcontainer .devcontainer
```

After linking, use "Reopen in Container" command in VS Code to automatically configure the environment.

## Features

### ROS 2 Packages

- `ros-humble-gazebo-ros-pkgs`: Gazebo integration
- `ros-humble-gazebo-ros2-control`: Robot control in simulation
- `ros-humble-ackermann-msgs`: Ackermann steering messages
- `ros-humble-joint-state-publisher`: Joint state management

### Python Libraries

- OpenCV for computer vision
- YOLO (Ultralytics) for object detection
- Transformers and Hugging Face Hub for ML models
- PySerial for hardware communication

### Development Tools

- Node.js 22 via NVM
- Build tools and utilities
- Gazebo simulation environment
- VS Code extensions for ROS/Python development

## Environment Configuration

The container preserves host environment through:

- User permission mapping (`/etc/passwd`, `/etc/group`, `/etc/shadow`)
- Home directory mounting
- Current working directory context
- X11 display forwarding for GUI applications
- Proper UID/GID mapping to avoid permission issues
