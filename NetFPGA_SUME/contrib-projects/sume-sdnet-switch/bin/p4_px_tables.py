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
Run the commands in commands.txt file to fill out the *.tbl files
which contain the initial entries in each table
"""

import sys, os, argparse, re, json
import struct, socket
from collections import OrderedDict

class PXTable(object):
    """
    Generic PX table type
    """

    def __init__(self, block_name, table_dict):
        self.info = table_dict
        self.block_name = block_name
        self.name = table_dict['p4_name']

        # actions:
        #   list of dictionaries that consists of: p4_name, px_name, action_run
        self.actions = table_dict['action_ids']

        # request_tuple:
        self.request_tuple = table_dict['request_fields']
    
        # response_tuple:
        self.response_tuple = table_dict['response_fields']

    """
    Combine P4 field values into single hex number where the bit width of each
    P4 field value is indicated in fields list
    """
    def _hexify(self, field_vals, fields):
        field_sizes = [size for name, size in fields if ('padding' not in name and 'hit' not in name)]

        if (len(field_vals) != len(field_sizes)):
            print >> sys.stderr, "ERROR: not enough fields provided to complete _hexify()"
            sys.exit(1)

        ret = 0
        for val, bits in zip(field_vals, field_sizes):
            mask = 2**bits -1
            ret = (ret << bits) + (val & mask)
        return ret


    """
    Return list of fields, each entry of form: (field_name, size_bits, lsb)
    Sorted in decending order by lsb
    """
    def extract_fields(self, field_list):
        result = []
        for field in field_list:
            if field['type'] == 'bits':
                result.append((field['px_name'], field['size']))
            elif field['type'] == 'struct':
                for f in field['fields']:
                    result.append((f['px_name'], f['size']))
        return result 

    """
    Get the action_ID of the given action_name for the table
    """
    def get_action_id(self, action_name):
        if action_name in self.actions.keys():
            return self.actions[action_name]
        return None

    """
    Convert the action_name and action_data into a single hex value represented
    as a string
    """
    def hexify_value(self, action_name, action_data):
        fields = self.extract_fields(self.response_tuple)
        action_name = '{}.{}'.format(self.block_name, action_name) if action_name != 'NoAction' else '.NoAction'
        if (action_name not in self.actions.keys()):
            print >> sys.stderr, "ERROR: {} is not a recognized action for table {}".format(action_name, self.name)
            sys.exit(1)
        field_vals = [self.get_action_id(action_name)] + action_data
        return self._hexify(field_vals, fields)

    """
    Convert list of ints representing the keys to match on into a single hex value
    represented as a string
    """
    def hexify_key(self, key_list):
        fields = self.extract_fields(self.request_tuple)
        field_vals = key_list
        return self._hexify(field_vals, fields)


class PXCAMTable(PXTable):
    """
    Table type for exact matches
    """

    def __init__(self, block_name, table_dict):
        super(PXCAMTable, self).__init__(block_name, table_dict)

        # format       ==> {key : value}
        #   key format   ==> <key1><key2>...
        #   value format ==> <action_ID><action_data1><action_data2>...
        self.entries = OrderedDict()

    """
    Add entry to CAM table
    """
    def add_entry(self, keys, action_name, action_data):
        key = self.hexify_key(keys)
        value = self.hexify_value(action_name, action_data)
        self.entries[key] = value

    """
    Write the entries of the table to a file that can be used in the SDNet simulations 
    """
    def write_px_file(self):
        with open(self.name + ".tbl", 'w+') as fout:
            for key, value in self.entries.items():
                fout.write("{:X} {:X}\n".format(key, value)) 


class PXTCAMTable(PXTable):
    """
    Table type for ternary matches
    """

    def __init__(self, block_name, table_dict):
        super(PXTCAMTable, self).__init__(block_name, table_dict)

        # Each entry is a list with the following format:
        # format       ==> [address, mask, key, value] 
        self.entries = []

    """
    Convert mask_list into single hex value represented as a string
    """
    def hexify_mask(self, mask_list):
        fields = self.extract_fields(self.request_tuple)
        field_vals = mask_list
        return self._hexify(field_vals, fields)

    """
    Add an entry to a TCAM table.
    """
    def add_entry(self, address, keys, masks, action_name, action_data):
        mask = self.hexify_mask(masks)
        key = self.hexify_key(keys)
        value = self.hexify_value(action_name, action_data)
        self.entries.append([address, mask, key, value])

    """
    Write the entries of the table to a file that can be used in the SDNet simulations 
    """
    def write_px_file(self):
        with open(self.name + ".tbl", 'w+') as fout:
            for addr, mask, key, value in self.entries:
                fout.write("{:d} {:X} {:X} {:X}\n".format(addr, key, mask, value)) 


class PXLPMTable(PXTable):
    """
    Table type for longest prefix matches
    """

    def __init__(self, block_name, table_dict):
        super(PXLPMTable, self).__init__(block_name, table_dict)

        # Each entry is a list with the following format:
        # format       ==> [prefix, length, value] 
        self.entries = []

    """
    Add an entry to an LPM table.
    """
    def add_entry(self, prefix, length, action_name, action_data):
        value = self.hexify_value(action_name, action_data)
        self.entries.append([prefix, length, value])

    """
    Write the entries of the table to a file that can be used in the SDNet simulations 
    """
    def write_px_file(self):
        with open(self.name + ".tbl", 'w+') as fout:
            for prefix, length, value in self.entries:
                fout.write("{} {:d} {:X}\n".format(prefix, length, value))


PX_TABLES = {}

"""
Create the PX_TABLES
"""
def make_px_tables(switch_info_file):
    with open(switch_info_file) as f:
        switch_info = json.load(f)
    for block, block_dict in switch_info.items():
        if 'px_lookups' in block_dict.keys():
            for table_dict in block_dict['px_lookups']:
                table_name = table_dict['p4_name']
                table_type = table_dict['match_type']
                if (table_type == "EM"):
                    PX_TABLES[table_name] = PXCAMTable(block, table_dict)
                elif (table_type == "TCAM"):
                    PX_TABLES[table_name] = PXTCAMTable(block, table_dict)
                elif (table_type == "LPM"):
                    PX_TABLES[table_name] = PXLPMTable(block, table_dict)
                else:
                    print >> sys.stderr, "ERROR: {} uses an unsupported match type".format(table_name)
                    sys.exit(1) 


def help_table_cam_add_entry():
    return """
table_cam_add_entry <table_name> <action_name> <keys> => <action_data>
DESCRIPTION: Add an entry to the specified table
PARAMS:
    <table_name> : name of the table to add an entry to
    <action_name> : name of the action to use in the entry (must be listed in the table's actions list)
    <keys> : space separated list of keys to use as the entry key (must correspond to table's keys in the order defined in the P4 program)
    <action_data> : space separated list of values to provide as input to the action
"""

def help_table_tcam_add_entry():
    return """
table_tcam_add_entry <table_name> <address> <action_name> <key1/mask1 ... keyN/maskN> => <action_data>
DESCRIPTION: Add an entry to the specified table
PARAMS:
    <table_name> : name of the table to add an entry to
    <address> : address in table at which to add the entry
    <action_name> : name of the action to use in the entry (must be listed in the table's actions list)
    <key/mask> : space separated list of key/mask to use as the entry key (must correspond to table's keys in the order defined in the P4 program)
    <action_data> : space separated list of values to provide as input to the action
"""

def help_table_lpm_add_entry():
    return """
table_lpm_add_entry <table_name> <action_name> <prefix/length> => <action_data>
DESCRIPTION: Add an entry to the specified table
PARAMS:
    <table_name> : name of the table to add an entry to
    <action_name> : name of the action to use in the entry (must be listed in the table's actions list)
    <prefix/length> : prefix - either in dot or colon separated format (i.e. IPv4 or IPv6 address format), length - length of prefix 
    <action_data> : space separated list of values to provide as input to the action
"""

def ip2int(addr):
    return struct.unpack("!I", socket.inet_aton(addr))[0]

def mac2int(addr):
    return int(addr.translate(None, ":"), 16)

def convert_to_int(string):
    mac_fmat = r'([\dA-Fa-f]{2}:){5}[\dA-Fa-f]{2}'
    ip_fmat = r'([0-9]{1,3}\.){3}[0-9]{1,3}'
    if re.match(mac_fmat, string):
        return mac2int(string)
    elif re.match(ip_fmat, string):
        return ip2int(string)
    else:
        try:
            return int(string, 0)
        except ValueError as e:
            print >> sys.stderr, "ERROR: failed to convert {} to an integer".format(string) 

def parse_table_cam_add_entry(line):
    stmt = line.split('=>')
    if len(stmt) != 2:
        print >> sys.stderr, "ERROR: ", help_table_cam_add_entry() 
        print stmt
        sys.exit(1) 
    
    lhs = stmt[0].split()
    rhs = stmt[1].split()
    if (len(lhs) < 3):
        print >> sys.stderr, "ERROR: ", help_table_cam_add_entry()
        sys.exit(1)
    table_name = lhs[0]
    action_name = lhs[1]
    keys = map(convert_to_int, lhs[2:])
    action_data = map(convert_to_int, rhs)
    return (table_name, keys, action_name, action_data)

def parse_table_tcam_add_entry(line):
    fmat = r"(?P<table_name>[\S]+) (?P<address>[\S]+) (?P<action_name>[\S]+) (?P<key_list>.+) =>(?P<action_data>.*)"
    searchObj = re.search(fmat, line)
    if searchObj is None:
        print >> sys.stderr, "ERROR: ", help_table_tcam_add_entry()
        sys.exit(1)
    table_name = searchObj.groupdict()['table_name'] 
    try:
        address = int(searchObj.groupdict()['address'], 0)
    except:
        print >> sys.stderr, "ERROR: TCAM entry address could not be converted to integer"
        sys.exit(1) 
    action_name = searchObj.groupdict()['action_name']
    key_list = searchObj.groupdict()['key_list'].strip().split()
    keys = []
    masks = []
    for key in key_list:
        key_mask = key.split('/')
        if (len(key_mask) != 2):
            print >> sys.stderr, "ERROR: must specify exactly one mask for each key"
            sys.exit(1)
        keys.append(convert_to_int(key_mask[0]))
        masks.append(convert_to_int(key_mask[1]))
    rhs = searchObj.groupdict()['action_data'].split()
    action_data = map(convert_to_int, rhs)
    return (table_name, address, keys, masks, action_name, action_data)


def parse_table_lpm_add_entry(line):
    fmat = r"(?P<table_name>[\S]+) (?P<action_name>[\S]+) (?P<key>[\S]+) =>(?P<action_data>.*)"
    searchObj = re.search(fmat, line)
    if searchObj is None:
        print >> sys.stderr, "ERROR: ", help_table_lpm_add_entry()
        sys.exit(1)
    table_name = searchObj.groupdict()['table_name']
    action_name = searchObj.groupdict()['action_name']
    prefix_len = searchObj.groupdict()['key'].split('/')
    if (len(prefix_len) != 2):
        print >> sys.stderr, "ERROR: must specify exactly one length for each prefix"
        sys.exit(1)
    prefix = prefix_len[0]
    try:
        length = convert_to_int(prefix_len[1])
    except:
        print >> sys.stderr, "ERROR: could not convert prefix length to int"
        sys.exit(1)
    rhs = searchObj.groupdict()['action_data'].split()
    action_data = map(convert_to_int, rhs)
    return (table_name, prefix, length, action_name, action_data)

"""
Add entry to CAM table
"""
def run_table_cam_add_entry(line):
    (table_name, keys, action_name, action_data) = parse_table_cam_add_entry(line)
    if (table_name not in PX_TABLES.keys()):
        print >> sys.stderr, "ERROR: {} is not a recognized table name".format(table_name)
        sys.exit(1)
    PX_TABLES[table_name].add_entry(keys, action_name, action_data)


"""
Add entry to TCAM table
"""
def run_table_tcam_add_entry(line):
    (table_name, address, keys, masks, action_name, action_data) = parse_table_tcam_add_entry(line)
    if (table_name not in PX_TABLES.keys()):
        print >> sys.stderr, "ERROR: {} is not a recognized table name".format(table_name)
        sys.exit(1)   
    PX_TABLES[table_name].add_entry(address, keys, masks, action_name, action_data)


"""
Add entry to LPM table
"""
def run_table_lpm_add_entry(line):
    (table_name, prefix, length, action_name, action_data) = parse_table_lpm_add_entry(line)
    if (table_name not in PX_TABLES.keys()):
        print >> sys.stderr, "ERROR: {} is not a recognized table name".format(table_name)
        sys.exit(1)       
    PX_TABLES[table_name].add_entry(prefix, length, action_name, action_data)

"""
Iterate through the commands in the commands_file to fill out the table entries
"""
def fill_px_tables(commands_file):
    with open(commands_file) as f:
        for line in f:
            line = line.strip()
            if line.startswith("table_cam_add_entry"):
                run_table_cam_add_entry(line.replace("table_cam_add_entry","").strip())
            elif line.startswith("table_tcam_add_entry"):
                run_table_tcam_add_entry(line.replace("table_tcam_add_entry","").strip())
            elif line.startswith("table_lpm_add_entry"):
                run_table_lpm_add_entry(line.replace("table_lpm_add_entry","").strip())

"""
Write the *.tbl files
"""
def write_px_tables():
    for table in PX_TABLES.values():
        table.write_px_file()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('commands_file', type=str, help="the commands.txt file")
    parser.add_argument('switch_info_file', type=str, help="the .sdnet_switch_info.dat file")

    args = parser.parse_args()

    make_px_tables(args.switch_info_file)
    fill_px_tables(args.commands_file)
    write_px_tables()

if __name__ == "__main__":
    main()

