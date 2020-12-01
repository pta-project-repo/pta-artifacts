# !/usr/bin/python
#
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

# 00 00 00 00 00 00 -> device without a MAC address
# FF:FF:FF:FF:FF:FF -> broadcast (not valid as source MAC)
# 01:XX:XX:XX:XX:XX -> multicast (not valid as source MAC)

import os
import sys
import subprocess
import time
import re

# COLLECT TIMESTAMP
localtime = time.localtime(time.time())
timestamp = str(localtime.tm_year) + "-" + str(localtime.tm_mon) + "-" + str(localtime.tm_mday) + "_" + str(localtime.tm_hour) + "-" + str(localtime.tm_min)

tools = os.environ['TOOLS']
results = os.getcwd()+"/"+"res_"+timestamp

sleeptime=90
hdr=14

NF0 = "B-00000001"
NF1 = "B-00000100"
NF2 = "B-00010000"
NF3 = "B-01000000"
BRD = "B-01010101"
AZR = "B-00000000"
ONE = "B-11111111"

# PACKET SIZES
#pktsizelist = [64, 65, 96, 97, 128, 129, 160, 161, 192, 193, 224, 225, 256, 257, 384, 385, 512, 513, 768, 769, 1024, 1025, 1514]
pktsizelist = [128]

# GAP SIZES
#gapsizelist = [50, 40, 30, 10, 5, 3, 2, 1, 0]
gapsizelist = [50]

# BURST SIZES
burstsizelist = [10000000]

### METADATA [0-15][0-n]:
numcol=3

meta =[
	[  "I-0",  "I-0",  "I-0",  "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0"   ], # FLAGS
	[  "I-0",  "I-0",  "I-0",  "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0",   "I-0"   ], #m1
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m2
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m3
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m4
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m5
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m6
	[  "H-FF", "H-FF", "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-FF",  "H-AA",  "H-11",  "H-17"  ], #m7
	[  AZR,     AZR,    AZR  ,   AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR,     AZR    ], #m8
	[  NF0,     NF1,    NF2  ,   NF3,     NF0,     NF1,     NF2,     NF3,     NF0,     NF1,     NF2,     NF3,     NF0,     NF1,     NF2,     NF3,     NF0,     NF1,     NF1,     NF1    ], #m9
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ], #m10
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ], #m11
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ], #m12
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ], #m13
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ], #m14
	[  "H-AA", "H-BB", "H-CC",  "H-DD",  "H-EE",  "H-01",  "H-02",  "H-03",  "H-04",  "H-05",  "H-06",  "H-07",  "H-08",  "H-09",  "H-10",  "H-11",  "H-17",  "H-FF",  "H-FF",  "H-FF"  ]  #m15
]

#########################################################################################################
### 					GENERATE TEST PACKETS
#########################################################################################################

# CREATE RESULTS FOLDER
os.makedirs(results)

for pktsize in pktsizelist:

	for gap in gapsizelist:
	
		# PROGRAM SWITCH
		os.chdir(tools)
		subprocess.call(["./progsume.sh", "-d", "0"])
		subprocess.call(["sleep", "15"])
		subprocess.call(["./progtabs.sh"])
		subprocess.call(["sleep", "3"])

		# TRAINING
		for metacol in range(17):

			burst = 1

			gpgap = "D-" + str(gap)

			# GENERATE PACKETS
			os.chdir(tools)
			subprocess.call(["./genpkts.sh", "-b", str(burst), "-f", meta[0][metacol], "-g", str(gpgap), "-p", str(pktsize), "-s", str(hdr), "--m1", meta[1][metacol], "--m2", meta[2][metacol], "--m3", meta[3][metacol], "--m4", meta[4][metacol], "--m5", meta[5][metacol], "--m6", meta[6][metacol], "--m7", meta[7][metacol], "--m8", meta[8][metacol], "--m9", meta[9][metacol], "--m10", meta[10][metacol], "--m11", meta[11][metacol], "--m12", meta[12][metacol], "--m13", meta[13][metacol], "--m14", meta[14][metacol], "--m15", meta[15][metacol]])
			subprocess.call(["sleep", str(1)])

		# CLEAR DEBUG REGISTERS
		os.chdir(results)
		subprocess.call(["sh", tools+"/"+"checkoutver.sh"])

		# PACKET GENERATION
		for metacol in range(17, 20):

			burst = 1

			print("")
			print(">>> GENERATING TEST PACKET(s)")
			print("")

			gpgap = "D-" + str(gap)

			# GENERATE PACKETS
			os.chdir(tools)
			subprocess.call(["./genpkts.sh", "-b", str(burst), "-f", meta[0][metacol], "-g", str(gpgap), "-p", str(pktsize), "-s", str(hdr), "--m1", meta[1][metacol], "--m2", meta[2][metacol], "--m3", meta[3][metacol], "--m4", meta[4][metacol], "--m5", meta[5][metacol], "--m6", meta[6][metacol], "--m7", meta[7][metacol], "--m8", meta[8][metacol], "--m9", meta[9][metacol], "--m10", meta[10][metacol], "--m11", meta[11][metacol], "--m12", meta[12][metacol], "--m13", meta[13][metacol], "--m14", meta[14][metacol], "--m15", meta[15][metacol]])
			subprocess.call(["sleep", str(sleeptime)])

			# COLLECT RESULTS
			os.chdir(results)
			output = open(str(pktsize)+"_"+str(gap)+"_"+str(burst)+"_"+str(metacol)+"_"+"RAW.txt", "w")
			subprocess.call(["sh", tools+"/"+"checkoutver.sh"], stdout=output)
			output.close()
			subprocess.call(["sleep", "3"])

print("")
print("***************************************************************************************")
print("*******************       RAW RESULTS COLLECTED !!!        ****************************")
print("***************************************************************************************")

#########################################################################################################
### 					CHECK RESULTS
#########################################################################################################

os.chdir(results)

for filename in os.listdir("./"):

	# RETRIVE VALUES FROM IPG, OQS AND NFs
	fp = open(filename, "r")
	for i, line in enumerate(fp):
		if i == 0:
			index = line.find("=")
			ipg_packets_out=int(line[(index+2):len(line)], 0)
		elif i == 1:
			index = line.find("=")
			oqs_packets_in=int(line[(index+2):len(line)], 0)
		elif i == 2:
			index = line.find("=")
			oqs_packets_out=int(line[(index+2):len(line)], 0)
		elif i == 3:
			index = line.find("=")
			oqs_stored_nf0=int(line[(index+2):len(line)], 0)
		elif i == 4:
			index = line.find("=")
			oqs_removed_nf0=int(line[(index+2):len(line)], 0)
		elif i == 5:
			index = line.find("=")
			oqs_dropped_nf0=int(line[(index+2):len(line)], 0)
		elif i == 6:
			index = line.find("=")
			oqs_queued_nf0=int(line[(index+2):len(line)], 0)
		elif i == 7:
			index = line.find("=")
			oqs_stored_nf1=int(line[(index+2):len(line)], 0)
		elif i == 8:
			index = line.find("=")
			oqs_removed_nf1=int(line[(index+2):len(line)], 0)
		elif i == 9:
			index = line.find("=")
			oqs_dropped_nf1=int(line[(index+2):len(line)], 0)
		elif i == 10:
			index = line.find("=")
			oqs_queued_nf1=int(line[(index+2):len(line)], 0)
		elif i == 11:
			index = line.find("=")
			oqs_stored_nf2=int(line[(index+2):len(line)], 0)
		elif i == 12:
			index = line.find("=")
			oqs_removed_nf2=int(line[(index+2):len(line)], 0)
		elif i == 13:
			index = line.find("=")
			oqs_dropped_nf2=int(line[(index+2):len(line)], 0)
		elif i == 14:
			index = line.find("=")
			oqs_queued_nf2=int(line[(index+2):len(line)], 0)
		elif i == 15:
			index = line.find("=")
			oqs_stored_nf3=int(line[(index+2):len(line)], 0)
		elif i == 16:
			index = line.find("=")
			oqs_removed_nf3=int(line[(index+2):len(line)], 0)
		elif i == 17:
			index = line.find("=")
			oqs_dropped_nf3=int(line[(index+2):len(line)], 0)
		elif i == 18:
			index = line.find("=")
			oqs_queued_nf3=int(line[(index+2):len(line)], 0)
		elif i == 19:
			index = line.find("=")
			oqs_stored_dma=int(line[(index+2):len(line)], 0)
		elif i == 20:
			index = line.find("=")
			oqs_removed_dma=int(line[(index+2):len(line)], 0)
		elif i == 21:
			index = line.find("=")
			oqs_dropped_dma=int(line[(index+2):len(line)], 0)
		elif i == 22:
			index = line.find("=")
			oqs_queued_dma=int(line[(index+2):len(line)], 0)
		elif i == 23:
			index = line.find("=")
			nf0_packets_in=int(line[(index+2):len(line)], 0)
		elif i == 24:
			index = line.find("=")
			nf0_packets_out=int(line[(index+2):len(line)], 0)
		elif i == 25:
			index = line.find("=")
			nf1_packets_in=int(line[(index+2):len(line)], 0)
		elif i == 26:
			index = line.find("=")
			nf1_packets_out=int(line[(index+2):len(line)], 0)
		elif i == 27:
			index = line.find("=")
			nf2_packets_in=int(line[(index+2):len(line)], 0)
		elif i == 28:
			index = line.find("=")
			nf2_packets_out=int(line[(index+2):len(line)], 0)
		elif i == 29:
			index = line.find("=")
			nf3_packets_in=int(line[(index+2):len(line)], 0)
		elif i == 30:
			index = line.find("=")
			nf3_packets_out=int(line[(index+2):len(line)], 0)
		else:
			pass
	fp.close()

	# RETRIVE VALUES FROM IPG, OQS AND NFs
	fp = open(filename, "r")
	for i, line in enumerate(fp):
		if i == 31:
			pass # separator
		elif i == 32:
			index = line.find("=")
			ver_packet_counter=int(line[(index+2):len(line)], 0)
		elif i == 33:
			index = line.find("=")
			ver_reg00=int(line[(index+2):len(line)], 0)
		elif i == 34:
			index = line.find("=")
			ver_reg01=int(line[(index+2):len(line)], 0)
		elif i == 35:
			index = line.find("=")
			ver_reg02=int(line[(index+2):len(line)], 0)
		elif i == 36:
			index = line.find("=")
			ver_reg03=int(line[(index+2):len(line)], 0)
		elif i == 37:
			index = line.find("=")
			ver_reg04=int(line[(index+2):len(line)], 0)
		elif i == 38:
			index = line.find("=")
			ver_reg05=int(line[(index+2):len(line)], 0)
		elif i == 39:
			index = line.find("=")
			ver_reg06=int(line[(index+2):len(line)], 0)
		elif i == 40:
			index = line.find("=")
			ver_reg07=int(line[(index+2):len(line)], 0)
		elif i == 41:
			index = line.find("=")
			ver_reg08=int(line[(index+2):len(line)], 0)
		elif i == 42:
			index = line.find("=")
			ver_reg09=int(line[(index+2):len(line)], 0)
		elif i == 43:
			index = line.find("=")
			ver_reg10=int(line[(index+2):len(line)], 0)
		elif i == 44:
			index = line.find("=")
			ver_reg11=int(line[(index+2):len(line)], 0)
		elif i == 45:
			index = line.find("=")
			ver_reg12=int(line[(index+2):len(line)], 0)
		elif i == 46:
			index = line.find("=")
			ver_reg13=int(line[(index+2):len(line)], 0)
		elif i == 47:
			index = line.find("=")
			ver_reg14=int(line[(index+2):len(line)], 0)
		elif i == 48:
			index = line.find("=")
			ver_reg15=int(line[(index+2):len(line)], 0)
		else:
			pass
	fp.close()

# **************************************************************************************
# ****					CHECK ASSERTIONS
# **************************************************************************************

	os.chdir(results)
	chkfile = (filename[0:(len(filename)-7)] + "CHK.txt")
	file = open(chkfile, "w")

	# ASSERTION 1
	if (oqs_packets_out == 1):
		pass
	else:
		file.write("ASSERTION 1 NOT MET !!!\n")

    # ASSERTION 2
	if (True):
		pass
	else:
		file.write("ASSERTION 2 NOT MET !!!\n")

    # ASSERTION 3
	if (True):
		pass
	else:
		file.write("ASSERTION 3 NOT MET !!!\n")

    # ASSERTION 4
	if (True):
		pass
	else:
		file.write("ASSERTION 4 NOT MET !!!\n")

    # ASSERTION 5
	if (True):
		pass
	else:
		file.write("ASSERTION 5 NOT MET !!!\n")

	file.close()

    # CHECK IF FILE IS EMPTY
	os.chdir(results)

	if(os.stat(chkfile).st_size == 0):
		file = open(chkfile, "w")
		file.write("#########################################\n")
		file.write("###           TEST PASSED !!!         ###\n")
		file.write("#########################################\n")
		file.close()
		print(" ")
		print(chkfile)
		print("TEST PASSED !!!")
		print(" ")
	else:
		print(" ")
		print(chkfile)
		print("TEST FAILED !!!")
		print(" ")

print("")
print("***************************************************************************************")
print("*******************         RESULTS CHECKED !!!            ****************************")
print("***************************************************************************************")
