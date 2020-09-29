#!/usr/bin/env python
#
# Copyright (c) 2017 University of Cambridge
# Copyright (c) 2017 Gianni Antichi
# Copyright (c) 2017 Jong Hun Han
# All rights reserved.
#
# This software was developed by University of Cambridge Computer Laboratory
# under the ENDEAVOUR project (grant agreement 644960) as part of
# the European Union's Horizon 2020 research and innovation programme.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#

import sys, getopt
import os
from random import randint

try:
    import scapy.all as scapy
except:
    try:
        import scapy as scapy
    except:
        sys.exit("Error: Need to install scapy for packet handling")


############################
# Function: make_MAC_hdr
# Keyword Arguments: src_MAC, dst_MAC, EtherType
# Description: creates and returns a scapy Ether layer
#              if keyword arguments are not specified, scapy defaults are used
############################
def make_MAC_hdr(src_MAC = None, dst_MAC = None, EtherType = None, **kwargs):
	hdr = scapy.Ether()
    	if src_MAC:
        	hdr.src = src_MAC
    	if dst_MAC:
        	hdr.dst = dst_MAC
    	if EtherType:
        	hdr.type = EtherType
    	return hdr

############################
# Function: make_IP_hdr
# Keyword Arguments: src_IP, dst_IP, TTL
# Description: creates and returns a scapy IP layer
#              if keyword arguments are not specified, scapy defaults are used
############################
def make_IP_hdr(src_IP = None, dst_IP = None, TTL = None, **kwargs):
    	hdr = scapy.IP()
    	if src_IP:
        	hdr[scapy.IP].src = src_IP
    	if dst_IP:
        	hdr[scapy.IP].dst = dst_IP
    	if TTL:
        	hdr[scapy.IP].ttl = TTL
	return hdr

############################
# Function: make_UDP_hdr
# Keyword Arguments: sport, dport
# Description: creates and returns a scapy UDP layer
#              if keyword arguments are not specified, scapy defaults are used
############################
def make_UDP_hdr(l4source = None, l4dst = None, **kwargs):
        hdr = scapy.UDP()
        if l4source:
                hdr[scapy.UDP].sport = l4source
        if l4dst:
                hdr[scapy.UDP].dport = l4dst
        return hdr

############################
# Function: make_IP_pkt
# Keyword Arguments: src_MAC, dst_MAC, EtherType
#                    src_IP, dst_IP, TTL
#                    pkt_len
# Description: creates and returns a complete IP packet of length pkt_len
############################
def make_IP_pkt(pkt_len = 60, **kwargs):
    	if pkt_len < 60:
        	pkt_len = 60
    	pkt = make_MAC_hdr(**kwargs)/make_IP_hdr(**kwargs)/generate_load(pkt_len - 34)
	return pkt

############################
# Function: make_UDP_pkt
# Keyword Arguments: src_MAC, dst_MAC, EtherType
#                    src_IP, dst_IP, TTL, l4source, l4dst
#                    pkt_len
# Description: creates and returns a complete UDP packet of length pkt_len
############################
def make_UDP_pkt(pkt_len = 60, **kwargs):
        if pkt_len < 60:
                pkt_len = 60
        pkt = make_MAC_hdr(**kwargs)/make_IP_hdr(**kwargs)/make_UDP_hdr(**kwargs)/generate_load(pkt_len - 42)
        return pkt

############################
# Function: generate_load
# Keyword Arguments: length
# Description: creates and returns a payload of the specified length
############################
def generate_load(length):
    	load = ''
    	for i in range(length):
        	load += chr(randint(0,255))
	return load

def usage():
	print 'pcap_gen.py -o <outputfile> -n <number of packets> -l <packet length> -s <source MAC> -d <destination MAC>'


def main(argv):
	outputfile = ''
	pkts_num = 1
	pktlen = 60
	found_option = False
	default_sMAC = True
	default_dMAC = True
        default_sIP  = True
        default_dIP  = True
       	try:
		opts, args = getopt.getopt(sys.argv[1:], "ho:n:l:s:d:r:t", ["help", "output=", "npkts=", "length=", "srcMAC=", "dstMAC=", "srcIP=", "dstIP="])
	except getopt.GetoptError, err:
		print str(err)
		usage()
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'pcap_gen.py -o <outputfile>'
			sys.exit()		
		elif opt in ("-o", "--output"):
			found_option = True
                       	outputfile = arg
		elif opt in ("-n", "--npkts"):
			pkts_num = int(arg)
		elif opt in ("-l", "--length"):
                        pktlen = int(arg)
		elif opt in ("-s", "--srcMAC"):
                        sMAC = arg
			default_sMAC = False
		elif opt in ("-d", "--dstMAC"):
                        dMAC = arg
			default_dMAC = False	
		elif opt in ("-r", "--srcIP"):
                        sIP = arg
			default_sIP = False	
		elif opt in ("-t", "--dstIP"):
                        dIP = arg
			default_dIP = False	
	if not found_option:
		print 'wrong options'
		usage()
		sys.exit(2)
	
	print 'Output file is ', outputfile


       	# Packet parameters
	if default_sMAC:
       		sMAC = "aa:bb:cc:dd:ee:ff"
	if default_dMAC:
       		dMAC = "de:ad:be:ef:f0:01"
        if default_sIP:
                sIP = "192.168.0.1"
        if default_dIP:
       	        dIP = "192.168.1.1"

	l4s = 120
	l4d = 121

       	pkts_queue = []

       	for i in range(pkts_num):
        	pkt = make_UDP_pkt(dst_MAC=dMAC, src_MAC=sMAC, src_IP=sIP, dst_IP=dIP, l4source=l4s, l4dst=l4d, pkt_len=pktlen)
               	pkt.time = (i*(1e-6))
               	pkts_queue.append(pkt)

       	scapy.wrpcap(outputfile, pkts_queue)


if __name__ == "__main__":
   main(sys.argv[1:])


