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


import argparse, sys, re, os
from collections import OrderedDict

CONFIG_FILE = "config_tables.c"
CLI_dir = "CLI"
TABLE_DEFINES_CLI = "{0}_table_defines.txt"

INCLUDES = """
/* AUTO GENERATED FILE!! DO NOT MODIFY!!
 *
 * Author: Stephen Ibanez
 */

#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <net/if.h>

#include <err.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "CAM.h"
#include "sume_reg_if.h"
#include "table_update.h"

#define SUME_SDNET_BASE_ADDR          0x44020000

// global context vars
"""

CONTEXT_VAR_TEMPLATE = "CAM_CONTEXT CAM_CONTEXT_{0};\n"

LOG_MESSAGE_FUNC = """
uint32_t log_level=0;

//log message
int log_msg(const char* msg) {
    printf("%s", msg);
    return 0;
}

"""

INIT_FUNC_TEMPLATE = """
void init_{0[table_name]}() {{
    uint32_t tableID = {0[tableID]};
    CAM_CONTEXT* cx = &CAM_CONTEXT_{0[table_name]};
    uint32_t size = CAM_Init_GetAddrSize();
    // TODO: set baseAddr to the base address of the table
    addr_t baseAddr = SUME_SDNET_BASE_ADDR + tableID*size;
    uint32_t max_depth = {0[max_depth]};
    uint32_t key_width = {0[key_width]};
    // TODO: not sure what to use for clk_period
    uint32_t clk_period = {0[clk_period]};
    uint32_t value_width = {0[value_width]};
    uint32_t aging_width = {0[aging_width]};
    void (*register_write)(addr_t addr, uint32_t data);
    uint32_t (*register_read)(addr_t addr);
    // cast the driver functions to the appropriate types
    register_write = (void (*)(addr_t addr, uint32_t data)) &sume_register_write;
    register_read = (uint32_t (*)(addr_t addr)) &sume_register_read;

    // Initialize the CAM_CONTEXT
    if(CAM_Init_ValidateContext(cx,baseAddr,size,max_depth,key_width,clk_period,value_width,aging_width,register_write,register_read, &log_msg, log_level)) {{
        printf("CAM_Init_ValidateContext() - failed\\n");
    }} else {{
        printf("CAM_Init_ValidateContext() - done\\n");
    }}

    // Activate the CAM_CONTEXT
    if(CAM_Init_Activate(cx)) {{
        printf("CAM_Init_Activate() - failed\\n");
    }} else {{
        printf("CAM_Init_Activate() - done\\n");
    }}

    // Configure the table
    if(update_table_from_file(cx, "../src/{0[table_name]}.tbl")) {{
        printf("update_table_from_file() - failed\\n");
    }} else {{
        printf("update_table_from_file() - done\\n");
    }}
}}

"""

MAIN_FUNC_START = """
/*
 * Configure the tables using the SDNet CAM API
 */
int
main(int argc, char *argv[])
{

"""

INIT_FUNC_CALL = "    init_{0}();\n"


table_info_pattern = r"""    CAM_Init\((?P<tableID>[\d]*),(?P<clk_period>[\d]*),(?P<key_width>[\d]*),(?P<value_width>[\d]*),(?P<max_depth>[\d]*),(?P<aging_width>[\d]*)\);
    CAM_EnableDevice\(\d*\);
    update_(?P<table_name>.*)_from_file\("{0}.tbl"\);"""

def write_config_file(outputDir, tables_dict):
    with open(outputDir + '/' + CONFIG_FILE, 'w+') as f:
        f.write(INCLUDES)
        for table_name in tables_dict.keys():
            f.write(CONTEXT_VAR_TEMPLATE.format(table_name))
        f.write(LOG_MESSAGE_FUNC)
        for table_name, table_info in tables_dict.iteritems():
            f.write(INIT_FUNC_TEMPLATE.format(table_info))
        f.write(MAIN_FUNC_START)
        for table_name in tables_dict.keys():
            f.write(INIT_FUNC_CALL.format(table_name))
        f.write('}')

def get_table_info(p4SwitchDir, table_name, P4_SWITCH):
    table_info = OrderedDict()
    with open(os.path.join(p4SwitchDir, 'Testbench/{0}_tb.sv'.format(P4_SWITCH))) as f:
        file_contents = f.read()
        pattern = table_info_pattern.format(table_name)
        searchObj = re.search(pattern, file_contents)
    if (searchObj is not None):
        table_info = searchObj.groupdict()
    else:
        table_info = None
    return table_info 

def get_table_names(p4SwitchDir, P4_SWITCH): 
    tables = []
    with open(os.path.join(p4SwitchDir, P4_SWITCH + '.h')) as f:
        file_contents = f.read()
        pattern = r'{0}__(.*)__START_ADDRESS'.format(P4_SWITCH)
        searchObj = re.search(pattern, file_contents)
        while searchObj is not None:
            table_name = searchObj.group(1)
            tables.append(table_name)
            file_contents = file_contents[:searchObj.start()] + file_contents[searchObj.end():]    
            searchObj = re.search(pattern, file_contents)
    return tables

"""
Write the P4_SWITCH_table_defines.txt file for CLI usage
"""
def write_table_defines(sw_dir, tables_dict, P4_SWITCH):
    contents = """
/* This is an automatically generated file containing the table
 * definitions for the P4_SWITCH. This is to be used as part of the 
 * P4_SWITCH CLI.
 */\n\n"""
    for table_name, table_dict in tables_dict.items():
        table_name = re.sub(r"_\d+", "", table_name)
        contents += "#define {0}_{1}_KEY_WIDTH  ".format(P4_SWITCH, table_name) + table_dict['key_width'] + '\n'
        contents += "#define {0}_{1}_VALUE_WIDTH  ".format(P4_SWITCH, table_name) + table_dict['value_width'] + '\n'
        contents += "#define {0}_{1}_MAX_DEPTH  ".format(P4_SWITCH, table_name) + table_dict['max_depth'] + '\n\n'
        contents += "#define {0}_{1}_TABLEID  ".format(P4_SWITCH, table_name) + table_dict['tableID'] + '\n\n'
    cli_dir = os.path.join(sw_dir, CLI_dir)
    if not os.path.exists(cli_dir):
        os.makedirs(cli_dir)
    with open(os.path.join(cli_dir, TABLE_DEFINES_CLI.format(P4_SWITCH)), 'w') as f:
        f.write(contents)    


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('p4SwitchDir', type=str, help="the P4_SWITCH directory")
    parser.add_argument('sw_dir', type=str, help="the project's software directory")
    args = parser.parse_args()

    P4_SWITCH = os.path.basename(os.path.normpath(args.p4SwitchDir))

    tables = get_table_names(args.p4SwitchDir, P4_SWITCH)
    tables_dict = OrderedDict()
    for table in tables:
        table_info = get_table_info(args.p4SwitchDir, table, P4_SWITCH)
        if (table_info is not None):
            tables_dict[table] = table_info 
 
    write_config_file(args.sw_dir, tables_dict)
    write_table_defines(args.sw_dir, tables_dict, P4_SWITCH)

if __name__ == "__main__":
    main()


