#!/usr/bin/env python

#
# Copyright (c) 2017 Stephen Ibanez
# All rights reserved.
#
# This software was developed by Stanford University and the University of Cambridge Computer Laboratory 
# under National Science Foundation under Grant No. CNS-0855268,
# the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
# by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), 
# as part of the DARPA MRC research programme.
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


import sys, os
# sys.path.append(os.path.expandvars('$P4_PROJECT_DIR/ppl_testdata/'))
from sss_digest_header import *

sys.path.append(os.path.expandvars('$P4_PROJECT_DIR/ppl_sw/CLI/'))
from p4_tables_api import *

"""
This is the learning switch software that adds the appropriate
entries to the forwarding and smac tables 
"""

DMA_IFACE = 'nf0'
DIG_PKT_LEN = 10 # 10 bytes, 80 bits

forward_tbl = {}
smac_tbl = {}

def learn_digest(pkt):
    dig_pkt = Digest_data(str(pkt))
    if len(dig_pkt) != DIG_PKT_LEN:
        return
    print "Received Digest packet: "
    print "\tsrc_port = ", bin(dig_pkt.src_port)
    print "\teth_src_addr = ", hex(dig_pkt.eth_src_addr)
    print "prn pkt = ",
    hexdump(dig_pkt)
    print "###################################"
    add_to_tables(dig_pkt)

def add_to_tables(dig_pkt):
    src_port = dig_pkt.src_port
    eth_src_addr = dig_pkt.eth_src_addr
    (found, val) = table_cam_read_entry('forward', [eth_src_addr])
    if (found == 'False'):
        print 'Adding entry: ({0}, set_output_port, {1}) to the forward table'.format(hex(eth_src_addr), bin(src_port))
        table_cam_add_entry('forward', [eth_src_addr], 'set_output_port', [src_port])
        print 'Adding entry: ({0}, NoAction, []) to the smac table'.format(hex(eth_src_addr))
        table_cam_add_entry('smac', [eth_src_addr], 'NoAction', [])
        print "***************************************************************\n"
    else:
        print "Entry: ({0}, set_output_port, {1}) is already in the tables".format(hex(eth_src_addr), bin(src_port))

def main():
    sniff(iface=DMA_IFACE, prn=learn_digest, count=0)

if __name__ == "__main__":
    main()
