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


import sys, os, argparse, re

ADDR_WIDTH = 1

def make_UserEngines_addressable(SDNet_src_file):
    contents = open(SDNet_src_file).read()
    obj = re.search(r"UserEngine\(([\d ]*),[ 0]\)", contents)
    if obj is not None:
        newContents = contents.replace(obj.group(0), "UserEngine({0},{1})".format(obj.group(1), ADDR_WIDTH))
        with open(SDNet_src_file,'w') as f:
            f.write(newContents)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('SDNet_src_file', type=str, help="the SDNet source file that contains the UserEngines to modify")
    args = parser.parse_args()

    make_UserEngines_addressable(args.SDNet_src_file)
    

if __name__ == "__main__":
    main()



