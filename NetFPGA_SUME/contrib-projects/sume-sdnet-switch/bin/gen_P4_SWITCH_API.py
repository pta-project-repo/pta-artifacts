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


"""
This script copies the SDNet generated table API source files
into the $P4_PROJECT_DIR/sw/API folder. It also creates a header
file that defines the registers within the P4_SWITCH that are 
addressable.

It additionally creates a starter file that demonstrates how to 
use some of the API functions.
"""

import argparse, sys, re, os, json
from collections import OrderedDict

# STARTER_FILE = 'starter.c'
# 
# INCLUDES = """
# /* AUTO GENERATED FILE!! DO NOT MODIFY!!
#  *
#  * Author: Stephen Ibanez
#  *
#  * This file is meant to provide starter code for using the
#  * generated API functions.
#  */
# 
# #include <sys/ioctl.h>
# #include <sys/types.h>
# #include <sys/stat.h>
# 
# #include <net/if.h>
# 
# #include <err.h>
# #include <fcntl.h>
# #include <limits.h>
# #include <stdio.h>
# #include <stdint.h>
# #include <stdlib.h>
# #include <string.h>
# #include <unistd.h>
# 
# #include "CAM.h"
# #include "{0}_regs.h"
# #include "sume_reg_if.h"
# 
# #define SUME_SDNET_BASE_ADDR          {1}
# 
# // global context vars
# """
# 
# CONTEXT_VAR_TEMPLATE = "CAM_CONTEXT CAM_CONTEXT_{0};\n"
# 
# LOG_MESSAGE_FUNC = """
# uint32_t log_level=0;
# 
# //log message
# int log_msg(const char* msg) {
#     printf("%s", msg);
#     return 0;
# }
# 
# """
# 
# INIT_FUNC_TEMPLATE = """
# void init_{0[table_name]}() {{
#     uint32_t tableID = {0[tableID]};
#     CAM_CONTEXT* cx = &CAM_CONTEXT_{0[table_name]};
#     uint32_t size = CAM_Init_GetAddrSize();
#     // TODO: set baseAddr to the base address of the table
#     addr_t baseAddr = SUME_SDNET_BASE_ADDR + tableID*size;
#     uint32_t max_depth = {0[max_depth]};
#     uint32_t key_width = {0[key_width]};
#     // TODO: not sure what to use for clk_period
#     uint32_t clk_period = {0[clk_period]};
#     uint32_t value_width = {0[value_width]};
#     uint32_t aging_width = {0[aging_width]};
#     void (*register_write)(addr_t addr, uint32_t data);
#     uint32_t (*register_read)(addr_t addr);
#     // cast the driver functions to the appropriate types
#     register_write = (void (*)(addr_t addr, uint32_t data)) &sume_register_write;
#     register_read = (uint32_t (*)(addr_t addr)) &sume_register_read;
# 
#     // Initialize the CAM_CONTEXT
#     if(CAM_Init_ValidateContext(cx,baseAddr,size,max_depth,key_width,clk_period,value_width,aging_width,register_write,register_read, &log_msg, log_level)) {{
#         printf("CAM_Init_ValidateContext() - failed\\n");
#     }} else {{
#         printf("CAM_Init_ValidateContext() - done\\n");
#     }}
# 
# }}
# 
# """
# 
# MAIN_FUNC_START = """
# /*
#  * Configure the tables using the SDNet CAM API
#  */
# int
# main(int argc, char *argv[])
# {
# 
# """
# 
# INIT_FUNC_CALL = "    init_{0}();\n"
# 
# 
# table_info_pattern = r"""    CAM_Init\((?P<tableID>[\d]*),(?P<clk_period>[\d]*),(?P<key_width>[\d]*),(?P<value_width>[\d]*),(?P<max_depth>[\d]*),(?P<aging_width>[\d]*)\);
#     CAM_EnableDevice\(\d*\);
#     update_(?P<table_name>.*)_from_file\("{0}.tbl"\);"""

API_dir = "API"
CLI_dir = "CLI"

# def write_starter_file(sw_dir, tables_dict, base_address, P4_SWITCH):
#     with open(os.path.join(sw_dir, API_dir, STARTER_FILE), 'w+') as f:
#         f.write(INCLUDES.format(P4_SWITCH, base_address))
#         for table_name in tables_dict.keys():
#             f.write(CONTEXT_VAR_TEMPLATE.format(table_name))
#         f.write(LOG_MESSAGE_FUNC)
#         for table_name, table_info in tables_dict.iteritems():
#             f.write(INIT_FUNC_TEMPLATE.format(table_info))
#         f.write(MAIN_FUNC_START)
#         for table_name in tables_dict.keys():
#             f.write(INIT_FUNC_CALL.format(table_name))
#         f.write("""
#     /* now use the CAM.h functions with the global CAM_CONTEXT variables:
#      *   CAM_Mgt_ReadEntry(&CAM_CONTEXT_TABLE_NAME, &key, &value, &flag);
#      * And use sume_register_read() / sume_register_write() to access the registers
#      */
# }""")
# 
# def get_table_info(P4_SWITCH_dir, table_name, P4_SWITCH):
#     table_info = OrderedDict()
#     with open(os.path.join(P4_SWITCH_dir, 'Testbench/{0}_tb.sv'.format(P4_SWITCH))) as f:
#         file_contents = f.read()
#         pattern = table_info_pattern.format(table_name)
#         searchObj = re.search(pattern, file_contents)
#     if (searchObj is not None):
#         table_info = searchObj.groupdict()
#     else:
#         table_info = None
#     return table_info 
# 
# def get_table_names(P4_SWITCH_dir, P4_SWITCH): 
#     tables = []
#     with open(os.path.join(P4_SWITCH_dir, P4_SWITCH + '.h')) as f:
#         file_contents = f.read()
#         pattern = r'{0}__(.*)__START_ADDRESS'.format(P4_SWITCH)
#         searchObj = re.search(pattern, file_contents)
#         while searchObj is not None:
#             table_name = searchObj.group(1)
#             tables.append(table_name)
#             file_contents = file_contents[:searchObj.start()] + file_contents[searchObj.end():]    
#             searchObj = re.search(pattern, file_contents)
#     return tables
# 
# def copy_CAM_files(P4_SWITCH_dir, api_dir):
#     rc = os.system("cp {0} {1}".format(os.path.join(P4_SWITCH_dir, "Testbench/CAM*"), api_dir))
#     return rc
# 
# """
# Creates a starter file that demonstrates how to use some of the API functions
# """
# def make_starter_file(P4_SWITCH_dir, sw_dir, base_address, P4_SWITCH):
#     tables = get_table_names(P4_SWITCH_dir, P4_SWITCH)
#     tables_dict = OrderedDict()
#     for table in tables:
#         table_info = get_table_info(P4_SWITCH_dir, table, P4_SWITCH)
#         if (table_info is not None):
#             tables_dict[table] = table_info
#     write_starter_file(sw_dir, tables_dict, base_address, P4_SWITCH)

def find_table_types(switch_info_file):
    with open(switch_info_file) as f:
        switch_info = json.load(f)
    lookup_engines = []
    for block, block_dict in switch_info.items():
        if 'px_lookups' in block_dict.keys():
            lookup_engines += block_dict['px_lookups']
    table_types = list(set([t['match_type'] for t in lookup_engines]))
    return table_types

def copy_API_files(table_types, P4_SWITCH_dir, api_dir):
    type_map = {"EM":"CAM", "TCAM":"TCAM", "LPM":"LPM"}
    for table_type in table_types:
        rc = os.system("cp {0} {1}".format(os.path.join(P4_SWITCH_dir, "Testbench/{}*".format(type_map[table_type])), api_dir)) 
        if rc != 0:
            print >> sys.stderr, "ERROR: could not copy API files for table type: {}".format(table_type)
            sys.exit(1)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('switch_info_file', type=str, help="the switch info file")
    parser.add_argument('P4_SWITCH_dir', type=str, help="the P4_SWITCH directory")
    parser.add_argument('sw_dir', type=str, help="the project's software directory")
    parser.add_argument('templates_dir', type=str, help="the templates directory")
    parser.add_argument('--base_address', type=str, default="0x44020000", help="the base address of the P4_SWITCH")
    args = parser.parse_args()

    P4_SWITCH = os.path.basename(os.path.normpath(args.P4_SWITCH_dir))

    # create the API files
    api_dir = os.path.join(args.sw_dir, API_dir)
    if not os.path.exists(api_dir):
        os.makedirs(api_dir)

    table_types = find_table_types(args.switch_info_file)
    copy_API_files(table_types, args.P4_SWITCH_dir, api_dir)

#    rc = copy_CAM_files(args.P4_SWITCH_dir, api_dir)
#    if rc == 0:
#        make_starter_file(args.P4_SWITCH_dir, args.sw_dir, args.base_address, P4_SWITCH) 
#        rc = os.system("cp {0} {1}".format(os.path.join(args.templates_dir, "starter_API_Makefile"), os.path.join(api_dir, "Makefile"))) 
#        if rc != 0:
#            print >> sys.stderr, "ERROR: could not copy Makefile into API directory"
#            sys.exit(1)

if __name__ == "__main__":
    main()


