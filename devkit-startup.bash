#!/usr/bin/env bash
set -eo pipefail

source /opt/ros/humble/setup.bash
cd /home/ros_dev

if [ -d src ] && find src -name package.xml -print -quit | grep -q .; then
    rosdep update --rosdistro humble >/dev/null 2>&1 || true
    rosdep install --from-paths src --ignore-src --rosdistro humble -r -y
    colcon build --symlink-install \
        --event-handlers console_cohesion+ \
        --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=1
    source install/local_setup.bash
fi

echo "VAUL ROS 2 development environment ready."
exec "$@"
