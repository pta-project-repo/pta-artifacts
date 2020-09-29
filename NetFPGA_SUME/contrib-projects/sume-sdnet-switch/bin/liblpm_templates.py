
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

INCLUDES = """
/* AUTO GENERATED FILE!! DO NOT MODIFY!!
 *
 * Author: Stephen Ibanez
 *
 * This file is provides the implementation of some convenience functions
 * that can be used when working with SDNet generated LPM tables. 
 */

#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "LPM.h"
#include "sume_reg_if.h"

#define SUME_SDNET_BASE_ADDR          {0}

// global variables
"""

GLOBALS_TEMPLATE = """
uint32_t {0[table_name]}_ID = {0[tableID]};
LPM_CONTEXT LPM_CONTEXT_{0[table_name]};

"""

HELPER_FUNCS = """

/* Some helper functions for the API functions 
 */

uint32_t log_level=0;

//log message
int log_msg(const char* msg) {
    printf("%s", msg);
    return 0;
}

"""

INIT_FUNC_TEMPLATE = """
void init_{0[table_name]}() {{
    LPM_CONTEXT* cx = &LPM_CONTEXT_{0[table_name]};
    uint32_t size = LPM_Init_GetAddrSize();
    addr_t baseAddr = SUME_SDNET_BASE_ADDR + {0[base_address]};
    uint32_t max_depth = {0[max_depth]};
    uint32_t key_width = {0[key_width]};
    uint32_t value_width = {0[value_width]};
    uint32_t shadow_mem = {0[shadow_mem]};
    void (*register_write)(addr_t addr, uint32_t data);
    uint32_t (*register_read)(addr_t addr);
    // cast the driver functions to the appropriate types
    register_write = (void (*)(addr_t addr, uint32_t data)) &sume_register_write;
    register_read = (uint32_t (*)(addr_t addr)) &sume_register_read;

    // Initialize the LPM_CONTEXT
    if(LPM_Init_ValidateContext(cx,baseAddr,size,max_depth,key_width,value_width,shadow_mem,register_write,register_read,&log_msg,log_level)) {{
        printf("LPM_Init_ValidateContext() - failed\\n");
    }} else {{
        printf("LPM_Init_ValidateContext() - done\\n");
    }}

}}

"""

TABLE_ADDR_SIZE = """
/*
 * Get the LPM address size
 */
uint32_t lpm_get_addr_size() {
    return LPM_Init_GetAddrSize();
}    
"""

TABLE_SET_LOG_START = """
/*
 * Set the log level of the table 
 */
int lpm_set_log_level(uint32_t tableID, uint32_t msg_level) {
    
"""

TABLE_SET_LOG_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return LPM_Init_SetLogLevel(&LPM_CONTEXT_{0[table_name]}, msg_level);
    }}
"""

TABLE_LOAD_START = """
/*
 * Load dataset to table 
 */
int lpm_load_dataset(uint32_t tableID, char* filename) {
    
"""

TABLE_LOAD_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return LPM_Mgt_LoadDataset(&LPM_CONTEXT_{0[table_name]}, filename);
    }}
"""

TABLE_VERIFY_START = """
/*
 * Verify dataset in table 
 */
int lpm_verify_dataset(uint32_t tableID, char* filename) {
    
"""

TABLE_VERIFY_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return LPM_Mgt_VerifyDataset(&LPM_CONTEXT_{0[table_name]}, filename);
    }}
"""

TABLE_SET_BANK_START = """
/*
 * Set active lookup bank in table 
 */
int lpm_set_active_lookup_bank(uint32_t tableID, uint32_t bank) {
    
"""

TABLE_SET_BANK_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return LPM_Mgt_SetActiveLookupBank(&LPM_CONTEXT_{0[table_name]}, bank);
    }}
"""

FUNC_END = """
    else {
        return LPM_ERROR_ACC;
    }
}
"""

TABLE_ERROR_DECODE = """

const char* lpm_error_decode(int error) {
    return LPM_Error_Decode(error);
}

"""

