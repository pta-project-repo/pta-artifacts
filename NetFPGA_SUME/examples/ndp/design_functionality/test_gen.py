# !/usr/bin/python
#
# Copyright (c) 2019 Pietro Bressana,
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
tools = os.environ['TOOLS']
sys.path.append(str(tools))
import test_mod

start = time.time()

FNULL = open(os.devnull, 'w')

# COLLECT TIMESTAMP
localtime = time.localtime(time.time())
timestamp = str(localtime.tm_year) + "-" + str(localtime.tm_mon) + "-" + str(localtime.tm_mday) + "_" + str(localtime.tm_hour) + "-" + str(localtime.tm_min)

rwaxi = os.environ['RWAXI']

# INTERFACES
NF0 = "B-00000001"
NF1 = "B-00000100"
NF2 = "B-00010000"
NF3 = "B-01000000"
DMA = "B-00000010"
BRD = "B-01010101"
AZR = "B-00000000"
ONE = "B-11111111"

# CHECKOUTVER
ZA=10
FA=30
SA=40
TA=0

# TEMP VARIABLES
pktsize = 0
gap = 0
burst = 0

# CREATE DIRECTORY FOR COLLECTING TEST RESULTS
results = os.getcwd()+"/"+"res_"+timestamp
os.makedirs(results)

print("")
print("***************************************************************************************")
print("*******************       GENERATING TEST PACKETS...       ****************************")
print("***************************************************************************************")
print("")

#########################################################################################################
### 										USER CODE BEGIN
#########################################################################################################

test_mod.progsw()

# training
test_mod.genpkts("1", "I-0", "D-100", "128", "34", "H-11", "H-FF", "H-11", "H-22", "I-0", "I-0", "I-0", "I-0", "I-0", "I-0", "H-1", "I-0", "I-0", "I-0", "I-0")
test_mod.genpkts("1", "I-0", "D-100", "128", "34", "H-22", "H-FF", "H-22", "H-11", "I-0", "I-0", "I-0", "I-0", "I-0", "I-0", "H-4", "I-0", "I-0", "I-0", "I-0")
 
test_mod.clrcnt()

test_mod.clrregs(ZA,FA,SA,TA)

# full window
test_mod.genpkts("1000", "XY", "D-100", "128", "54", "H-11", "H-22", "H-11", "H-22", "H-88", "H-EF", "H-11", "H-22", "H-0", "H-0", "H-1", "H-0", "H-0", "H-0", "H-0")

### 
   #BST   FLG     GAP     PSZ   HSZ    m01      m02 	   m03 	 m04 	   m05 	   m06 	   m07   m08     m09     m10    m11      m12      m13     m14      m15
# [ "1000", "XY", "D-100", "128", "54", "H-22", "H-11", "H-22", "H-11",  "H-48",  "H-FE", "H-22", "H-11", "H-0", "H-0",  "H-4",  "H-0",   "H-0",  "H-0",  "H-0"],

test_mod.colres(timestamp, results, ZA,FA,SA,TA)

#########################################################################################################
### 										USER CODE END
#########################################################################################################

# ASSERTIONS: AVAILABLE VARIABLES

# ipg_packets_out
# oqs_packets_in/out
# oqs_stored_nf0/nf1/nf2/nf3/dma
# oqs_removed_nf0/nf1/nf2/nf3/dma
# oqs_dropped_nf0/nf1/nf2/nf3/dma
# oqs_queued_nf0/nf1/nf2/nf3/dma
# nf0_packets_in/nf1/nf2/nf3
# nf0_packets_out/nf1/nf2/nf3
# zero_reg00
# first_reg00/reg0F
# second_reg00/reg0F
# third_reg00/reg0F

# ASSERTIONS: AVAILABLE OPERATIONS

# EQ: equal
# NE: not equal
# GT: greater than
# GE: greater than or equal
# LT: lower than
# LE: lower than or equal

# # ASSERTIONS: USAGE
# (<VAR>,    <OP>,     <VAR/NUMB>)
# (<string>, <string>, <string/int>)

as_list = [

#########################################################################################################
### 										USER CODE BEGIN
#########################################################################################################

("ipg_packets_out", "EQ", 0),
("nf0_packets_out", "EQ", "nf0_packets_out"),
("nf0_packets_out", "EQ", "nf1_packets_out")

#########################################################################################################
### 										USER CODE END
#########################################################################################################

] # as_list

print("")
print("***************************************************************************************")
print("*******************    PARSING & CHECKING RESULTS...       ****************************")
print("***************************************************************************************")
print("")

# PARSE & CHECK RESULTS
test_mod.parscheck(results, as_list)

# COMPUTE EXECUTION TIME
end = time.time()
print("")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print("EXECUTION TIME: " + str(end - start) + "[s]")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

print("")
print("***************************************************************************************")
print("*******************           TEST COMPLETE !!!            ****************************")
print("***************************************************************************************")
print("")
