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


import argparse, sys, re

def parse_config_writes(filename):
    regex = r"<addr, data>: \(([\d]*), ([\d]*)\)"
    dic = {}
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

def replace_init_addresses(dic):
    for (index, tup) in dic.iteritems():
        if tup[0][-2:] == "20":
            new_address = "000000f0"
            dic[index] =  (new_address, tup[1])
    return dic

def write_new_file(dic, outdir):
    f = open(outdir + '/config_writes.v', 'w')
    for (index, tup) in dic.iteritems():
        f.write("addr[" + str(index) + "] = 32'h" + tup[0] + ";\n")
    f.write("\n\n")
    for (index, tup) in dic.iteritems():
        f.write("data[" + str(index) + "] = 32'h" + tup[1] + ";\n")
    f.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', type=str, help="the config_writes.txt file")
    parser.add_argument('outdir', type=str, help="the output directory")
    args = parser.parse_args()

    dic = parse_config_writes(args.filename)
    new_dic = replace_init_addresses(dic)
    write_new_file(new_dic, args.outdir) 

if __name__ == "__main__":
    main()

