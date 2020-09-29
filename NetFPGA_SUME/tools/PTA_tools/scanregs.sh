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

# BASE ADDRESS OF THE VERIFIER
BA=0x440D0

ZN=PKTCOUNTER
ZA=10

FN=DROP
FA=30

SN=DSTPORT
SA=40

echo "-----------------------------------------------------------"
echo "VERIFIER MODULE (VER):"
echo ""

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[${ZN}]: "
${RWAXI}/rwaxi -a ${BA}${ZA}0

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[${FN}-REG00]: "
${RWAXI}/rwaxi -a ${BA}${FA}0
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG01]: "
${RWAXI}/rwaxi -a ${BA}${FA}1
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG02]: "
${RWAXI}/rwaxi -a ${BA}${FA}2
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG03]: "
${RWAXI}/rwaxi -a ${BA}${FA}3
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG04]: "
${RWAXI}/rwaxi -a ${BA}${FA}4
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG05]: "
${RWAXI}/rwaxi -a ${BA}${FA}5
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG06]: "
${RWAXI}/rwaxi -a ${BA}${FA}6
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG07]: "
${RWAXI}/rwaxi -a ${BA}${FA}7
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG08]: "
${RWAXI}/rwaxi -a ${BA}${FA}8
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG09]: "
${RWAXI}/rwaxi -a ${BA}${FA}9
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG10]: "
${RWAXI}/rwaxi -a ${BA}${FA}A
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG11]: "
${RWAXI}/rwaxi -a ${BA}${FA}B
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG12]: "
${RWAXI}/rwaxi -a ${BA}${FA}C
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG13]: "
${RWAXI}/rwaxi -a ${BA}${FA}D
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG14]: "
${RWAXI}/rwaxi -a ${BA}${FA}E
echo "-----------------------------------------------------------"

echo -n "[${FN}-REG15]: "
${RWAXI}/rwaxi -a ${BA}${FA}F

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo -n "[${SN}-REG00]: "
${RWAXI}/rwaxi -a ${BA}${SA}0
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG01]: "
${RWAXI}/rwaxi -a ${BA}${SA}1
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG02]: "
${RWAXI}/rwaxi -a ${BA}${SA}2
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG03]: "
${RWAXI}/rwaxi -a ${BA}${SA}3
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG04]: "
${RWAXI}/rwaxi -a ${BA}${SA}4
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG05]: "
${RWAXI}/rwaxi -a ${BA}${SA}5
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG06]: "
${RWAXI}/rwaxi -a ${BA}${SA}6
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG07]: "
${RWAXI}/rwaxi -a ${BA}${SA}7
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG08]: "
${RWAXI}/rwaxi -a ${BA}${SA}8
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG09]: "
${RWAXI}/rwaxi -a ${BA}${SA}9
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG10]: "
${RWAXI}/rwaxi -a ${BA}${SA}A
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG11]: "
${RWAXI}/rwaxi -a ${BA}${SA}B
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG12]: "
${RWAXI}/rwaxi -a ${BA}${SA}C
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG13]: "
${RWAXI}/rwaxi -a ${BA}${SA}D
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG14]: "
${RWAXI}/rwaxi -a ${BA}${SA}E
echo "-----------------------------------------------------------"

echo -n "[${SN}-REG15]: "
${RWAXI}/rwaxi -a ${BA}${SA}F

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

# echo -n "[${TN}-REG00]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}0
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG01]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}1
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG02]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}2
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG03]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}3
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG04]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}4
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG05]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}5
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG06]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}6
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG07]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}7
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG08]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}8
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG09]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}9
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG10]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}A
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG11]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}B
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG12]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}C
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG13]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}D
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG14]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}E
# echo "-----------------------------------------------------------"

# echo -n "[${TN}-REG15]: "
# ${RWAXI}/rwaxi -a ${BA}${TA}F

# echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
