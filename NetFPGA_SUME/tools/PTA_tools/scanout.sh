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

BA_IPG=0x440900
BA_OQS=0x440300
BA_NF0=0x440400
BA_NF1=0x440500
BA_NF2=0x440600
BA_NF3=0x440700

echo -n "[IPG_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_IPG}18
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

# echo "--------------------------------------------------"
echo -n "[OQS_PKTsIN]: "
${RWAXI}/rwaxi -a ${BA_OQS}14
echo "--------------------------------------------------"

echo -n "[OQS_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_OQS}18
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[OQS_STOR_NF0]: "
${RWAXI}/rwaxi -a ${BA_OQS}1C
echo "--------------------------------------------------"

echo -n "[OQS_REMV_NF0]: "
${RWAXI}/rwaxi -a ${BA_OQS}24
echo "--------------------------------------------------"

echo -n "[OQS_DROP_NF0]: "
${RWAXI}/rwaxi -a ${BA_OQS}2C
echo "--------------------------------------------------"

echo -n "[OQS_QUED_NF0]: "
${RWAXI}/rwaxi -a ${BA_OQS}34
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[OQS_STOR_NF1]: "
${RWAXI}/rwaxi -a ${BA_OQS}38
echo "--------------------------------------------------"

echo -n "[OQS_REMV_NF1]: "
${RWAXI}/rwaxi -a ${BA_OQS}40
echo "--------------------------------------------------"

echo -n "[OQS_DROP_NF1]: "
${RWAXI}/rwaxi -a ${BA_OQS}48
echo "--------------------------------------------------"

echo -n "[OQS_QUED_NF1]: "
${RWAXI}/rwaxi -a ${BA_OQS}50
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[OQS_STOR_NF2]: "
${RWAXI}/rwaxi -a ${BA_OQS}54
echo "--------------------------------------------------"

echo -n "[OQS_REMV_NF2]: "
${RWAXI}/rwaxi -a ${BA_OQS}5C
echo "--------------------------------------------------"

echo -n "[OQS_DROP_NF2]: "
${RWAXI}/rwaxi -a ${BA_OQS}64
echo "--------------------------------------------------"

echo -n "[OQS_QUED_NF2]: "
${RWAXI}/rwaxi -a ${BA_OQS}6C
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[OQS_STOR_NF3]: "
${RWAXI}/rwaxi -a ${BA_OQS}70
echo "--------------------------------------------------"

echo -n "[OQS_REMV_NF3]: "
${RWAXI}/rwaxi -a ${BA_OQS}78
echo "--------------------------------------------------"

echo -n "[OQS_DROP_NF3]: "
${RWAXI}/rwaxi -a ${BA_OQS}80
echo "--------------------------------------------------"

echo -n "[OQS_QUED_NF3]: "
${RWAXI}/rwaxi -a ${BA_OQS}88
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[OQS_STOR_DMA]: "
${RWAXI}/rwaxi -a ${BA_OQS}8C
echo "--------------------------------------------------"

echo -n "[OQS_REMV_DMA]: "
${RWAXI}/rwaxi -a ${BA_OQS}94
echo "--------------------------------------------------"

echo -n "[OQS_DROP_DMA]: "
${RWAXI}/rwaxi -a ${BA_OQS}9C
echo "--------------------------------------------------"

echo -n "[OQS_QUED_DMA]: "
${RWAXI}/rwaxi -a ${BA_OQS}A4

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[NF0_PKTsIN]: "
${RWAXI}/rwaxi -a ${BA_NF0}18

echo "--------------------------------------------------"
echo -n "[NF0_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_NF0}1C

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[NF1_PKTsIN]: "
${RWAXI}/rwaxi -a ${BA_NF1}18
echo "--------------------------------------------------"

echo -n "[NF1_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_NF1}1C

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[NF2_PKTsIN]: "
${RWAXI}/rwaxi -a ${BA_NF2}18
echo "--------------------------------------------------"

echo -n "[NF2_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_NF2}1C

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[NF3_PKTsIN]: "
${RWAXI}/rwaxi -a ${BA_NF3}18
echo "--------------------------------------------------"

echo -n "[NF3_PKTsOUT]: "
${RWAXI}/rwaxi -a ${BA_NF3}1C
echo "--------------------------------------------------"
