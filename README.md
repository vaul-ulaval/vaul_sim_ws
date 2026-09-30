# VAUL Simulation Workspace

`vaul_sim_ws` is a ROS 2 Humble development workspace for RoboRacer software. It
uses the hosted
[`ghcr.io/vaul-ulaval/f1tenth_gym_ros`](https://github.com/vaul-ulaval/f1tenth_gym_ros/pkgs/container/f1tenth_gym_ros)
image as its simulator and keeps the development environment separate from the
simulator image.

## Prerequisites

- Docker Desktop with Compose
- VS Code with the Dev Containers extension
- Foxglove Studio (optional; the simulator exposes its bridge on port `8765`)

## Start the simulator and development container

```bash
docker compose pull
docker compose up --build -d
```

The `simulator` service launches `f1tenth_gym_ros` from the hosted
`ghcr.io/vaul-ulaval/f1tenth_gym_ros:latest` image. Foxglove can connect to
`ws://localhost:8765`.

Open this directory in VS Code and run **Dev Containers: Reopen in Container**
to work in the `devkit` service. The workspace is mounted at
`/home/ros_dev`; add ROS 2 packages and repositories under `src/`, then rebuild
with:

```bash
source /opt/ros/humble/setup.bash
rosdep install --from-paths src --ignore-src --rosdistro humble -r -y
colcon build --symlink-install \
  --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo \
               -DCMAKE_EXPORT_COMPILE_COMMANDS=1
source install/local_setup.bash
```

The startup script runs these dependency and build steps automatically when
`docker compose up` starts the `devkit` service. The VS Code default build task
does the same build with compile commands enabled.

## Example

The included `reactive_control` package subscribes to the simulator's standard
`/scan` topic and publishes `AckermannDriveStamped` messages on `/drive`:

```bash
ros2 run reactive_control wall_follow_node
```

The simulator uses the image's default `sim.yaml` configuration. To customize
the map, vehicle model, starting pose, or simulator behavior, either pass ROS
launch parameters in the Compose command or switch back to a locally built
simulator image.
