# Flight GL

The Flight GL tool provides a facility for users to manage the
lifecycle of a GLX-capable X11 server running on a GPU to provide
hardware-accelerated rendering for OpenGL GUI applications.

## Overview

Flight GL is built on top of VirtualGL, an open source toolkit that
gives Linux remote display software (such as VNC) the ability to run
OpenGL applications with full hardware acceleration.

While VirtualGL is usually configured to make use of a long-lived X11
server operated by the superuser (usually running as display :0),
Flight GL allows individual users to control the lifecycle of their
own, user-operated X11 servers. This allows users more flexibility in
their interactive HPC worklows, deciding at what key points in their
workflow they wish to use the GPU resources available to them for
GPGPU processing (e.g. CUDA workloads) or visualisation (e.g. OpenGL
applications).

## Installation

Install from git:

```
git clone https://github.com/openflighthpc/flight-gl
cd flight-gl
bin/gl --help
```

Or install the RPM or DEB from the OpenFlight repos:

```
yum install flight-gl
apt-get install flight-gl
```

## Prerequisites

If installing from git, you'll also need to install some other packages.

### EL7

 * Install the `VirtualGL` package (EPEL) and `xorg-x11-server-Xorg` package.

### Ubuntu 18.04

 * TBC.

## Operation

Please refer to the [Quick Start and User Guide](GUIDE.md) for more details.

# Contributing

Fork the project. Make your feature addition or bug fix. Send a pull
request. Bonus points for topic branches.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

# Copyright and License

Eclipse Public License 2.0, see [LICENSE.txt](LICENSE.txt) for details.

Copyright (C) 2020-present Alces Flight Ltd.

This program and the accompanying materials are made available under
the terms of the Eclipse Public License 2.0 which is available at
[https://www.eclipse.org/legal/epl-2.0](https://www.eclipse.org/legal/epl-2.0),
or alternative license terms made available by Alces Flight Ltd -
please direct inquiries about licensing to
[licensing@alces-flight.com](mailto:licensing@alces-flight.com).

Flight GL is distributed in the hope that it will be
useful, but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER
EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR
CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR
A PARTICULAR PURPOSE. See the [Eclipse Public License 2.0](https://opensource.org/licenses/EPL-2.0) for more
details.
