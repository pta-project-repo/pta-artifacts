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


/*
 *  File:
 *        sume_reg_if.c
 *
 * Author:
 *        Stephen Ibanez
 *
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

#include "nf_sume.h"
#include "sume_reg_if.h"

uint32_t sume_register_if(uint32_t addr, uint32_t data, int req) {
    char *ifnam;
    struct sume_ifreq sifr;
    struct ifreq ifr;
    size_t ifnamlen;
    int fd, rc;

    ifnam = SUME_IFNAM_DEFAULT;
    ifnamlen = strlen(ifnam);

    fd = socket(AF_INET6, SOCK_DGRAM, 0);
    if (fd == -1) {
        fd = socket(AF_INET, SOCK_DGRAM, 0);
        if (fd == -1)
            err(1, "socket failed for AF_INET6 and AF_INET");
    }

    memset(&sifr, 0, sizeof(sifr));
    sifr.addr = addr;
    if (req == SUME_IOCTL_CMD_WRITE_REG) {
        sifr.val = data;
    }

    memset(&ifr, 0, sizeof(ifr));
    if (ifnamlen >= sizeof(ifr.ifr_name))
        errx(1, "Interface name too long");
    memcpy(ifr.ifr_name, ifnam, ifnamlen);
    ifr.ifr_name[ifnamlen] = '\0';
    ifr.ifr_data = (char *)&sifr;

    rc = ioctl(fd, req, &ifr);
    if (rc == -1)
        err(1, "ioctl");

    close(fd);

    printf("%s 0x%08x = 0x%04x\n", (req == SUME_IOCTL_CMD_WRITE_REG) ? "WROTE" :
            "READ ", sifr.addr, sifr.val); 

    return sifr.val;
}


void sume_register_write(uint32_t addr, uint32_t data) {
   
    sume_register_if(addr, data, SUME_IOCTL_CMD_WRITE_REG); 

}

uint32_t sume_register_read(uint32_t addr) {
    
    return sume_register_if(addr, 0, SUME_IOCTL_CMD_READ_REG);

}


