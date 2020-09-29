#!/usr/bin/env python

#
# Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
#                          Junior University
# Copyright (C) 2015 David J. Miller
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
################################################################################
#
#  File:
#        nf10_sim_reconcile_axi_logs.py
#
#  Description:
#         Reconciles *_log.axi with *_expected.axi.
#

from __future__ import with_statement

import axitools
import glob
import os
import sys
import argparse
from collections import OrderedDict

from scapy.all import hexdump

# temporary addition:
sys.path.append(os.path.expandvars('$P4_PROJECT_DIR/testdata/'))
try:
    from int_headers import *
except:
    pass
#

def reconcile_pkts( log_pkts, exp_pkts ):
    """
    Reconcile list of logged AXI packets with list of expected packets.
    """ 
    num_log_pkts = len(log_pkts)
    num_exp_pkts = len(exp_pkts)

    i = 0
    for exp_pkt, log_pkt in zip(exp_pkts, log_pkts):
        if (exp_pkt != log_pkt):
            diff_pkts(exp_pkt, log_pkt, i)
        i += 1

    if num_log_pkts > num_exp_pkts:
        print "Logged {0} more packet(s) than were expected".format(num_log_pkts - num_exp_pkts)
        print "First unepected packet is: \n", log_pkts[num_exp_pkts].show()
    elif num_log_pkts < num_exp_pkts: 
        print "Expected {0} more packet(s) than were logged".format(num_exp_pkts - num_log_pkts)
        print "First missing packet is: \n", log_pkts[num_log_pkts].show()

def diff_pkts(exp_pkt, log_pkt, i):
    if (exp_pkt == log_pkt):
        print "Packets are identical ... "
        return
    exp_layers = get_pkt_layers(exp_pkt)
    log_layers = get_pkt_layers(log_pkt)
    for exp_layer, log_layer in zip(exp_layers, log_layers):
        try:
            assert(exp_layer == log_layer)
        except:
            print "ERROR: expected pkt has layer {0}, logged pkt has layer {1}".format(exp_layer.name, log_layer.name)
            return
        layer = exp_layer
        field_names = [field.name for field in layer.fields_desc] 
        for field_name in field_names:
            exp_field = getattr(exp_pkt[layer], str(field_name))
            log_field = getattr(log_pkt[layer], str(field_name))
            if exp_field != log_field:
                print "Discrepancy found in packet {0}, layer {1}, field {2}".format(i, layer.name, field.name)
                print "Expected_Packet[{0}].{1} = {2}".format(layer.name, field.name, exp_field)
                print "Logged_Packet[{0}].{1} = {2}".format(layer.name, field.name, log_field)
                return

def get_pkt_layers(pkt):
    layers = []
    counter = 0
    while True:
        layer = pkt.getlayer(counter)
        if (layer != None):
            layers.append(type(layer))
        else:
            break
        counter += 1
    return layers

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--log', required=True, type=str, help="the path to the log_axi_file")
    parser.add_argument('--expect', required=True, type=str, help="the path to the expected_axi_file")
    parser.add_argument('-w', action='store_true', default=False, help="write the logged and expected pkts")
    args = parser.parse_args()

    with open(args.log) as f:
        log_pkts = axitools.axis_load( f, 1e-9 )
    with open(args.expect) as f:
        exp_pkts = axitools.axis_load( f, 1e-9 ) 

    if (args.w):
        #wrpcap('logged_pkts.pcap', log_pkts)
        #wrpcap('expected_pkts.pcap', exp_pkts)
        i = 1
        for pkt in exp_pkts:
            print "expected pkt {0}".format(i)
            pkt.show()
            print "---------------------------"
            i += 1
        i = 1
        for pkt in log_pkts:
            print "log pkt {0}".format(i)
            pkt.show()
            print "---------------------------"           


    reconcile_pkts(log_pkts, exp_pkts)

if __name__ == '__main__':
    main()
