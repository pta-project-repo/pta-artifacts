#!/usr/bin/python

import os
import sys
import subprocess
import time
import re

tools = os.environ['TOOLS']
FNULL = open(os.devnull, 'w')
rwaxi = os.environ['RWAXI']

#########################################################################################################
### 					SUPPORTED FUNCTIONS
#########################################################################################################

# PROGRAM SWITCH
def progsw():
	print("PROGRAMMING THE SWITCH...\n")
	os.chdir(tools)
	subprocess.call(["./progsume.sh", "-d", "0"], stdout=FNULL)
	subprocess.call(["sleep", "15"])
	subprocess.call(["./progtabs.sh"], stdout=FNULL)
	subprocess.call(["sleep", "3"])

# CLEAR DBG COUNTER
def clrcnt():
	subprocess.call(["sh", tools+"/"+"clear_dbg_ext.sh"], stdout=FNULL)
	subprocess.call(["sleep", "1"])
	print("COUNTER CLEARED\n")

# CLEAR DEBUG REGISTERS
def clrregs(za,fa,sa,ta):
	os.chdir(tools)
	subprocess.call(["sh", "clearregs.sh"], stdout=FNULL)
	subprocess.call(["sh", "checkoutver.sh", str(za), str(fa), str(sa), str(ta)], stdout=FNULL)
	subprocess.call(["sh", "checkoutver.sh", str(za), str(fa), str(sa), str(ta)], stdout=FNULL)
	print("DEBUG REGISTERS CLEARED\n")

# SLEEP
def slp(secs):
	print("SLEEPING..." + str(secs) + "\n")				
	subprocess.call(["sleep", str(secs)])

# COLLECT RESULTS
def colres(tsp, res, za,fa,sa,ta):
	os.chdir(res)
	output = open(str(tsp)+"_"+"RAW.txt", "w")
	subprocess.call(["sh", tools+"/"+"checkoutver.sh", str(za), str(fa), str(sa), str(ta)], stdout=output)
	output.close()
	subprocess.call(["sleep", "3"])
	print("RESULTS COLLECTED\n")

# GENERATE PACKETS
def genpkts(brst, flg, gp, psz, hsz, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15):
	pktsize = psz
	gap = gp
	burst = brst
	os.chdir(tools)
	subprocess.call(["./genpkts.sh", "-b", str(brst), "-f", str(flg), "-g", str(gp), "-p", str(psz), "-s", str(hsz), "--m1", str(m1), "--m2", str(m2), "--m3", str(m3), "--m4", str(m4), "--m5", str(m5), "--m6", str(m6), "--m7", str(m7), "--m8", str(m8), "--m9", str(m9), "--m10", str(m10), "--m11", str(m11), "--m12", str(m12), "--m13", str(m13), "--m14", str(m14), "--m15", str(m15)], stdout=FNULL)
	print("------>  " + str(brst) + "  PACKET(s) GENERATED\n")

# PARSE & CHECK RESULTS
def parscheck(res, aslst):
	prslst = []
	os.chdir(res)
	for filename in os.listdir("./"):
		# RETRIVE VALUES FROM IPG, OQS AND NFs
		fp = open(filename, "r")
		for i, line in enumerate(fp):
			if i == 0:
				index = line.find("=")
				prslst.append(("ipg_packets_out", int(line[(index+2):len(line)], 0)))
			elif i == 1:
				index = line.find("=")
				prslst.append(("oqs_packets_in", int(line[(index+2):len(line)], 0)))
			elif i == 2:
				index = line.find("=")
				prslst.append(("oqs_packets_out", int(line[(index+2):len(line)], 0)))
			elif i == 3:
				index = line.find("=")
				prslst.append(("oqs_stored_nf0", int(line[(index+2):len(line)], 0)))
			elif i == 4:
				index = line.find("=")
				prslst.append(("oqs_removed_nf0", int(line[(index+2):len(line)], 0)))
			elif i == 5:
				index = line.find("=")
				prslst.append(("oqs_dropped_nf0", int(line[(index+2):len(line)], 0)))
			elif i == 6:
				index = line.find("=")
				prslst.append(("oqs_queued_nf0", int(line[(index+2):len(line)], 0)))
			elif i == 7:
				index = line.find("=")
				prslst.append(("oqs_stored_nf1", int(line[(index+2):len(line)], 0)))
			elif i == 8:
				index = line.find("=")
				prslst.append(("oqs_removed_nf1", int(line[(index+2):len(line)], 0)))
			elif i == 9:
				index = line.find("=")
				prslst.append(("oqs_dropped_nf1", int(line[(index+2):len(line)], 0)))
			elif i == 10:
				index = line.find("=")
				prslst.append(("oqs_queued_nf1", int(line[(index+2):len(line)], 0)))
			elif i == 11:
				index = line.find("=")
				prslst.append(("oqs_stored_nf2", int(line[(index+2):len(line)], 0)))
			elif i == 12:
				index = line.find("=")
				prslst.append(("oqs_removed_nf2", int(line[(index+2):len(line)], 0)))
			elif i == 13:
				index = line.find("=")
				prslst.append(("oqs_dropped_nf2", int(line[(index+2):len(line)], 0)))
			elif i == 14:
				index = line.find("=")
				prslst.append(("oqs_queued_nf2", int(line[(index+2):len(line)], 0)))
			elif i == 15:
				index = line.find("=")
				prslst.append(("oqs_stored_nf3", int(line[(index+2):len(line)], 0)))
			elif i == 16:
				index = line.find("=")
				prslst.append(("oqs_removed_nf3", int(line[(index+2):len(line)], 0)))
			elif i == 17:
				index = line.find("=")
				prslst.append(("oqs_dropped_nf3", int(line[(index+2):len(line)], 0)))
			elif i == 18:
				index = line.find("=")
				prslst.append(("oqs_queued_nf3", int(line[(index+2):len(line)], 0)))
			elif i == 19:
				index = line.find("=")
				prslst.append(("oqs_stored_dma", int(line[(index+2):len(line)], 0)))
			elif i == 20:
				index = line.find("=")
				prslst.append(("oqs_removed_dma", int(line[(index+2):len(line)], 0)))
			elif i == 21:
				index = line.find("=")
				prslst.append(("oqs_dropped_dma", int(line[(index+2):len(line)], 0)))
			elif i == 22:
				index = line.find("=")
				prslst.append(("oqs_queued_dma", int(line[(index+2):len(line)], 0)))
			elif i == 23:
				index = line.find("=")
				prslst.append(("nf0_packets_in", int(line[(index+2):len(line)], 0)))
			elif i == 24:
				index = line.find("=")
				prslst.append(("nf0_packets_out", int(line[(index+2):len(line)], 0)))
			elif i == 25:
				index = line.find("=")
				prslst.append(("nf1_packets_in", int(line[(index+2):len(line)], 0)))
			elif i == 26:
				index = line.find("=")
				prslst.append(("nf1_packets_out", int(line[(index+2):len(line)], 0)))
			elif i == 27:
				index = line.find("=")
				prslst.append(("nf2_packets_in", int(line[(index+2):len(line)], 0)))
			elif i == 28:
				index = line.find("=")
				prslst.append(("nf2_packets_out", int(line[(index+2):len(line)], 0)))
			elif i == 29:
				index = line.find("=")
				prslst.append(("nf3_packets_in", int(line[(index+2):len(line)], 0)))
			elif i == 30:
				index = line.find("=")
				prslst.append(("nf3_packets_out", int(line[(index+2):len(line)], 0)))
			else:
				pass
		fp.close()
		# RETRIVE VALUES FROM VERIFIER
		fp = open(filename, "r")
		for i, line in enumerate(fp):
			# SEPARATOR
			if i == 31:
				pass
			#  ZERO
			elif i == 32:
				index = line.find("=")
				prslst.append(("zero_reg00", int(line[(index+2):len(line)], 0)))
			# FIRST
			elif i == 33:
				index = line.find("=")
				prslst.append(("first_reg00", int(line[(index+2):len(line)], 0)))
			elif i == 34:
				index = line.find("=")
				prslst.append(("first_reg01", int(line[(index+2):len(line)], 0)))
			elif i == 35:
				index = line.find("=")
				prslst.append(("first_reg02", int(line[(index+2):len(line)], 0)))
			elif i == 36:
				index = line.find("=")
				prslst.append(("first_reg03", int(line[(index+2):len(line)], 0)))
			elif i == 37:
				index = line.find("=")
				prslst.append(("first_reg04", int(line[(index+2):len(line)], 0)))
			elif i == 38:
				index = line.find("=")
				prslst.append(("first_reg05", int(line[(index+2):len(line)], 0)))
			elif i == 39:
				index = line.find("=")
				prslst.append(("first_reg06", int(line[(index+2):len(line)], 0)))
			elif i == 40:
				index = line.find("=")
				prslst.append(("first_reg07", int(line[(index+2):len(line)], 0)))
			elif i == 41:
				index = line.find("=")
				prslst.append(("first_reg08", int(line[(index+2):len(line)], 0)))
			elif i == 42:
				index = line.find("=")
				prslst.append(("first_reg09", int(line[(index+2):len(line)], 0)))
			elif i == 43:
				index = line.find("=")
				prslst.append(("first_reg0A", int(line[(index+2):len(line)], 0)))
			elif i == 44:
				index = line.find("=")
				prslst.append(("first_reg0B", int(line[(index+2):len(line)], 0)))
			elif i == 45:
				index = line.find("=")
				prslst.append(("first_reg0C", int(line[(index+2):len(line)], 0)))
			elif i == 46:
				index = line.find("=")
				prslst.append(("first_reg0D", int(line[(index+2):len(line)], 0)))
			elif i == 47:
				index = line.find("=")
				prslst.append(("first_reg0E", int(line[(index+2):len(line)], 0)))
			elif i == 48:
				index = line.find("=")
				prslst.append(("first_reg0F", int(line[(index+2):len(line)], 0)))
			# SECOND
			elif i == 49:
				index = line.find("=")
				prslst.append(("second_reg00", int(line[(index+2):len(line)], 0)))

			elif i == 50:
				index = line.find("=")
				prslst.append(("second_reg01", int(line[(index+2):len(line)], 0)))

			elif i == 51:
				index = line.find("=")
				prslst.append(("second_reg02", int(line[(index+2):len(line)], 0)))

			elif i == 52:
				index = line.find("=")
				prslst.append(("second_reg03", int(line[(index+2):len(line)], 0)))

			elif i == 53:
				index = line.find("=")
				prslst.append(("second_reg04", int(line[(index+2):len(line)], 0)))

			elif i == 54:
				index = line.find("=")
				prslst.append(("second_reg05", int(line[(index+2):len(line)], 0)))

			elif i == 55:
				index = line.find("=")
				prslst.append(("second_reg06", int(line[(index+2):len(line)], 0)))

			elif i == 56:
				index = line.find("=")
				prslst.append(("second_reg07", int(line[(index+2):len(line)], 0)))

			elif i == 57:
				index = line.find("=")
				prslst.append(("second_reg08", int(line[(index+2):len(line)], 0)))

			elif i == 58:
				index = line.find("=")
				prslst.append(("second_reg09", int(line[(index+2):len(line)], 0)))

			elif i == 59:
				index = line.find("=")
				prslst.append(("second_reg0A", int(line[(index+2):len(line)], 0)))

			elif i == 60:
				index = line.find("=")
				prslst.append(("second_reg0B", int(line[(index+2):len(line)], 0)))

			elif i == 61:
				index = line.find("=")
				prslst.append(("second_reg0C", int(line[(index+2):len(line)], 0)))

			elif i == 62:
				index = line.find("=")
				prslst.append(("second_reg0D", int(line[(index+2):len(line)], 0)))

			elif i == 63:
				index = line.find("=")
				prslst.append(("second_reg0E", int(line[(index+2):len(line)], 0)))

			elif i == 64:
				index = line.find("=")
				prslst.append(("second_reg0F", int(line[(index+2):len(line)], 0)))

			# THIRD
			elif i == 65:
				index = line.find("=")
				prslst.append(("third_reg00", int(line[(index+2):len(line)], 0)))
			elif i == 66:
				index = line.find("=")
				prslst.append(("third_reg01", int(line[(index+2):len(line)], 0)))
			elif i == 67:
				index = line.find("=")
				prslst.append(("third_reg02", int(line[(index+2):len(line)], 0)))
			elif i == 68:
				index = line.find("=")
				prslst.append(("third_reg03", int(line[(index+2):len(line)], 0)))
			elif i == 69:
				index = line.find("=")
				prslst.append(("third_reg04", int(line[(index+2):len(line)], 0)))
			elif i == 70:
				index = line.find("=")
				prslst.append(("third_reg05", int(line[(index+2):len(line)], 0)))
			elif i == 71:
				index = line.find("=")
				prslst.append(("third_reg06", int(line[(index+2):len(line)], 0)))
			elif i == 72:
				index = line.find("=")
				prslst.append(("third_reg07", int(line[(index+2):len(line)], 0)))
			elif i == 73:
				index = line.find("=")
				prslst.append(("third_reg08", int(line[(index+2):len(line)], 0)))
			elif i == 74:
				index = line.find("=")
				prslst.append(("third_reg09", int(line[(index+2):len(line)], 0)))
			elif i == 75:
				index = line.find("=")
				prslst.append(("third_reg0A", int(line[(index+2):len(line)], 0)))
			elif i == 76:
				index = line.find("=")
				prslst.append(("third_reg0B", int(line[(index+2):len(line)], 0)))
			elif i == 77:
				index = line.find("=")
				prslst.append(("third_reg0C", int(line[(index+2):len(line)], 0)))
			elif i == 78:
				index = line.find("=")
				prslst.append(("third_reg0D", int(line[(index+2):len(line)], 0)))
			elif i == 79:
				index = line.find("=")
				prslst.append(("third_reg0E", int(line[(index+2):len(line)], 0)))
			elif i == 80:
				index = line.find("=")
				prslst.append(("third_reg0F", int(line[(index+2):len(line)], 0)))
			# SKIP OTHER LINES
			else:
				pass
		fp.close()

		# CHECK RESULTS
		chkfile = (filename[0:(len(filename)-7)] + "CHK.txt")
		file = open(chkfile, "w")

		# SIZE OF THE TWO LISTS
		# prssz = len(prslst)
		# assz = len(aslst)

		# TRAVERS PARSER LIST
		for prselem in prslst:

			# TRAVERSE ASSERTIONS LIST
			for aselem in aslst:

				# FOUND MATCHING FIELD
				if(prselem[0] == aselem[0]):

					# ASSERTION WITH STRING + INTEGER
					if (not(isinstance(aselem[2], basestring))):

						# OPERATION IS SUPPORTED						
						if (aselem[1] == "EQ"):
							if (prselem[1] == aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")								
						elif (aselem[1] == "NE"):
							if (prselem[1] != aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")		
						elif (aselem[1] == "GT"):
							if (prselem[1] > aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")		
						elif (aselem[1] == "GE"):
							if (prselem[1] >= aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")		
						elif (aselem[1] == "LT"):
							if (prselem[1] < aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")		
						elif (aselem[1] == "LE"):
							if (prselem[1] <= aselem[2]):
								pass
							else:
								file.write(str(aselem) + "\n")		
						# OPERATION IS NOT SUPPORTED
						else:
							print("ERROR: STRING + INTEGER OPERATION IS NOT SUPPORTED")
							exit(1)

					# ASSERTION WITH STRING + STRING
					else:

						# TRAVERSE PARSER LIST AGAIN
						for prseleml in prslst:

							# FOUND MATCHING FIELD
							if(prseleml[0] == aselem[2]):

								# EXTRACT VALUE
								value = prseleml[1]

								# OPERATION IS SUPPORTED						
								if (aselem[1] == "EQ"):
									if (prselem[1] == value):
										pass
									else:
										file.write(str(aselem) + "\n")								
								elif (aselem[1] == "NE"):
									if (prselem[1] != value):
										pass
									else:
										file.write(str(aselem) + "\n")		
								elif (aselem[1] == "GT"):
									if (prselem[1] > value):
										pass
									else:
										file.write(str(aselem) + "\n")		
								elif (aselem[1] == "GE"):
									if (prselem[1] >= value):
										pass
									else:
										file.write(str(aselem) + "\n")		
								elif (aselem[1] == "LT"):
									if (prselem[1] < value):
										pass
									else:
										file.write(str(aselem) + "\n")		
								elif (aselem[1] == "LE"):
									if (prselem[1] <= value):
										pass
									else:
										file.write(str(aselem) + "\n")		
								# OPERATION IS NOT SUPPORTED
								else:
									print("ERROR: STRING + STRING OPERATION IS NOT SUPPORTED")
									exit(1)

				# NOT FOUND MATCHING FIELDS
				else:
					pass

		file.close()

		# CHECK IF FILE IS EMPTY
		os.chdir(res)
		if(os.stat(chkfile).st_size == 0):
			file = open(chkfile, "w")
			file.write("#########################################\n")
			file.write("###           TEST PASSED !!!         ###\n")
			file.write("#########################################\n")
			file.close()
			print(" ")
			print("PASSED: " + str(chkfile))
			print(" ")
		else:
			print(" ")
			print("FAILED: " + str(chkfile))
			print(" ")
