
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Docker environment setup for ROS 2 Humble development. The repository contains Docker configurations to run ROS 2 Humble desktop environment with proper user permissions and display forwarding.

## Architecture

- **humble/Dockerfile**: Minimal Dockerfile extending the official ROS 2 Humble desktop image
- **humble/run**: Shell script that configures and runs the Docker container with:
  - User permission mapping (passwd, group, shadow, sudoers)
  - Home directory and current working directory mounting
  - X11 display forwarding for GUI applications
  - Proper user ID mapping to avoid permission issues

## Common Commands

### Running the ROS 2 Environment
```bash
# Run interactive shell in ROS 2 container
./humble/run

# Run specific command in ROS 2 container
./humble/run <command>
```

### Building Docker Image
```bash
# Build the humble image (if modifications are made to Dockerfile)
cd humble
docker build -t osrf/ros:humble-desktop .
```

## Development Workflow

The `humble/run` script is the primary entry point for development. It creates a containerized ROS 2 environment while preserving:
- File system permissions
- GUI application support via X11 forwarding
- Access to host filesystem through volume mounts
- Current working directory context

The script accepts optional arguments to run specific commands instead of an interactive shell.
