import os
import sys
import subprocess
import time
import re
import test_mod

# CREATE DIRECTORY FOR COLLECTING TEST RESULTS
results = os.getcwd()+"/"+"test_res"
os.makedirs(results)

# NUMBER OF PACKETS
num = "1000000000"

# PACKET SIZE
size = "128"

# INTER-PACKET GAP
gap_list = [ "50", "40", "30", "10", "5", "3", "2", "1", "0" ]

#########################################################################################################
### 										USER CODE BEGIN
#########################################################################################################

for gap in gap_list:
	# PROGRAM TARGET
	test_mod.progsw()
	# INITIALIZE COUNTERS
	test_mod.clrcnt()
	# INITIALIZE REGISTERS
	test_mod.clrregs()
	# GENERATE PACKETS
	test_mod.genpkts(num, "I-0", gap, num, "34", "H-11", "H-FF", "H-11", "H-22", "I-0", "I-0", "I-0", "I-0", "I-0", "I-0", "H-1", "I-0", "I-0", "I-0", "I-0")
	# COLLECT RESULTS
	test_mod.colres(results)

#########################################################################################################
### 										USER CODE END
#########################################################################################################

as_list = [

#########################################################################################################
### 										USER CODE BEGIN
#########################################################################################################

("input_arbiter_packets_out", "EQ", num),
("output_queues_packets_in", "EQ", num),
("output_queues_packets_out", "EQ", num)

#########################################################################################################
### 										USER CODE END
#########################################################################################################

] # as_list

# PARSE & CHECK RESULTS
test_mod.parscheck(results, as_list)
