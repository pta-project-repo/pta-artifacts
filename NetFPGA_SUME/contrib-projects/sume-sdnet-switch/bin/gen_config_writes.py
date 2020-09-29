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


import argparse, sys, re, collections, os

sim_config = 'config_writes.py'
hw_config = 'config_writes.sh' 

"""
Parse the config_writes.txt file created from running the P4_SWITCH
SDNet testbench (P4_SWITCH_testbench.sv). And remove the writes to
the initialization registers (ending with 20).
"""
def parse_config_writes(filename):
    regex = r"<addr, data>: \(([abcdefABCDEF\d]*), ([abcdefABCDEF\d]*)\)"
    dic = collections.OrderedDict()
    i = 0
    with open(filename) as f:
        for line in f:
            searchObj = re.match(regex, line)
            if searchObj is not None:
                dic[i] = (searchObj.group(1), searchObj.group(2))
            else:
                print >> sys.stderr, "ERROR: encountered unexpected line in file: \n", line
                sys.exit(1)
            i += 1
    return dic

def remove_init_addresses(dic):
    result = collections.OrderedDict()
    for (index, tup) in dic.iteritems():
        if tup[0][-2:] != "20":
            result[index] =  tup
    return result

def write_sim_config(dic, baseaddr, outdir):
    with open(outdir + '/'  + sim_config , "w") as f:
        f.write("""
from NFTest import *

NUM_WRITES = {0}

def config_tables():
""".format(len(dic)))
        for (address, val) in dic.values():
            global_addr = int(address, 16) + baseaddr
            f.write("    nftest_regwrite(0x{0:08x}, 0x{1})\n".format(global_addr, val))

def write_hw_config(dic, baseaddr, outdir):
    with open(outdir + '/'  + hw_config , "w") as f:
        f.write("""#!/bin/bash

""")
        SUME_FOLDER = os.environ.get("SUME_FOLDER") 
        for (address, val) in dic.values():
            global_addr = int(address, 16) + baseaddr
            f.write("${{SUME_SDNET}}/sw/sume/rwaxi -a 0x{0:08x} -w 0x{1}\n".format(global_addr, val))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', type=str, help="the config_writes.txt file")
    parser.add_argument('baseaddr', type=str, help="the base address of the P4_SWITCH")
    parser.add_argument('outdir', type=str, help="the name of the output directory")
    args = parser.parse_args()

    dic = parse_config_writes(args.filename)
    new_dic = remove_init_addresses(dic)
    write_sim_config(new_dic, int(args.baseaddr, 0), args.outdir)
    write_hw_config(new_dic, int(args.baseaddr, 0), args.outdir)

if __name__ == "__main__":
    main()
