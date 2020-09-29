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

# IPG, OQS & NFs
BA_IPG=0x440900
BA_OQS=0x440300
BA_NF0=0x440400
BA_NF1=0x440500
BA_NF2=0x440600
BA_NF3=0x440700

# VER
BA_VER=0x440D0
ZA="$1"
FA="$2"
SA="$3"
TA="$4"

##################################################
###				IPG, OQS & NFs
##################################################

# IPG PACKETS OUT
${RWAXI}/rwaxi -a ${BA_IPG}18
# OQS PACKETS IN
${RWAXI}/rwaxi -a ${BA_OQS}14
# OQS PACKETS OUT
${RWAXI}/rwaxi -a ${BA_OQS}18
# OQS STORED NF0
${RWAXI}/rwaxi -a ${BA_OQS}1C
# OQS REMOVED NF0
${RWAXI}/rwaxi -a ${BA_OQS}24
# OQS DROPPED NF0
${RWAXI}/rwaxi -a ${BA_OQS}2C
# OQS QUEUED NF0
${RWAXI}/rwaxi -a ${BA_OQS}34
# OQS STORED NF1
${RWAXI}/rwaxi -a ${BA_OQS}38
# OQS REMOVED NF1
${RWAXI}/rwaxi -a ${BA_OQS}40
# OQS DROPPED NF1
${RWAXI}/rwaxi -a ${BA_OQS}48
# OQS QUEUED NF1
${RWAXI}/rwaxi -a ${BA_OQS}50
# OQS STORED NF2
${RWAXI}/rwaxi -a ${BA_OQS}54
# OQS REMOVED NF2
${RWAXI}/rwaxi -a ${BA_OQS}5C
# OQS DROPPED NF2
${RWAXI}/rwaxi -a ${BA_OQS}64
# OQS QUEUED NF2
${RWAXI}/rwaxi -a ${BA_OQS}6C
# OQS STORED NF3
${RWAXI}/rwaxi -a ${BA_OQS}70
# OQS REMOVED NF3
${RWAXI}/rwaxi -a ${BA_OQS}78
# OQS DROPPED NF3
${RWAXI}/rwaxi -a ${BA_OQS}80
# OQS QUEUED NF3
${RWAXI}/rwaxi -a ${BA_OQS}88
# OQS STORED DMA
${RWAXI}/rwaxi -a ${BA_OQS}8C
# OQS REMOVED DMA
${RWAXI}/rwaxi -a ${BA_OQS}94
# OQS DROPPED DMA
${RWAXI}/rwaxi -a ${BA_OQS}9C
# OQS QUEUED DMA
${RWAXI}/rwaxi -a ${BA_OQS}A4
# NF0 PACKETS IN
${RWAXI}/rwaxi -a ${BA_NF0}18
# NF0 PACKETS OUT
${RWAXI}/rwaxi -a ${BA_NF0}1C
# NF1 PACKETS IN
${RWAXI}/rwaxi -a ${BA_NF1}18
# NF1 PACKETS OUT
${RWAXI}/rwaxi -a ${BA_NF1}1C
# NF2 PACKETS IN
${RWAXI}/rwaxi -a ${BA_NF2}18
# NF2 PACKETS OUT
${RWAXI}/rwaxi -a ${BA_NF2}1C
# NF3 PACKETS IN
${RWAXI}/rwaxi -a ${BA_NF3}18
# NF3 PACKETS OUT
${RWAXI}/rwaxi -a ${BA_NF3}1C

echo "-----------------------------------------------"

##################################################
###				VER
##################################################

# VER ZERO
${RWAXI}/rwaxi -a ${BA_VER}${ZA}0

# VER FIRST
${RWAXI}/rwaxi -a ${BA_VER}${FA}0
${RWAXI}/rwaxi -a ${BA_VER}${FA}1
${RWAXI}/rwaxi -a ${BA_VER}${FA}2
${RWAXI}/rwaxi -a ${BA_VER}${FA}3
${RWAXI}/rwaxi -a ${BA_VER}${FA}4
${RWAXI}/rwaxi -a ${BA_VER}${FA}5
${RWAXI}/rwaxi -a ${BA_VER}${FA}6
${RWAXI}/rwaxi -a ${BA_VER}${FA}7
${RWAXI}/rwaxi -a ${BA_VER}${FA}8
${RWAXI}/rwaxi -a ${BA_VER}${FA}9
${RWAXI}/rwaxi -a ${BA_VER}${FA}A
${RWAXI}/rwaxi -a ${BA_VER}${FA}B
${RWAXI}/rwaxi -a ${BA_VER}${FA}C
${RWAXI}/rwaxi -a ${BA_VER}${FA}D
${RWAXI}/rwaxi -a ${BA_VER}${FA}E
${RWAXI}/rwaxi -a ${BA_VER}${FA}F

# VER SECOND
${RWAXI}/rwaxi -a ${BA_VER}${SA}0
${RWAXI}/rwaxi -a ${BA_VER}${SA}1
${RWAXI}/rwaxi -a ${BA_VER}${SA}2
${RWAXI}/rwaxi -a ${BA_VER}${SA}3
${RWAXI}/rwaxi -a ${BA_VER}${SA}4
${RWAXI}/rwaxi -a ${BA_VER}${SA}5
${RWAXI}/rwaxi -a ${BA_VER}${SA}6
${RWAXI}/rwaxi -a ${BA_VER}${SA}7
${RWAXI}/rwaxi -a ${BA_VER}${SA}8
${RWAXI}/rwaxi -a ${BA_VER}${SA}9
${RWAXI}/rwaxi -a ${BA_VER}${SA}A
${RWAXI}/rwaxi -a ${BA_VER}${SA}B
${RWAXI}/rwaxi -a ${BA_VER}${SA}C
${RWAXI}/rwaxi -a ${BA_VER}${SA}D
${RWAXI}/rwaxi -a ${BA_VER}${SA}E
${RWAXI}/rwaxi -a ${BA_VER}${SA}F

# VER THIRD
${RWAXI}/rwaxi -a ${BA_VER}${TA}0
${RWAXI}/rwaxi -a ${BA_VER}${TA}1
${RWAXI}/rwaxi -a ${BA_VER}${TA}2
${RWAXI}/rwaxi -a ${BA_VER}${TA}3
${RWAXI}/rwaxi -a ${BA_VER}${TA}4
${RWAXI}/rwaxi -a ${BA_VER}${TA}5
${RWAXI}/rwaxi -a ${BA_VER}${TA}6
${RWAXI}/rwaxi -a ${BA_VER}${TA}7
${RWAXI}/rwaxi -a ${BA_VER}${TA}8
${RWAXI}/rwaxi -a ${BA_VER}${TA}9
${RWAXI}/rwaxi -a ${BA_VER}${TA}A
${RWAXI}/rwaxi -a ${BA_VER}${TA}B
${RWAXI}/rwaxi -a ${BA_VER}${TA}C
${RWAXI}/rwaxi -a ${BA_VER}${TA}D
${RWAXI}/rwaxi -a ${BA_VER}${TA}E
${RWAXI}/rwaxi -a ${BA_VER}${TA}F
