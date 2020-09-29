#!/usr/bin/python

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
