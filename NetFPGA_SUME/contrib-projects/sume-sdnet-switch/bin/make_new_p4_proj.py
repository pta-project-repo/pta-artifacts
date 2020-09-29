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
This script creates a new P4 project targeting the SimpleSumeSwitch 
in the projects/ directory 
"""

import argparse, sys, re, os
from collections import OrderedDict

TEMPLATE_PROJ = "sss_p4_proj"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('P4_PROJECT_NAME', type=str, help="the name of the new P4 project to create")
    args = parser.parse_args()

    templates_dir = os.path.expandvars('$SUME_SDNET/templates')
    projects_dir = os.path.expandvars('$SUME_SDNET/projects')

    rc = os.system('cp -r {0} {1}'.format(os.path.join(templates_dir, TEMPLATE_PROJ), projects_dir))
    if rc != 0:
        print >> sys.stderr, "ERROR: could not copy template project into project directory"
        sys.exit(1)

    rc = os.system('mv {0} {1}'.format(os.path.join(projects_dir, TEMPLATE_PROJ), os.path.join(projects_dir, args.P4_PROJECT_NAME)))
    if rc != 0:
        print >> sys.stderr, "ERROR: could not rename template project directory to desired project name"
        sys.exit(1)

    src_dir = os.path.expandvars('$SUME_SDNET/projects/{0}/src'.format(args.P4_PROJECT_NAME))
    rc = os.system('mv {0} {1}'.format(os.path.join(src_dir, TEMPLATE_PROJ + '.p4'), os.path.join(src_dir, args.P4_PROJECT_NAME + '.p4')))
    if rc != 0:
        print >> sys.stderr, "ERROR: could not rename template project P4 source file to desired name"
        sys.exit(1)

    print "{0} P4 project directory successfully created in projects folder".format(args.P4_PROJECT_NAME)

if __name__ == "__main__":
    main()


