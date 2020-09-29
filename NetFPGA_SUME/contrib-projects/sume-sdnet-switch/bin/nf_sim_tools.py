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


from scapy.all import *

nf_port_map = {'nf0':0b00000001, 'nf1':0b00000100, 'nf2':0b00010000, 'nf3':0b01000000}

"""
pkts : the packets to send
base_time : the simulation time to inject the first packet
rate : the rate in Mbps at which to send the packets
"""
def send_pkts(pkts, base_time, rate, interface):
    i = 0
    for pkt in pkts:
        ipg = (len(pkt)*8.0)/(rate*10**6)
        pkt.time = base_time + ipg*i
        pkt.tuser_sport = nf_port_map[interface]
        i += 1

def pad_pkt(pkt, size):
    if len(pkt) >= size:
        return pkt
    else:
        return pkt / ('\x00'*(size - len(pkt)))
        
