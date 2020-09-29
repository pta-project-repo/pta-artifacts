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

from NFTest import *
import sys, os, re, json
from fcntl import *
from ctypes import *

SWITCH_INFO_FILE = os.path.expandvars("$P4_PROJECT_DIR/src/.sdnet_switch_info.dat")

# sets PX_TABLES
import p4_px_tables
p4_px_tables.make_px_tables(SWITCH_INFO_FILE)

PX_CAM_TABLES = {}
PX_TCAM_TABLES = {}
PX_LPM_TABLES = {}

def split_px_tables():
    for name, table in p4_px_tables.PX_TABLES.items():
        if table.info['match_type'] == 'EM':
            PX_CAM_TABLES[name] = table
        elif table.info['match_type'] == 'TCAM':
            PX_TCAM_TABLES[name] = table
        elif table.info['match_type'] == 'LPM':
            PX_LPM_TABLES[name] = table

split_px_tables()

if (len(PX_CAM_TABLES) > 0):
    print "loading libcam.."
    libcam=cdll.LoadLibrary(os.path.expandvars('$P4_PROJECT_DIR/sw/CLI/libcam.so'))
    
    # argtypes for the functions called from  C
    libcam.cam_read_entry.argtypes = [c_uint, c_char_p, c_char_p, c_char_p]
    libcam.cam_add_entry.argtypes = [c_uint, c_char_p, c_char_p]
    libcam.cam_delete_entry.argtypes = [c_uint, c_char_p]
    libcam.cam_error_decode.argtypes = [c_int]
    libcam.cam_error_decode.restype = c_char_p
    libcam.cam_get_size.argtypes = [c_uint]
    libcam.cam_get_size.restype = c_uint

if (len(PX_TCAM_TABLES) > 0):
    print "loading libtcam.."
    libtcam=cdll.LoadLibrary(os.path.expandvars('$P4_PROJECT_DIR/sw/CLI/libtcam.so'))
    
    # argtypes for the functions called from  C
    libtcam.tcam_clean.argtypes = [c_uint]
    libtcam.tcam_get_addr_size.argtypes = []
    libtcam.tcam_set_log_level.argtypes = [c_uint, c_uint]
    libtcam.tcam_write_entry.argtypes = [c_uint, c_uint, c_char_p, c_char_p, c_char_p]
    libtcam.tcam_erase_entry.argtypes = [c_uint, c_uint]
    libtcam.tcam_verify_entry.argtypes = [c_uint, c_uint, c_char_p, c_char_p, c_char_p]
    libtcam.tcam_verify_entry.restype = c_uint
    libtcam.tcam_error_decode.argtypes = [c_int]
    libtcam.tcam_error_decode.restype = c_char_p

if (len(PX_LPM_TABLES) > 0):
    print "loading liblpm.."
    liblpm=cdll.LoadLibrary(os.path.expandvars('$P4_PROJECT_DIR/sw/CLI/liblpm.so'))
    
    # argtypes for the functions called from  C
    liblpm.lpm_get_addr_size.argtypes = []
    liblpm.lpm_set_log_level.argtypes = [c_uint, c_uint]
    liblpm.lpm_load_dataset.argtypes = [c_uint, c_char_p]
    liblpm.lpm_verify_dataset.argtypes = [c_uint, c_char_p]
    liblpm.lpm_set_active_lookup_bank.argtypes = [c_uint, c_uint]
    liblpm.lpm_error_decode.argtypes = [c_int]
    liblpm.lpm_error_decode.restype = c_char_p

TABLE_DEFINES_FILE = os.path.expandvars("$P4_PROJECT_DIR/sw/CLI/SimpleSumeSwitch_table_defines.json")

########################
### Helper Functions ###
########################

"""
def the SimpleSumeSwitch_table_defines.json file
"""
def read_table_defines():
    with open(TABLE_DEFINES_FILE) as f:
        tables_dict = json.load(f)
    return tables_dict


p4_tables_info = read_table_defines()

"""
Check if table_name is a valid CAM table
"""
def check_valid_cam_table_name(table_name):
    if (table_name not in PX_CAM_TABLES.keys() and table_name not in p4_tables_info['EM'].keys()):
        print >> sys.stderr, "ERROR: {0} is not a recognized CAM table name".format(table_name)
        return False
    return True

"""
Check if table_name is a valid TCAM table
"""
def check_valid_tcam_table_name(table_name):
    if (table_name not in PX_TCAM_TABLES.keys() and table_name not in p4_tables_info['TCAM'].keys()):
        print >> sys.stderr, "ERROR: {0} is not a recognized TCAM table name".format(table_name)
        return False
    return True

"""
Check if table_name is a valid LPM table
"""
def check_valid_lpm_table_name(table_name):
    if (table_name not in PX_LPM_TABLES.keys() and table_name not in p4_tables_info['LPM'].keys()):
        print >> sys.stderr, "ERROR: {0} is not a recognized LPM table name".format(table_name)
        return False
    return True

#########################
### CAM API Functions ###
#########################

def table_cam_read_entry(table_name, keys):
    if not check_valid_cam_table_name(table_name):
        return "NA", "NA"

    tableID = int(p4_tables_info['EM'][table_name]['tableID']) 
    key = PX_CAM_TABLES[table_name].hexify_key(keys) 
    hex_key_buf = create_string_buffer("{:X}".format(key))
    value = create_string_buffer(1024) # TODO: Fix this ... Must be large enough to hold entire value 
    found = create_string_buffer(10)  # Should only need to hold "True" or "False"  
    rc = libcam.cam_read_entry(tableID, hex_key_buf, value, found)
    print libcam.cam_error_decode(rc)
    return found.value, value.value

def table_cam_add_entry(table_name, keys, action_name, action_data):
    if not check_valid_cam_table_name(table_name):
        return

    tableID = int(p4_tables_info['EM'][table_name]['tableID'])
    key = PX_CAM_TABLES[table_name].hexify_key(keys)
    value = PX_CAM_TABLES[table_name].hexify_value(action_name, action_data)
    rc = libcam.cam_add_entry(tableID, "{:X}".format(key), "{:X}".format(value))
    print libcam.cam_error_decode(rc)

def table_cam_delete_entry(table_name, keys):
    if not check_valid_cam_table_name(table_name):
        return

    tableID = int(p4_tables_info['EM'][table_name]['tableID'])
    key = PX_CAM_TABLES[table_name].hexify_key(keys)
    rc = libcam.cam_delete_entry(tableID, "{:X}".format(key))
    print libcam.cam_error_decode(rc)
 
def table_cam_get_size(table_name):
    if not check_valid_cam_table_name(table_name):
        return 0

    tableID = int(p4_tables_info['EM'][table_name]['tableID']) 
    return libcam.cam_get_size(tableID)


##########################
### TCAM API Functions ###
##########################

def table_tcam_clean(table_name):
    if not check_valid_tcam_table_name(table_name):
        return

    tableID = int(p4_tables_info['TCAM'][table_name]['tableID'])
    rc = libtcam.tcam_clean(tableID)
    print libtcam.tcam_error_decode(rc)

def table_tcam_get_addr_size():
    return libtcam.tcam_get_addr_size()

def table_tcam_set_log_level(table_name, msg_level):
    if not check_valid_tcam_table_name(table_name):
        return

    tableID = int(p4_tables_info['TCAM'][table_name]['tableID'])
    rc = libtcam.tcam_set_log_level(tableID, msg_level)
    print libtcam.tcam_error_decode(rc)

def table_tcam_write_entry(table_name, addr, keys, masks, action_name, action_data):
    if not check_valid_tcam_table_name(table_name):
        return

    tableID = int(p4_tables_info['TCAM'][table_name]['tableID'])
    mask = PX_TCAM_TABLES[table_name].hexify_mask(masks)
    key = PX_TCAM_TABLES[table_name].hexify_key(keys)
    value = PX_TCAM_TABLES[table_name].hexify_value(action_name, action_data)
    rc = libtcam.tcam_write_entry(tableID, addr, "{:X}".format(key), "{:X}".format(mask), "{:X}".format(value))
    print libtcam.tcam_error_decode(rc)

def table_tcam_erase_entry(table_name, addr):
    if not check_valid_tcam_table_name(table_name):
        return

    tableID = int(p4_tables_info['TCAM'][table_name]['tableID'])
    rc = libtcam.tcam_erase_entry(tableID, addr)
    print libtcam.tcam_error_decode(rc)


def table_tcam_verify_entry(table_name, addr, keys, masks, action_name, action_data):
    if not check_valid_tcam_table_name(table_name):
        return

    tableID = int(p4_tables_info['TCAM'][table_name]['tableID'])
    mask = PX_TCAM_TABLES[table_name].hexify_mask(masks)
    key = PX_TCAM_TABLES[table_name].hexify_key(keys)
    value = PX_TCAM_TABLES[table_name].hexify_value(action_name, action_data)
    return libtcam.tcam_verify_entry(tableID, addr, "{:X}".format(key), "{:X}".format(mask), "{:X}".format(value))

def table_tcam_error_decode(error):
    return libtcam.tcam_error_decode(error)


#########################
### LPM API Functions ###
#########################

def table_lpm_get_addr_size():
    return liblpm.lpm_get_addr_size()

def table_lpm_set_log_level(table_name):
    if not check_valid_lpm_table_name(table_name):
        return

    tableID = int(p4_tables_info['LPM'][table_name]['tableID'])
    rc = liblpm.lpm_set_log_level(tableID, msg_level)
    print liblpm.lpm_error_decode(rc)

def table_lpm_load_dataset(table_name, filename):
    if not check_valid_lpm_table_name(table_name):
        return

    tableID = int(p4_tables_info['LPM'][table_name]['tableID'])
    rc = liblpm.lpm_load_dataset(tableID, filename)
    print liblpm.lpm_error_decode(rc)

def table_lpm_verify_dataset(table_name, filename):
    if not check_valid_lpm_table_name(table_name):
        return

    tableID = int(p4_tables_info['LPM'][table_name]['tableID'])
    return liblpm.lpm_verify_dataset(tableID, filename)   

def table_lpm_set_active_lookup_bank(table_name, bank):
    if not check_valid_lpm_table_name(table_name):
        return

    tableID = int(p4_tables_info['LPM'][table_name]['tableID'])
    rc = liblpm.lpm_set_active_lookup_bank(tableID, bank)
    print liblpm.lpm_error_decode(rc)

def table_lpm_error_decode(error):
    return liblpm.lpm_error_decode(error)


