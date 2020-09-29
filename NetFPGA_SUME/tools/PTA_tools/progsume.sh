#!/bin/bash
##
## Copyright (c) 2018 -
## All rights reserved.
##
## @NETFPGA_LICENSE_HEADER_START@
##
## Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
## license agreements.  See the NOTICE file distributed with this work for
## additional information regarding copyright ownership.  NetFPGA licenses this
## file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
## "License"); you may not use this file except in compliance with the
## License.  You may obtain a copy of the License at:
##
##   http://www.netfpga-cic.org
##
## Unless required by applicable law or agreed to in writing, Work distributed
## under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
## CONDITIONS OF ANY KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations under the License.
##
## @NETFPGA_LICENSE_HEADER_END@
##

DEBUG=3

while true; do
  case "$1" in
    -d) DEBUG="$2"; shift; shift ;;
    * ) break ;;
  esac
done

if [ "$DEBUG" = "0" ]; then

  # LOAD THE BITFILE
  echo "--------------------------------------------------"
  echo "	PROGRAMMING THE FPGA"
  echo "--------------------------------------------------"
  echo ""

  cd ${BITFILE}

  sleep 1

  xsdb ${TOOLS}/run_xsdb.tcl -tclargs top.bit

  echo "--------------------------------------------------"
  echo "	THE FPGA IS NOW PROGRAMMED"
  echo "--------------------------------------------------"
  echo ""

elif [ "$DEBUG" = "1" ]; then

  # BITFILE ALREADY LOADED
  echo ""

else

  # ERROR !!!
  echo "DEBUG FLAG MUST BE SET !!!"
  echo "TERMINATING PROCEDURE"
  exit 1

fi

echo "--------------------------------------------------"
echo "	BRINGING-UP PCI link & NW interfaces"
echo "--------------------------------------------------"
echo ""

sleep 1
bash ${SUME_SDNET}/tools/pci_rescan_run.sh

cd ${SUME_FOLDER}

sleep 1
rmmod sume_riffa

sleep 1
insmod $DRIVER_FOLDER/sume_riffa.ko

sleep 1
ifconfig nf0 up
ifconfig nf1 up
ifconfig nf2 up
ifconfig nf3 up

echo "--------------------------------------------------"
echo "	THE FPGA IS UP AND RUNNING"
echo "--------------------------------------------------"
echo ""

exit 0
