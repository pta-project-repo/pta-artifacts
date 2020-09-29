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


#
# Author: Stephen Ibanez
# Description: Makefile to compile the libcam.so, libtcam.so, and liblpm.so 
#

API_FOLDER=${P4_PROJECT_DIR}/sw/API
LIBSUME_FOLDER=${SUME_SDNET}/sw/sume

CFLAGS = -std=c99 -Wall -Werror

all: libcam libtcam liblpm

# CAM library

CAM.o: ${API_FOLDER}/CAM.h ${API_FOLDER}/CAM.c
	cc -c -fPIC ${API_FOLDER}/CAM.c -I${API_FOLDER}

libcam.o: CAM.o libcam.c libcam.h
	cc ${CFLAGS} -fPIC -c libcam.c -I${LIBSUME_FOLDER} -I${API_FOLDER} 

libcam: libcam.o
	cc -L${LIBSUME_FOLDER} -shared -o libcam.so libcam.o CAM.o -lsumereg 

# TCAM library

TCAM.o: ${API_FOLDER}/TCAM.h ${API_FOLDER}/TCAM.c
	cc -c -fPIC ${API_FOLDER}/TCAM.c -I${API_FOLDER}

libtcam.o: TCAM.o libtcam.c libtcam.h
	cc ${CFLAGS} -fPIC -c libtcam.c -I${LIBSUME_FOLDER} -I${API_FOLDER} 

libtcam: libtcam.o
	cc -L${LIBSUME_FOLDER} -shared -o libtcam.so libtcam.o TCAM.o -lsumereg 

# LPM library

LPM.o: ${API_FOLDER}/LPM.h ${API_FOLDER}/LPM.c
	cc -c -fPIC ${API_FOLDER}/LPM.c -I${API_FOLDER}

liblpm.o: LPM.o liblpm.c liblpm.h
	cc ${CFLAGS} -fPIC -c liblpm.c -I${LIBSUME_FOLDER} -I${API_FOLDER} 

liblpm: liblpm.o
	cc -L${LIBSUME_FOLDER} -shared -o liblpm.so liblpm.o LPM.o -lsumereg 


clean:
	rm -f *.so *.o

# end
