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


import argparse

oldTask = """$display("SV_write_control()- start");
axi4_lite_master_write_request_control(addr,data);
$display("SV_write_control()- done");"""

newTask = """int file;
file = $fopen("config_writes.txt", "a");
$display("SV_write_control()- start");
$fwrite(file, "<addr, data>: (%h, %h)\\n", addr, data);
axi4_lite_master_write_request_control(addr,data);
$display("SV_write_control()- done");
$fclose(file);"""

parser = argparse.ArgumentParser(description="""replace the SV_write_control Task in the P4_SWITCH_tb module so that
it writes the table configuration writes to a table""")

parser.add_argument('testbench_file', type=str,
                    help="P4_SWITCH_Tb.sv file to modify")

args = parser.parse_args()

with open(args.testbench_file, "r+") as f:
    tb = f.read()
    tb = tb.replace(oldTask, newTask)
    f.seek(0)
    f.write("")
    f.write(tb)
    

