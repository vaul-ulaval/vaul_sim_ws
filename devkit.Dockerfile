FROM ros:humble-ros-base

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential clangd clang-format git python3-dev python3-pip sudo \
    ros-humble-ackermann-msgs ros-humble-foxglove-bridge ros-humble-rviz2 \
    ros-humble-ros2-control ros-humble-ros2-controllers \
    ros-humble-rosbag2-storage-mcap \
    && rm -rf /var/lib/apt/lists/*

ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USERNAME=ros_dev

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /home/ros_dev
COPY devkit-startup.bash /usr/local/bin/devkit-startup
RUN chmod +x /usr/local/bin/devkit-startup \
    && printf '%s\n' \
       'source /opt/ros/humble/setup.bash' \
       'if [ -f /home/ros_dev/install/local_setup.bash ]; then source /home/ros_dev/install/local_setup.bash; fi' \
       > /etc/profile.d/ros-dev.sh \
    && cat /etc/profile.d/ros-dev.sh >> /etc/bash.bashrc

ENV SHELL=/bin/bash
USER $USERNAME:$USERNAME
ENTRYPOINT ["/usr/local/bin/devkit-startup"]
