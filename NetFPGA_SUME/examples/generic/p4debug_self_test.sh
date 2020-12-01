#!/bin/bash

# Copyright (c) 2018 Pietro Bressana,
# Universita' della Svizzera italiana, Lugano (Switzerland)
# pietro.bressana@usi.ch
# All rights reserved.

# @NETFPGA_LICENSE_HEADER_START@

# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:

# http://www.netfpga-cic.org

# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.

# @NETFPGA_LICENSE_HEADER_END@

timestamp=$(date +"%Y-%m-%d_%H-%M")

repo=${SUME_FOLDER}
tools=${repo}/tools/P4Debug_tools
script=${P4_PROJECT_DIR}/test_infrastructure

burst=10000000
bursthex=0
queue=0
queuehex=0
okcount=0
kocount=0
sleeptime=90
hdr=38

#########################################################################################################
### 					GENERATE TEST PACKETS
#########################################################################################################

# CREATE RESULTS FOLDER
mkdir -pv ${script}/results

for pktsize in 64 65 96 97 128 129 160 161 192 193 224 225 256 257 384 385 512 513 768 769 1024 1025 1514; do

	for gap in 50 40 30 10 5 3 2 1 0; do

			# PROGRAM SWITCH
			cd ${tools}
			./progsume.sh
			sleep 15
			./progtabs.sh
			sleep 3

			echo " >>> PKTSIZE:" ${pktsize} "GAP:" ${gap}
			echo ""

			# GENERATE PACKETS
			cd ${tools}
			./genpkts.sh -b ${burst} -g \D\-${gap} -p ${pktsize} -s ${hdr}
			sleep ${sleeptime}

			# COLLECT RESULTS
			cd ${script}/results
			sh ${tools}/scanout.sh > ${pktsize}\_${gap}.txt

			sleep 3

	done # GAP

done # PKTSIZE

#########################################################################################################
### 					CHECK RESULTS
### TODO: compare pkts generated by IPG with pkts entering OQS for finding pkts dropped by PPL
#########################################################################################################

# ENTER RESULTS FOLDER
cd ${script}/results

# CREATE TOBECHECKED FOLDER
mkdir -pv tobechecked

# CONVERT BURST TO HEX
bursthex=$(echo "obase=16; ${burst}" | bc)

# COMPUTE PACKETS TO EACH QUEUE
queue=$((burst / 4 ))

# CONVERT QUEUE TO HEX
queuehex=$(echo "obase=16; ${queue}" | bc)

# ENTER RESULTS FOLDER
cd ${script}/results/

# CREATE GOLDEN MODEL
echo "[IPG_PKTsOUT]: READ  0x44090018 = 0x${bursthex}" > golden_model
echo "[OQS_PKTsIN]: READ  0x44030014 = 0x${bursthex}" >> golden_model
echo "[OQS_PKTsOUT]: READ  0x44030018 = 0x${bursthex}" >> golden_model
echo "[OQS_STOR_NF0]: READ  0x4403001c = 0x${queuehex}" >> golden_model
echo "[OQS_REMV_NF0]: READ  0x44030024 = 0x${queuehex}" >> golden_model
echo "[OQS_STOR_NF1]: READ  0x44030038 = 0x${queuehex}" >> golden_model
echo "[OQS_REMV_NF1]: READ  0x44030040 = 0x${queuehex}" >> golden_model
echo "[OQS_STOR_NF2]: READ  0x44030054 = 0x${queuehex}" >> golden_model
echo "[OQS_REMV_NF2]: READ  0x4403005c = 0x${queuehex}" >> golden_model
echo "[OQS_STOR_NF3]: READ  0x44030070 = 0x${queuehex}" >> golden_model
echo "[OQS_REMV_NF3]: READ  0x44030078 = 0x${queuehex}" >> golden_model
echo "[NF0_PKTsOUT]: READ  0x4404001c = 0x${queuehex}" >> golden_model
echo "[NF1_PKTsOUT]: READ  0x4405001c = 0x${queuehex}" >> golden_model
echo "[NF2_PKTsOUT]: READ  0x4406001c = 0x${queuehex}" >> golden_model
echo "[NF3_PKTsOUT]: READ  0x4407001c = 0x${queuehex}" >> golden_model

# SCAN TXT FILES
for f in *.txt; do

	echo ">>> Processing $f:";

	# REMOVE UNUSEFUL LINES
	sed -i -e '2d;4d;6d;8d;10,14d;16d;18,22d;24d;26,30d;32d;34,48d;50,52d;54,56d;58,60d;62d' ${f}

	# DIFF WITH GOLDEN MODEL & MOVE TO TOBECHECKED
	if diff -i ${f} golden_model >/dev/null ; then
		# same
		echo "Result is OK"
		okcount=$((okcount+1))
	else
		# different
		echo "Result needs to be checked!"
		mv ${f} ${script}/results/tobechecked/
		kocount=$((kocount+1))
	fi	

done # scan files

echo ""
echo "***************************************************************************************"
echo "TOT FILES:" $((okcount+kocount))
echo "OK  FILES:" ${okcount}
echo "KO  FILES:" ${kocount}
echo "***************************************************************************************"

# RENAME RESULTS FOLDER
cd ${script}
mv results/ results\_${burst}\_${timestamp}/

echo ""
echo "***************************************************************************************"
echo "*******************            TEST DONE !!!               ****************************"
echo "***************************************************************************************"
