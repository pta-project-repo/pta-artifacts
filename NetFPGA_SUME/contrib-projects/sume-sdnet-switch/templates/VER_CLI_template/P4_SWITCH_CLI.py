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


import os, sys, cmd, re
from collections import OrderedDict
from pprint import pprint
import p4_regs_api, p4_tables_api

# defines the table_*_add_entry command 
from p4_px_tables import *

### Global Variables ###
P4_EXTERNS = p4_regs_api.P4_EXTERNS
P4_REGS = OrderedDict() # just the externs with a control interface
for extern_name, extern_dict in P4_EXTERNS.items():
    if 'control_width' in extern_dict.keys() and extern_dict['control_width'] > 0:
        P4_REGS[extern_name] = extern_dict

#p4_tables = p4_tables_api.p4_tables_info
PX_CAM_TABLES = p4_tables_api.PX_CAM_TABLES
PX_TCAM_TABLES = p4_tables_api.PX_TCAM_TABLES
PX_LPM_TABLES = p4_tables_api.PX_LPM_TABLES

class SimpleSumeSwitch(cmd.Cmd):
    """The SimpleSumeSwitch interactive command line tool"""

    prompt = ">> "
    intro = "The SimpleSumeSwitch interactive command line tool\n type help to see all commands"

    ##########################
    ### Register Functions ###
    ##########################
    """
    List the registers defined in the SimpleSumeSwitch
    """
    def do_list_regs(self, line):
        for reg_name, reg_dict in P4_REGS.items():
            print '-'*len(reg_name), '\n', reg_name, ':\n', '-'*len(reg_name)
            pprint(reg_dict)
 
    def help_list_regs(self):
        print """
list_regs
DESCRIPTION: List the registers defined in the SimpleSumeSwitch and their relevant compile time information
"""

    def do_reg_read(self, line):
        fmat = r"(.*)\[(\d*)\]"
        searchObj = re.search(fmat, line)
        if searchObj is not None:
            reg_name = searchObj.group(1)
            index = int(searchObj.group(2))
        else:
            reg_name = line
            index = 0
        result = p4_regs_api.reg_read(reg_name, index)
        print result

    def help_reg_read(self):
        print """
reg_read <REG_NAME>[<INDEX>]
DESCRIPTION: Read the current value of the provided register at the given index
""" 

    def complete_reg_read(self, text, line, begidx, endidx):
        if not text:
            completions = P4_REGS.keys()
        else:
            completions = [ r for r in P4_REGS.keys() if r.startswith(text)]
        return completions

    def do_reg_write(self, line):
        fmat = r"(.*)\[(\d*)\]\s*(\d*)"
        searchObj = re.search(fmat, line)
        if searchObj is not None:
            reg_name = searchObj.group(1)
            index = int(searchObj.group(2))
            val = int(searchObj.group(3))
        else:
            print >> sys.stderr, "ERROR: usage ..."
            self.help_reg_write()
            return 
        result = p4_regs_api.reg_write(reg_name, index, val)
        print result

    def help_reg_write(self):
        print """
writeReg <REG_NAME>[<INDEX>] <VALUE>
DESCRIPTION: Write VALUE to the provided register at the given INDEX
""" 

    def complete_reg_write(self, text, line, begidx, endidx):
        if not text:
            completions = P4_REGS.keys()
        else:
            completions = [ r for r in P4_REGS.keys() if r.startswith(text)]
        return completions

    ###########################
    ### CAM Table Functions ###
    ###########################

    """
    List the CAM tables and some relevant info
    """
    def do_list_cam_tables(self, line):
        for table_name, table in PX_CAM_TABLES.items():
            print '-'*len(table_name), '\n', table_name, ':\n', '-'*len(table_name)
            pprint(table.info)

    def help_list_cam_tables(self):
        print """
list_cam_tables
DESCRIPTION: List the exact match tables defined in the SimpleSumeSwitch and their relevant compile time information
"""

    """
    Read entry from a table
    """
    def do_table_cam_read_entry(self, line):
        args = line.split(' ')
        try:
            assert(len(args) >= 2)
        except:
            print >> sys.stderr, "ERROR: usage ... "
            self.help_table_cam_read_entry()
            return
        table_name = args[0] 
        keys = [int(_,0) for _ in args[1:]]
        (found, val) = p4_tables_api.table_cam_read_entry(table_name, keys)
        print "Entry found: ", found
        print hex(int(val, 16))

    def help_table_cam_read_entry(self):
        print """
table_cam_read_entry <table_name> <keys>
DESCRIPTION: Read the entry in table corresponding to the given list of keys
PARAMS:
    <table_name> : name of the table to read from
    <keys> : space separated list of keys to look for in the table (must correspond to table's keys in the order defined in the P4 program)
"""

    def complete_table_cam_read_entry(self, text, line, begidx, endidx):
        if not text:
            completions = PX_CAM_TABLES.keys()
        else:
            completions = [ t for t in PX_CAM_TABLES.keys() if t.startswith(text)]
        return completions

    """
    Add an entry to a table
    """
    def do_table_cam_add_entry(self, line):
        # defined in p4_px_tables.py
        (table_name, keys, action_name, action_data) = parse_table_cam_add_entry(line)
        p4_tables_api.table_cam_add_entry(table_name, keys, action_name, action_data)

    def help_table_cam_add_entry(self):
        # defined in p4_px_tables.py
        print help_table_cam_add_entry() 

    def complete_table_cam_add_entry(self, text, line, begidx, endidx):
        if not text:
            if len(line.split()) == 1:
                # table names
                completions = PX_CAM_TABLES.keys()
            elif len(line.split()) == 2:
                # actions names
                table_name = line.split()[1]
                if table_name in PX_CAM_TABLES.keys():
                    # the table name is recognized
                    actions = PX_CAM_TABLES[table_name].actions
                    completions = [a['p4_name'] for a in actions] 
            else:
                completions = []
        else:
            if len(line.split()) == 2:
                # trying to complete table name
                completions = [ t for t in PX_CAM_TABLES.keys() if t.startswith(text)]
            elif len(line.split()) == 3:
                # trying to complete action_name
                table_name = line.split()[1]
                if table_name in PX_CAM_TABLES.keys():
                    # the table name is recognized
                    actions = PX_CAM_TABLES[table_name].actions
                    completions = [ a['p4_name'] for a in actions if a['p4_name'].startswith(text)]
            else:
                completions = []
        return completions
 
    """
    Delete an entry from a table
    """
    def do_table_cam_delete_entry(self, line):
        args = line.split(' ')
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_cam_delete_entry()
            return
        table_name = args[0]
        keys = keys = [int(_,0) for _ in args[1:]]
        p4_tables_api.table_cam_delete_entry(table_name, keys)

    def help_table_cam_delete_entry(self):
        print """
table_cam_delete_entry <table_name> <keys>
DESCRIPTION: Delete the entry in the specified table with the given keys
PARAMS:
    <table_name> : name of the table to delete an entry from
    <keys> : space separated list of keys (must correspond to table's keys in the order defined in the P4 program)
"""

    def complete_table_cam_delete_entry(self, text, line, begidx, endidx):
        if not text:
            completions = PX_CAM_TABLES.keys()
        else:
            completions = [ t for t in PX_CAM_TABLES.keys() if t.startswith(text)]
        return completions

    """
    Get the current number of entries in the table
    """
    def do_table_cam_get_size(self, line):
        table_name = line.strip()
        print p4_tables_api.table_cam_get_size(table_name)

    def help_table_cam_get_size(self):
        print """
table_cam_get_size <table_name>
DESCRIPTION: Get the current number of entries in the specified table
"""

    def complete_table_cam_get_size(self, text, line, begidx, endidx):
        if not text:
            completions = PX_CAM_TABLES.keys()
        else:
            completions = [ t for t in p4_tables.keys() if t.startswith(text)]
        return completions

    def do_EOF(self, line):
        return True

    ### -
    """
    Delete all entries from a table
    """
    def do_table_cam_clean_entries(self, line):
        args = line.split(' ')
        table_name = args[0]
        p4_tables_api.table_cam_clean_entries(table_name)

    def help_table_cam_clean_entries(self):
        print """
table_cam_delete_entry <table_name> <keys>
DESCRIPTION: Delete the entry in the specified table with the given keys
PARAMS:
    <table_name> : name of the table to delete an entry from
    <keys> : space separated list of keys (must correspond to table's keys in the order defined in the P4 program)
"""

    ############################
    ### TCAM Table Functions ###
    ############################

    """
    List the TCAM tables and some relevant info
    """
    def do_list_tcam_tables(self, line):
        for table_name, table in PX_TCAM_TABLES.items():
            print '-'*len(table_name), '\n', table_name, ':\n', '-'*len(table_name)
            pprint(table.info)

    def help_list_tcam_tables(self):
        print """
list_tcam_tables
DESCRIPTION: List the ternary match tables defined in the SimpleSumeSwitch and their relevant compile time information
"""

    def do_table_tcam_clean(self, line):
        table_name = line.strip()
        p4_tables_api.table_tcam_clean(table_name) 

    def help_table_tcam_clean(self):
        print """
table_tcam_clean <table_name>
DESCRIPTION: performs table self-initialization, erasing and invalidating all stored rules
"""

    def do_table_tcam_get_addr_size(self, line):
        print p4_tables_api.table_tcam_get_addr_size()

    def help_table_tcam_get_addr_size(self):
        print """
table_tcam_get_addr_size 
DESCRIPTION: returns the TCAM_ADDR_SIZE 
"""

    def do_table_tcam_set_log_level(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_tcam_set_log_level()
            return 
        table_name = args[0]
        try:
            msg_level = int(args[1], 0)
        except:
            print >> sys.stderr, "ERROR: msg_level must be valid int"
            return
        p4_tables_api.table_tcam_set_log_level(table_name, msg_level)

    def help_table_tcam_set_log_level(self):
        print """
table_tcam_set_log_level <table_name> <msg_level>
DESCRIPTION: Update the logging level of the table 
"""

    def do_table_tcam_add_entry(self, line):
        # defined in p4_px_tables.py
        (table_name, address, keys, masks, action_name, action_data) = parse_table_tcam_add_entry(line)
        p4_tables_api.table_tcam_write_entry(table_name, address, keys, masks, action_name, action_data)

    def help_table_tcam_add_entry(self):
        # defined in p4_px_tables.py
        print help_table_tcam_add_entry()
 
    def do_table_tcam_erase_entry(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_tcam_erase_entry()
            return
        table_name = args[0]
        try:
            address = int(args[1], 0)
        except:
            print >> sys.stderr, "ERROR: address must be valid int"
            return
        p4_tables_api.table_tcam_erase_entry(table_name, address)

    def help_table_tcam_erase_entry(self):
        print """
table_tcam_erase_entry <table_name> <address>
DESCRIPTION: invalidates(removes) an entry in the TCAM
"""

    def do_table_tcam_verify_entry(self, line):
        # defined in p4_px_tables.py
        (table_name, address, keys, masks, action_name, action_data) = parse_table_tcam_add_entry(line)
        rc = p4_tables_api.table_tcam_verify_entry(table_name, address, keys, masks, action_name, action_data)
        print p4_tables_api.table_tcam_error_decode(rc)

    def help_table_tcam_verify_entry(self):
        print """
table_tcam_verify_entry <table_name> <address> <action_name> <key1/mask1 ... keyN/maskN> => <action_data>
DESCRIPTION: verifies whether an entry exists in TCAM 
PARAMS:
    <table_name> : name of the table to add an entry to
    <address> : address in table at which to add the entry
    <action_name> : name of the action to use in the entry (must be listed in the table's actions list)
    <key/mask> : space separated list of key/mask to use as the entry key (must correspond to table's keys in the order defined in the P4 program)
    <action_data> : space separated list of values to provide as input to the action
"""

    ###########################
    ### LPM Table Functions ###
    ###########################

    """
    List the LPM tables and some relevant info
    """
    def do_list_lpm_tables(self, line):
        for table_name, table in PX_LPM_TABLES.items():
            print '-'*len(table_name), '\n', table_name, ':\n', '-'*len(table_name)
            pprint(table.info)

    def help_list_lpm_tables(self):
        print """
list_lpm_tables
DESCRIPTION: List the longest prefix match tables defined in the SimpleSumeSwitch and their relevant compile time information
"""

    def do_table_lpm_get_addr_size(self, line):
        print p4_tables_api.table_lpm_get_addr_size()

    def help_table_lpm_get_addr_size(self):
        print """
table_lpm_get_addr_size 
DESCRIPTION: returns the LPM_ADDR_SIZE 
"""    

    def do_table_lpm_set_log_level(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_lpm_set_log_level()
            return
        table_name = args[0]
        try:
            msg_level = int(args[1], 0)
        except:
            print >> sys.stderr, "ERROR: msg_level must be valid int"
            return
        p4_tables_api.table_lpm_set_log_level(table_name, msg_level)

    def help_table_lpm_set_log_level(self):
        print """
table_lpm_set_log_level <table_name> <msg_level>
DESCRIPTION: Update the logging level of the table 
"""

    def do_table_lpm_load_dataset(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_lpm_load_dataset()
            return
        table_name = args[0]
        filename = args[1]
        p4_tables_api.table_lpm_load_dataset(table_name, filename)

    def help_table_lpm_load_dataset(self):
        print """
table_lpm_load_dataset <table_name> <filename>
DESCRIPTION: Load new dataset into table 
"""

    def do_table_lpm_verify_dataset(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_lpm_verify_dataset()
            return
        table_name = args[0]
        filename = args[1]
        rc = p4_tables_api.table_lpm_verify_dataset(table_name, filename)
        print p4_tables_api.table_lpm_error_decode(rc)

    def help_table_lpm_verify_dataset(self):
        print """
table_lpm_verify_dataset <table_name> <filename>
DESCRIPTION: Verify that dataset is in table 
"""

    def do_table_lpm_set_active_lookup_bank(self, line):
        args = line.strip().split()
        if (len(args) < 2):
            print >> sys.stderr, "ERROR: usage..."
            self.help_table_lpm_set_log_level()
            return
        table_name = args[0]
        try:
            bank = int(args[1], 0)
        except:
            print >> sys.stderr, "ERROR: bank must be valid int"
            return
        p4_tables_api.table_lpm_set_active_lookup_bank(table_name, bank)

    def help_table_lpm_set_active_lookup_bank(self):
        print """
table_lpm_set_log_level <table_name> <bank>
DESCRIPTION: sets the active lookup bank
"""


if __name__ == '__main__':
    if len(sys.argv) > 1:
        SimpleSumeSwitch().onecmd(' '.join(sys.argv[1:]))
    else:
        SimpleSumeSwitch().cmdloop()

