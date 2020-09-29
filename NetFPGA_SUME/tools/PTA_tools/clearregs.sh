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

## TODO: Automatically update addresses, based on:
## -/nf_sume_sdnet_ver_ip/ver_SimpleSumeSwitch

# VER
BA=0x440D0
PKTCOUNTER=10
OUTPORT=20
BASIC=30
META=40

echo "-----------------------------------------------------------"
echo "VERIFIER MODULE (VER):"
echo ""

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[PACKET COUNTER]: "
${RWAXI}/rwaxi -a ${BA}${PKTCOUNTER}0 -w 0

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[REG00] - NF0: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}0 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG01] - NF1: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}1 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG02] - NF2: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}2 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG03] - NF3: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}3 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG04] - ALL ZEROs: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}4 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG05] - NFs BROADCAST ALL: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}5 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG06] - NFs BROADCAST no NF0: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}6 -w 0
echo "-----------------------------------------------------------"

echo -n "[REG07] - NFs BROADCAST no NF1: "
${RWAXI}/rwaxi -a ${BA}${OUTPORT}7 -w 0
echo "-----------------------------------------------------------"

echo -n "BASIC INFO: "
${RWAXI}/rwaxi -a ${BA}${BASIC}E -w 0
echo "-----------------------------------------------------------"

echo -n "META INFO: "
${RWAXI}/rwaxi -a ${BA}${META}F -w 0

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
