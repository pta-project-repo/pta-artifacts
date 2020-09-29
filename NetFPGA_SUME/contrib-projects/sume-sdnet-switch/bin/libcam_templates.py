
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
 * that can be used when working with SDNet generated CAM tables. 
 */

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

#define SUME_SDNET_BASE_ADDR          {0}

// global variables
"""

GLOBALS_TEMPLATE = """
uint32_t {0[table_name]}_ID = {0[tableID]};
CAM_CONTEXT CAM_CONTEXT_{0[table_name]};

"""

HELPER_FUNCS = """

/* Some helper functions for the API functions 
 * Note: uint_* helper functions are from SDNet 2016.4 CAM.c
 */

int uint_to_str(uint32_t val, char *out_buf, int radix);

int uint_array_to_hex_string( uint32_t *in_buf, char *out_buf, int in_arr_size);

int log_msg(const char* msg);

/*
Arguments   :   val - An unsigned integer value
                out_buf - A pointer to an array that can hold a string representation of the
                        hexadecimal value
return      :   int - length of the hexadecimal string
Description :   This function converts the input unsigned integer to its equivalent hexadecimal string
*/
int uint_to_str(uint32_t val, char *out_buf, int radix)
{
    char tmp[16] = "";
    char *tp = tmp;
    int i;
    int len=0;
    while (val || tp == tmp)
    {
        i = val % radix;
        val /= radix;
        if (i < 10)
            *tp++ = i+'0';
        else
            *tp++ = i + 'a' - 10;
    }
    len = tp - tmp;
    while (tp > tmp)
        *out_buf++ = *--tp;

    return len;
}

/*
Arguments   :   in_buf - A pointer to an unsigned integer array
                out_buf - A pointer to an array that can hold a null terminated C string representation of the
                          hexadecimal value
                in_arr_size - size of the input array
return      :   int - (An integer indicating success or an error code)
Description :   This function converts the unsigned integer array to null terminated hex string
*/
int uint_array_to_hex_string( uint32_t *in_buf, char *out_buf, int in_arr_size)
{
    int i = 0;
    int j = 0;
    uint32_t *result;
    int len=0;
    char result_str[16] = "";
    char *result_buf;
    //  Assign the starting address
    result = in_buf;
    result_buf = &result_str[0];
    in_buf = in_buf + in_arr_size - 1;
    for (i = 0; i < in_arr_size; i++)
    {
        len = uint_to_str(*in_buf, result_buf, 16);
        in_buf--;
        for(j=0;j < 8-len;j++)
        {
            *out_buf = '0';
            out_buf++;
        }
        while(*result_buf)
        {
          *out_buf = *result_buf;
          result_buf++;
          out_buf++;
        }
        result_buf = &result_str[0];
    }
    *out_buf = '\\0';

    //  Assign the starting address
    in_buf = result;
    return 0;
}

uint32_t log_level=0;

//log message
int log_msg(const char* msg) {
    printf("%s", msg);
    return 0;
}

"""

INIT_FUNC_TEMPLATE = """
void init_{0[table_name]}() {{
    CAM_CONTEXT* cx = &CAM_CONTEXT_{0[table_name]};
    uint32_t size = CAM_Init_GetAddrSize();
    // TODO: set baseAddr to the base address of the table
    addr_t baseAddr = SUME_SDNET_BASE_ADDR + {0[base_address]};
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

}}

"""

TABLE_READ_START = """
/*
 * Read an entry from a table
 */
int cam_read_entry(uint32_t tableID, char* key, char* value, char* found) {

    CAM_CONTEXT* cx = NULL;
"""

TABLE_READ_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        cx = &CAM_CONTEXT_{0[table_name]};
    }}
"""

TABLE_READ_END = """
    if (cx != NULL) {
        int num_val_regs = (cx->value_width%32 == 0) ? (cx->value_width/32) : ((cx->value_width/32)+1);
        uint32_t val_arr[num_val_regs];
        bool static_flag, found_bool;
        int rc = CAM_Mgt_ReadEntry(cx, key, val_arr, &static_flag, &found_bool);
        uint_array_to_hex_string( val_arr, value, num_val_regs );
        if (found_bool == true) {
            strcpy(found, "True");
        } else {
            strcpy(found, "False");
        }
        return rc;
    }
    else {
        return CAM_OP_FAILED;
    }
}
"""

TABLE_ADD_START = """
/*
 * Add and entry to a table
 */
int cam_add_entry(uint32_t tableID, const char* key, const char* value) {

"""

TABLE_ADD_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return CAM_Mgt_InsertEntry(&CAM_CONTEXT_{0[table_name]}, key, value, 0);
    }}
"""

TABLE_DELETE_START = """
/*
 * Delete an entry from a table
 */
int cam_delete_entry(uint32_t tableID, const char* key) {

"""

TABLE_DELETE_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return CAM_Mgt_RemoveEntry (&CAM_CONTEXT_{0[table_name]}, key);
    }}
"""

TABLE_SIZE_START = """
/*
 * Get the current number of entries in the table
 */
uint32_t cam_get_size(uint32_t tableID) {
    
"""

TABLE_SIZE_TEMPLATE = """
    if (tableID == {0[table_name]}_ID) {{
        init_{0[table_name]}();
        return CAM_Mgt_GetSize(&CAM_CONTEXT_{0[table_name]});
    }}
"""

FUNC_END = """
    else {
        return CAM_OP_FAILED;
    }
}
"""

TABLE_ERROR_DECODE = """

const char* cam_error_decode(int error) {
    return CAM_Error_Decode(error);
}

"""

