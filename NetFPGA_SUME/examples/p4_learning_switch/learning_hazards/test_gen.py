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

import os
import sys
import subprocess
import time
import re

# COLLECT TIMESTAMP
localtime = time.localtime(time.time())
timestamp = str(localtime.tm_year) + "-" + str(localtime.tm_mon) + "-" + str(localtime.tm_mday) + "_" + str(localtime.tm_hour) + "-" + str(localtime.tm_min)

cps = os.environ['CONTROL_PLANE']+"/"+"p4_learning_switch"
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
pktsizelist = [64, 65, 96, 97, 128, 129, 160, 161, 192, 193, 224, 225, 256, 257, 384, 385, 512, 513, 768, 769, 1024, 1025, 1514]
#pktsizelist = [128]

# GAP SIZES
#gapsizelist = [50, 40, 30, 10, 5, 3, 2, 1, 0]
gapsizelist = [0]

# BURST SIZES
burstsizelist = [2]

# METADATA COLUMNS
metacollist = [0]

### METADATA TRAINING [0-numrowtr][0-15]:
numrowtr=16

metatr =[
	
# FLG	 m01 	 m02 	 m03 	 m04 	 m05 	 m06 	 m07   m08  m09   m10     m11     m12     m13     m14     m15
[ "S", "I-0", "H-BB", "H-BB", "H-BB", "H-BB", "H-BB", "H-BB", NF1, NF0, "H-AA", "H-AA", "H-AA", "H-AA", "H-AA", "H-AA"],

] # metatr

### METADATA TEST [0-numrowts][0-15]:
numrowts=16

metats =[
	
# FLG	 m01 	 m02 	 m03 	 m04 	 m05 	 m06 	 m07   m08  m09   m10     m11     m12     m13     m14     m15
["I-0", "I-0", "H-AA", "H-AA", "H-AA", "H-AA", "H-AA", "H-AA", AZR, NF3, "H-BB", "H-BB", "H-BB", "H-BB", "H-BB", "H-BB"],

] # metats

#########################################################################################################
### 					GENERATE TEST PACKETS
#########################################################################################################

# CREATE RESULTS FOLDER
os.makedirs(results)

for pktsize in pktsizelist:

	for burst in burstsizelist:

		for gap in gapsizelist:

			gpgap = "P-" + str(gap)
		
			# PROGRAM SWITCH
			os.chdir(tools)
			subprocess.call(["./progsume.sh", "-d", "0"])
			subprocess.call(["sleep", "15"])
			subprocess.call(["./progtabs.sh"])	
			# RUN CONTROL PLANE SCRIPT
			os.chdir(cps)
			FNULL = open(os.devnull, 'w')
			DUMP = open("dump_control_plane_script.txt", 'w')
			subprocess.Popen(["./learn.py"], stdout=DUMP)
			# SLEEP
			os.chdir(tools)			
			subprocess.call(["sleep", "3"])

			for metacol in range(1):

				os.chdir(tools)

				# TRAINING
				subprocess.call(["./genpkts.sh", "-b", str(burst), "-f", metatr[metacol][0], "-g", str(gpgap), "-p", str(pktsize), "-s", str(hdr), "--m1", metatr[metacol][1], "--m2", metatr[metacol][2], "--m3", metatr[metacol][3], "--m4", metatr[metacol][4], "--m5", metatr[metacol][5], "--m6", metatr[metacol][6], "--m7", metatr[metacol][7], "--m8", metatr[metacol][8], "--m9", metatr[metacol][9], "--m10", metatr[metacol][10], "--m11", metatr[metacol][11], "--m12", metatr[metacol][12], "--m13", metatr[metacol][13], "--m14", metatr[metacol][14], "--m15", metatr[metacol][15]])
			
				# TEST
				# subprocess.call(["./genpkts.sh", "-b", str(burst), "-f", metats[metacol][0], "-g", str(gpgap), "-p", str(pktsize), "-s", str(hdr), "--m1", metats[metacol][1], "--m2", metats[metacol][2], "--m3", metats[metacol][3], "--m4", metats[metacol][4], "--m5", metats[metacol][5], "--m6", metats[metacol][6], "--m7", metats[metacol][7], "--m8", metats[metacol][8], "--m9", metats[metacol][9], "--m10", metats[metacol][10], "--m11", metats[metacol][11], "--m12", metats[metacol][12], "--m13", metats[metacol][13], "--m14", metats[metacol][14], "--m15", metats[metacol][15]])
							
				subprocess.call(["sleep", str(sleeptime)])

				# COLLECT RESULTS
				os.chdir(results)
				output = open(str(pktsize)+"_"+str(gap)+"_"+str(burst)+"_"+str(metacol)+"_"+"RAW.txt", "w")
				subprocess.call(["sh", tools+"/"+"checkoutver.sh"], stdout=output)
				output.close()
				subprocess.call(["sleep", "3"])

			# # KILL CONTROL PLANE SCRIPT
			# subprocess.call(["kill", "pidof", "python", "./learn.py"], stdout=FNULL)
			FNULL.close()
			DUMP.close()

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
	if (ver_packet_counter != 2):
		file.write("ASSERTION 1 NOT MET !!!\n")
	else:
		pass

    # ASSERTION 2
	if (ver_reg06 != 1):
		file.write("ASSERTION 2 NOT MET !!!\n")
	else:
		pass

    # ASSERTION 3
	if (ver_reg00 != 1):
		file.write("ASSERTION 3 NOT MET !!!\n")
	else:
		pass

    # ASSERTION 4
	if (False):
		file.write("ASSERTION 4 NOT MET !!!\n")
	else:
		pass

    # ASSERTION 5
	if (False):
		file.write("ASSERTION 5 NOT MET !!!\n")
	else:
		pass

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
