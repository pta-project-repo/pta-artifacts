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
This script creates the files used for the interactive CLI
"""

import argparse, sys, re, os, json
from collections import OrderedDict
import libcam_templates
import libtcam_templates
import liblpm_templates

LIBCAM_FILE = 'libcam.c'
LIBTCAM_FILE = 'libtcam.c'
LIBLPM_FILE = 'liblpm.c'
CLI_FILE = "P4_SWITCH_CLI.py"
TABLE_API_FILE = 'p4_tables_api.py'
REG_API_FILE = 'p4_regs_api.py'

TABLE_INFO_DICT = {
"EM": r"""    CAM_Init\((?P<tableID>[\d]*),(?P<clk_period>[\d]*),(?P<key_width>[\d]*),(?P<value_width>[\d]*),(?P<max_depth>[\d]*),(?P<aging_width>[\d]*)\);
    CAM_EnableDevice\(\d*\);
    update_(?P<table_name>.*)_from_file\("{0}.tbl"\);""",

"TCAM": r"""    TCAM_Init\((?P<tableID>[\d]*),(?P<key_width>[\d]*),(?P<value_width>[\d]*),(?P<max_depth>[\d]*),(?P<num_ranges>[\d]*),(?P<range_width>[\d]*),(?P<range_offset>[\d]*)\);
    TCAM_Clean\(\d*\);
    update_(?P<table_name>.*)_from_file\("{0}.tbl"\);""",

"LPM": r"""    LPM_Init\((?P<tableID>[\d]*),(?P<key_width>[\d]*),(?P<value_width>[\d]*),(?P<max_depth>[\d]*),(?P<shadow_mem>[\d]*)\);
    LPM_LoadDataset\(\d*,"(?P<table_name>.*).dat"\);
    LPM_VerifyDataset\(\d*,"{0}.dat"\);"""
}



CLI_dir = "CLI"

def write_libcam(sw_dir, tables_dict, base_address):
    with open(os.path.join(sw_dir, CLI_dir, LIBCAM_FILE), 'w+') as f:
        f.write(libcam_templates.INCLUDES.format(base_address))
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.GLOBALS_TEMPLATE.format(table_info))
        f.write(libcam_templates.HELPER_FUNCS)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.INIT_FUNC_TEMPLATE.format(table_info))
        f.write(libcam_templates.TABLE_READ_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.TABLE_READ_TEMPLATE.format(table_info))
        f.write(libcam_templates.TABLE_READ_END)
        f.write(libcam_templates.TABLE_ADD_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.TABLE_ADD_TEMPLATE.format(table_info))
        f.write(libcam_templates.FUNC_END)
        f.write(libcam_templates.TABLE_DELETE_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.TABLE_DELETE_TEMPLATE.format(table_info))
        f.write(libcam_templates.FUNC_END)
        f.write(libcam_templates.TABLE_SIZE_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libcam_templates.TABLE_SIZE_TEMPLATE.format(table_info))
        f.write(libcam_templates.FUNC_END)
        f.write(libcam_templates.TABLE_ERROR_DECODE)

def write_libtcam(sw_dir, tables_dict, base_address):
    with open(os.path.join(sw_dir, CLI_dir, LIBTCAM_FILE), 'w+') as f:
        f.write(libtcam_templates.INCLUDES.format(base_address))
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.GLOBALS_TEMPLATE.format(table_info))
        f.write(libtcam_templates.HELPER_FUNCS)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.INIT_FUNC_TEMPLATE.format(table_info))
        f.write(libtcam_templates.TABLE_CLEAN_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.TABLE_CLEAN_TEMPLATE.format(table_info))
        f.write(libtcam_templates.FUNC_END)
        f.write(libtcam_templates.TABLE_ADDR_SIZE)
        f.write(libtcam_templates.TABLE_SET_LOG_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.TABLE_SET_LOG_TEMPLATE.format(table_info))
        f.write(libtcam_templates.FUNC_END)
        f.write(libtcam_templates.TABLE_WRITE_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.TABLE_WRITE_TEMPLATE.format(table_info))
        f.write(libtcam_templates.FUNC_END)
        f.write(libtcam_templates.TABLE_ERASE_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.TABLE_ERASE_TEMPLATE.format(table_info))
        f.write(libtcam_templates.FUNC_END)
        f.write(libtcam_templates.TABLE_VERIFY_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(libtcam_templates.TABLE_VERIFY_TEMPLATE.format(table_info))
        f.write(libtcam_templates.FUNC_END)
        f.write(libtcam_templates.TABLE_ERROR_DECODE)

def write_liblpm(sw_dir, tables_dict, base_address):
    with open(os.path.join(sw_dir, CLI_dir, LIBLPM_FILE), 'w+') as f:
        f.write(liblpm_templates.INCLUDES.format(base_address))
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.GLOBALS_TEMPLATE.format(table_info))
        f.write(liblpm_templates.HELPER_FUNCS)
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.INIT_FUNC_TEMPLATE.format(table_info))
        f.write(liblpm_templates.TABLE_ADDR_SIZE)
        f.write(liblpm_templates.TABLE_SET_LOG_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.TABLE_SET_LOG_TEMPLATE.format(table_info))
        f.write(liblpm_templates.FUNC_END)
        f.write(liblpm_templates.TABLE_LOAD_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.TABLE_LOAD_TEMPLATE.format(table_info))
        f.write(liblpm_templates.FUNC_END)
        f.write(liblpm_templates.TABLE_VERIFY_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.TABLE_VERIFY_TEMPLATE.format(table_info))
        f.write(liblpm_templates.FUNC_END)
        f.write(liblpm_templates.TABLE_SET_BANK_START)
        for table_name, table_info in tables_dict.iteritems():
            f.write(liblpm_templates.TABLE_SET_BANK_TEMPLATE.format(table_info))
        f.write(liblpm_templates.FUNC_END)
        f.write(liblpm_templates.TABLE_ERROR_DECODE)


"""
Extract the table info from the SDNet testbench file
"""
def get_table_info(P4_SWITCH_dir, table_name, P4_SWITCH, table_info_fmat):
    with open(os.path.join(P4_SWITCH_dir, 'Testbench/{0}_tb.sv'.format(P4_SWITCH))) as f:
        file_contents = f.read()
        pattern = table_info_fmat.format(table_name)
        searchObj = re.search(pattern, file_contents)
    if (searchObj is None):
        print >> sys.stderr, "ERROR: could not find table_info for {}".format(table_name)
        sys.exit(1)
    table_info = searchObj.groupdict()
   
    # get base address 
    with open(os.path.join(P4_SWITCH_dir, P4_SWITCH + '.h')) as f:
        fmat = r"#define  {}__{}__START_ADDRESS   (\S*)".format(P4_SWITCH, table_name)
        contents = f.read()
        searchObj = re.search(fmat, contents)
    if searchObj is None:
        print >> sys.stderr, "ERROR: could not find start address for table {}".format(table_name)
        sys.exit(1)
    table_info['base_address'] = searchObj.group(1)
    return table_info

"""
Create dictionary of table information:
tables = {
    "EM" : {"table_1" : {...table_info...}, "table_2" : {...table_info...} },
    "TCAM" : {"table_3" : {...table_info...}},
    "LPM" : {"table_4" : {...table_info...}}
}
"""
def find_tables(switch_info_file, P4_SWITCH_dir, P4_SWITCH):
    tables = {"EM":{},  "TCAM":{}, "LPM":{}}
    with open(switch_info_file) as f:
        switch_info = json.load(f)
    lookup_engines = []
    for block, block_dict in switch_info.items():
        if 'px_lookups' in block_dict.keys():
            lookup_engines += block_dict['px_lookups']
    name_type = [(t['px_name'], t['match_type']) for t in lookup_engines]
    for table_name, table_type in name_type:
        tables[table_type][table_name] = get_table_info(P4_SWITCH_dir, table_name, P4_SWITCH, TABLE_INFO_DICT[table_type])
    return tables

"""
Write the table_defines json file
"""
def write_table_defines(tables, P4_SWITCH, cli_dir):
    outfile = os.path.join(cli_dir, '{}_table_defines.json'.format(P4_SWITCH))
    with open(outfile, 'w') as f:
        json.dump(tables, f)

"""
Builds the necessary table libraries 
"""
def make_table_libs(tables, P4_SWITCH_dir, sw_dir, base_address, P4_SWITCH, cli_dir):
    for table_type, tables_dict in tables.iteritems():
        if (table_type == "EM" and len(tables_dict) > 0):
            write_libcam(sw_dir, tables_dict, base_address)
            rc = os.system("make libcam -C {0}".format(cli_dir))
            if rc != 0:
                print >> sys.stderr, "ERROR: could not compile libcam souce files"
                sys.exit(1)
        elif (table_type == "TCAM" and len(tables_dict) > 0):
            write_libtcam(sw_dir, tables_dict, base_address)
            rc = os.system("make libtcam -C {0}".format(cli_dir))
            if rc != 0:
                print >> sys.stderr, "ERROR: could not compile libtcam souce files"
                sys.exit(1)
        elif (table_type == "LPM" and len(tables_dict) > 0):
            write_liblpm(sw_dir, tables_dict, base_address)
            rc = os.system("make liblpm -C {0}".format(cli_dir))
            if rc != 0:
                print >> sys.stderr, "ERROR: could not compile liblpm souce files"
                sys.exit(1)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('switch_info', type=str, help="the switch info file")
    parser.add_argument('P4_SWITCH_dir', type=str, help="the P4_SWITCH directory")
    parser.add_argument('sw_dir', type=str, help="the project's software directory")
    parser.add_argument('templates_dir', type=str, help="the templates directory")
    parser.add_argument('--base_address', type=str, default="0x44020000", help="the base address of the P4_SWITCH")
    args = parser.parse_args()

    P4_SWITCH = os.path.basename(os.path.normpath(args.P4_SWITCH_dir))

    # create the CLI files
    cli_dir = os.path.join(args.sw_dir, CLI_dir)
    if not os.path.exists(cli_dir):
        os.makedirs(cli_dir)

    #rc = os.system("cp {0} {1}".format(os.path.join(args.templates_dir, "CLI_template/*"), cli_dir))
    rc = os.system("cp {0} {1}".format(os.path.join(args.templates_dir, "*"), cli_dir))   
    if rc != 0:
        print >> sys.stderr, "ERROR: could not copy over CLI_template directory"
        sys.exit(1)

    tables = find_tables(args.switch_info, args.P4_SWITCH_dir, P4_SWITCH)
    write_table_defines(tables, P4_SWITCH, cli_dir)
    make_table_libs(tables, args.P4_SWITCH_dir, args.sw_dir, args.base_address, P4_SWITCH, cli_dir)

if __name__ == "__main__":
    main()

