#!/usr/bin/python
##
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

import sys

# Store the size of the payload
paysize = int(sys.argv[1])

# Compute quotient & modulus
quotient = paysize // 32

modulus = paysize % 32

# Compute tkeep_dec
if modulus == 0:
	tkeep_dec = 32
else:
	tkeep_dec = modulus

# Convert tkeep_dec to one-hot representation
string = ''

for x in range(1, 33):
	if tkeep_dec >= x:
		string = '1' + string
	else:
	    string = '0' + string

tkeep = int(string, 2)

# Compute cycles
if modulus == 0:
	cycles = quotient
else:
	cycles = (quotient + 1)

# Generate sizeinfo
sizeinfo = (cycles<<16)+paysize

# Debug
# print "PAYSIZE = ",paysize
# print "CYCLES = ",cycles
# print "TKEEP = ",tkeep_dec
# print "STRING = ",string
# print ">>> TKEEP = ",tkeep
# print ">>> SIZEINFO = ",sizeinfo

# write the results to files
with open('tkeep.txt', 'w') as f:
  f.write('%d' % tkeep)

with open('sizeinfo.txt', 'w') as f:
  f.write('%d' % sizeinfo)
