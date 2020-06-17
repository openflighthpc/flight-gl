# The Flight GL Tool

## Overview

The Flight GL tool provides a facility for users to manage the lifecycle of a GLX-capable X11 server running on a GPU to provide hardware-accelerated rendering for OpenGL GUI applications.

Flight GL is built on top of [VirtualGL](https://virtualgl.org), an open source toolkit that gives Linux remote display software (such as VNC) the ability to run OpenGL applications with full hardware acceleration.

While VirtualGL is usually configured to make use of a long-lived X11 server operated by the superuser (usually running as display `:0`), Flight GL allows individual users to control the lifecycle of their own, user-operated X11 servers.  This allows users more flexibility in their interactive HPC worklows, deciding at what key points in their workflow they wish to use the GPU resources available to them for GPGPU processing (e.g. CUDA workloads) or visualisation (e.g. OpenGL applications).

## Quick start

 * Start a Flight Desktop session:

    ```
    flight session start gnome
    ```
    
 * Within the desktop session, open a Terminal window and:

    ```
    # 1. Request a Slurm GPU resource allocation.
    salloc -p gpu --gres gpu:1
    
    # 2. Start a GLX session on the allocated node.
    gl connect --start
    
    # 3. Run OpenGL application under VirtualGL.
    vglrun glxgears
    
    # 4. Exit when done.
    exit
    ```


## User guide

Flight GL works in tandem with Flight Desktop, a tool that facilitates access to VNC desktops within an HPC environment. 

Within a terminal session running in a Flight Desktop session, the `gl` command is made available to connect to a remote GPU-capable host, orchestrating the process of configuring the necessary client and server-side daemons.

```shell_session
[alces-cluster@login1 [mycluster] ~]$ gl
Usage: gl COMMAND [[OPTION]... [ARGS]]
Manage life-cycles of hardware accelerated GLX-capable X-servers.

Commands:
  gl start         Start a GLX session.
  gl stop          Stop currently active GLX session.
  gl status        Show currently active GLX session status.
  gl list          List active GLX sessions running on this node.
  gl kill          Kill a running GLX session.
  gl connect       Connect to a GLX-capable node.

Please report bugs to flight@alces-flight.com
Alces Flight home page: <http://alces-flight.com/>
```

### Connecting to a remote GPU-capable host

The `gl connect` command is used to initiate a connection to a remote GPU-capable host. `gl` offers two modes of operation: within a Slurm resource allocation, or standalone.

#### Under a Slurm resource allocation made with `salloc`

1. Request a Slurm resource allocation:

    ```shell_session
    $ # Request a single GPU from a node within the `gpu` partition
    [alces-cluster@login1 [mycluster] ~]$ salloc -p gpu --gres gpu:1
    salloc: Granted job allocation 8415
    ```
    
2. Connect to the allocated node:

    ```shell_session
    [alces-cluster@login1 [mycluster] ~]$ gl connect
    Note: no GLX session is running; use 'gl start' to activate a session.
    [alces-cluster@gpu114 [mycluster] ~]$
    ```

This starts a VirtualGL client process (`vglclient`) on the VNC desktop host and establishes an SSH connection with X forwarding to an allocated node.

Once connected, proceed with "Starting a GLX session" below.

**Notes:**

 * If more than one node is requested within the resource allocation, the SSH connection is made to the first allocated node.  To select a specific node within the allocation, specify the node name on the command-line, e.g. `gl connect gpu04`.

#### Standalone operation

While standalone operation is a simpler approach, the primary drawback is that all benefits of using a job scheduler to orchestrate shared resources no longer apply, and users must collaborate to ensure resources aren't in simultaneous use.

To connect to a known GPU-capable node, for example, `gpu120`:

```shell_session
[alces-cluster@login1 [mycluster] ~]$ gl connect gpu120
Note: no GLX session is running; use 'gl start' to activate a session.
[alces-cluster@gpu120 [mycluster] ~]$
```

This starts a VirtualGL client service (`vglclient`) on the VNC desktop host and establishes an SSH connection with X forwarding to the specified node.

### Starting a GLX session

To start a GLX session on a GPU node use the `gl start` command, e.g.:

```shell_session
[alces-cluster@gpu114 [mycluster] ~]$ gl start
Starting GLX session:

   GPU device: GPU 0 (0x05)
   TTY device: /dev/tty10
  X11 display: :1
  X11 process: 151533

GLX session started for GPU 0 (0x05) attached to display :1
```

Under a Slurm resource allocation, the allocated GPU is used for the GLX session (or the first allocated GPU if multiple GPUs have been requested).

**Notes:**

 * If operating without a Slurm resource allocation, the first GPU that is not currently in use will be selected.
 * Only one GLX session may be active within one connection; `gl start` will refuse to start further GLX sessions if an active session is detected.

### Using a GLX session

Once a GLX session has been started, the usual VirtualGL command `vglrun` should be used to execute the required OpenGL application.  The environment is configured to ensure the use of the correct GLX-capable X server and the user's VirtualGL client service.

For example:

```shell_session
[alces-cluster@gpu114 [mycluster] ~]$ vglrun glxgears
18524 frames in 5.0 seconds = 3704.787 FPS
18690 frames in 5.0 seconds = 3737.841 FPS
18698 frames in 5.0 seconds = 3739.506 FPS
18680 frames in 5.0 seconds = 3735.831 FPS
^C
```

### Ending the current GLX session

Once a user has completed their visualisation work and finished with the GLX session, the session can be ended using the `gl stop` command, e.g.

```shell_session
[alces-cluster@gpu114 [mycluster] ~]$ gl stop
GLX session for GPU 0 (0x05) stopped
```

**Notes:**

 * If the SSH connection is ended (for example, with `exit` or `logout`), the GLX session will be automatically ended preventing accidental consumption of GPU resources.

### Displaying the current GLX session status

The current GLX session status can be queried using the `gl status` command. This will show whether a GLX session is active or not, e.g:

 * When a session is active:

    ```shell_session
    [alces-cluster@gpu114 [mycluster] ~]$ gl status
    Active GLX session for GPU 0 (0x05) attached to display :1
    ```

 * When no session is active:

    ```shell_session
    [alces-cluster@gpu114 [mycluster] ~]$ gl status
    No active GLX session
    ```

### Listing operational GLX sessions

To show a list of all operational GLX sessions you have running on a node, use the `gl list` command, e.g.:

```shell_session
[alces-cluster@gpu114 [mycluster] ~]$ gl list
GPU  |  Bus   |  Display  |  PID
0    |  0x05  |  :1       |  151533
```

**Notes:**

 * The list only shows GLX sessions for your user account running on the node you are currently working on.

### Terminating a stale or unused GLX session

If a GLX session has been left running due to an unclean exit condition, or connectivity failure, it can be cleaned up using the `gl kill` command.  The command requires a single parameter, the GPU index on which the GLX session is running, e.g.:

```shell_session
[alces-cluster@gpu114 [mycluster] ~]$ gl kill 0
gl: killed GLX session for GPU 0
```

**Notes:**

 * It is not possible to kill the currently active GLX session. Use `gl stop` to end a currently active session.

## Advanced connection notes

### Connecting to an existing GLX session on connection

On connection, the `gl connect` command will set up the environment to use an existing GLX session if it is detected.

### Additional connection options

In addition to the standard usage outlined above, two additional options can be supplied at connection time:

#### Automatically starting a GLX session on connection

The `gl connect` command provides a `--start` option that will start a GLX session for immediate use on connection, e.g.:

```shell_session
[alces-cluster@login1 [mycluster] ~]$ salloc -p gpu --gres gpu:1 -w gpu120
salloc: Granted job allocation 8416
[alces-cluster@login1 [mycluster] ~]$ gl connect --start
Starting GLX session:

   GPU device: GPU 0 (0x04)
   TTY device: /dev/tty10
  X11 display: :1
  X11 process: 153955

GLX session started for GPU 0 (0x04) attached to display :1
[alces-cluster@gpu120 [mycluster] ~]$
```

**Notes:**

 * If an existing GLX session is detected, no attempt will be made to start a new session.

#### Using a Slurm step with `srun`

If a Slurm step orchestrated by `srun` is required (usually for access to resource-based environment variables or for interactive MPI processing needs), the connection can be established using the `--srun` option, e.g.:

```shell_session
[alces-cluster@login1 [mycluster] ~]$ salloc -p gpu -N2 --gres gpu:2 -w gpu119,gpu120
salloc: Granted job allocation 8417
[alces-cluster@login1 [mycluster] ~]$ gl connect --srun
Note: no GLX session is running; use 'gl start' to activate a session.
[alces-cluster@gpu119 [mycluster] ~]$ echo $SLURM_STEP_ID
0
[alces-cluster@gpu119 [mycluster] ~]$ echo $SLURM_NODELIST
gpu[119-120]
```

**Notes:**

 * This option is only available under a Slurm resource allocation and uses an alternative method to provide X forwarding back to the VNC desktop host.
 * GUI apps may be less performant when using this connection method rather than the default SSH with X forwarding connection.