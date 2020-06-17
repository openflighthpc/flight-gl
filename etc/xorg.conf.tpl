#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of Flight GL.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight GL is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight GL. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight GL, please visit:
# https://github.com/openflighthpc/flight-gl
#==============================================================================
Section "DRI"
  Mode 0600
EndSection

Section "ServerLayout"
  Identifier "Flight GL"
  Screen 0 "screen0" 0 0
EndSection

Section "Device"
  Identifier  "nv0"
  Driver "nvidia"
  BusID  "PCI:%BUSID%:0:0"
#  Option "ProbeAllGpus" "true"
#  Option "NoLogo" "true"
#  Option "UseEDID" "false"
#  Option "UseDisplayDevice" "none"
EndSection

Section "Screen"
  Identifier "screen0"
  Device "nv0"
  Option "ConnectedMonitor" "DFP-0"
EndSection
