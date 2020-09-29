//
// Copyright (c) 2017 Stephen Ibanez
// All rights reserved.
//
// This software was developed by Stanford University and the University of Cambridge Computer Laboratory 
// under National Science Foundation under Grant No. CNS-0855268,
// the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
// by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), 
// as part of the DARPA MRC research programme.
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  NetFPGA licenses this
// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.netfpga-cic.org
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
//


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "table_update.h"
#include "CAM.h"


/*
 * Read the key and value entries for the table from the file and
 * write the entries into the CAM CONTEXT
 */
int update_table_from_file(CAM_CONTEXT* cx, const char* filename) {
    FILE* fid = fopen(filename,"r");
    if (fid == NULL) {
        return 1;
    }

    // TODO: currently does not support commented lines

    // count the number of entries in the table
    int index = 0;
    char temp_key[BUFSIZE], temp_value[BUFSIZE];
    while (!feof(fid)) {
        int count = fscanf(fid,"%s %s", temp_key, temp_value);
        if (count == EOF) continue;
        else if (count != 2) {
            printf("error in %s:%d : invalid line format, expected key(hex) value(hex)\n", filename, index);
            return 1;
        }
        index += 1;
    }
    fclose(fid);
    char key[index][BUFSIZE];
    char value[index][BUFSIZE];

    // assign the keys and values
    fid = fopen(filename,"r");
    if (fid == NULL) {
        return 1;
    }
    index = 0;
    while (!feof(fid)) {
        int count = fscanf(fid,"%s %s", key[index], value[index]);
        if (count == EOF) continue;
        index += 1;
    }
    fclose(fid);

    // write the table entries
    for (int i=0; i<index; i++) {
        printf("CAM UPDATE %d: KEY(hex) = %s VALUE(hex) = %s\n",i,key[i],value[i]);
        CAM_Mgt_InsertEntry(cx, key[i], value[i], 0);
    }
    return 0;
}




