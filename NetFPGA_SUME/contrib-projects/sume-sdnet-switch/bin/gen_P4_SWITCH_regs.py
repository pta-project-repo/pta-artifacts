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
- Must parse the P4_SWITCH directory to get the register/counter externs (name, width, depth)
- Also get the final offset of the P4_SWITCH tables from the P4_SWITCH.h file
- Determine offset of each register based on the final P4_SWITCH address, and the width of each 
  register
- After getting that info, fill in a version of the regs_gen.py script and run it to get the
  *_cpu_regs.v file/module
- Insert that module into the P4_SWITCH module
- Connect the new module to the extern modules with wires
- Modify the extern modules to support writes from cpu and output the current value of the reg
"""

import sys, os, argparse, re
from collections import OrderedDict

tuple_in_format = r"""/\* Tuple format for input: .*
\s*\[([\d:]*)\]\s*: .*
\s*\[([\d:]*)\]\s*: .*
\s*\[[\d:]*\]\s*: .*

\*/"""

offset_address_format = r"#define  {0}__FINISH_ADDRESS  ([\dxabcdefABCDEF]*)"
regs_dict_format = r"""def create_regs_list\(\):
  regsDict=\[\]"""
module_name_format = "module_name='{0}'"

REGS_GEN_SCRIPT = "regs_gen.py"
EXTERN_TEMPLATE_FILE = "externs/EXTERN_reg_access_template.v"
REG_DEFINES_FILE = "{0}_reg_defines.py"
REG_DEFINES_CLI = "{0}_reg_defines.txt"
API_dir = "API"
CLI_dir = "CLI"
REG_API_FILE = "{0}_regs.h"

p4_regs = OrderedDict()

"""
Parse the P4_SWITCH dir to find the reg extern directories
"""
def find_p4_regs(P4_SWITCH_dir):
    # look for reg extern directoryies
    for (dirpath, dirnames, filenames) in os.walk(P4_SWITCH_dir):
        for dirname in dirnames:
            matchObj = re.match(r"^(.*)_reg_access_.*\.HDL", dirname)
            if matchObj:
                parse_reg_dir(os.path.join(P4_SWITCH_dir, dirname), matchObj.group(1))

"""
Parse the reg extern directory find to the template instantiation file
"""
def parse_reg_dir(reg_extern_dir, reg_name):
    for (dirpath, dirnames, filenames) in os.walk(reg_extern_dir):
        for filename in filenames:
            if (re.match(r".*{0}.*_reg_access_.*\.v\.stub".format(reg_name), filename)):
                extract_reg_info(os.path.join(reg_extern_dir, filename), reg_name)

"""
Parses the template instantiation file in the given extern HDL directory to
extract the register info
"""
def extract_reg_info(template_file, reg_name):
    content = open(template_file).read()
    searchObj = re.search(tuple_in_format, content)
    try: 
        assert(searchObj is not None)
    except:
        print >> sys.stderr, "ERROR: could not find tuple_in_format in extern {0}".format(template_file)
        sys.exit(1)
    index_bits = searchObj.group(1)
    index_bits = map(int, index_bits.split(':'))
    index_width = index_bits[0] - index_bits[1] + 1
    reg_bits = searchObj.group(2)
    reg_bits = map(int, reg_bits.split(':'))
    reg_width = reg_bits[0] - reg_bits[1] + 1
    try:
        assert(reg_width > 0 and index_width > 0)
    except:
        print >> sys.stderr, "ERROR: reg_width is <= 0 or index_width <= 0 ... infeasible"
        sys.exit(1)
    p4_regs[reg_name] = {}
    p4_regs[reg_name]['width'] = reg_width
    p4_regs[reg_name]['index_width'] = index_width
    # extract address width
    searchObj = re.search(r"input(.*)control_S_AXI_AWADDR", content)
    try:
        assert(searchObj is not None)
    except:
        print >> sys.stderr, "ERROR: could not find S_AXI_AWADDR declaration in {0}".format(template_file)
        sys.exit(1)
    if (':' in searchObj.group(1)):
        addr_bits = searchObj.group(1).replace('[','').replace(']','')
        addr_bits = map(int, addr_bits.split(':'))
        p4_regs[reg_name]['addr_width'] = addr_bits[0] - addr_bits[1] + 1
    else:
        p4_regs[reg_name]['addr_width'] = 1
 
"""
Read P4_SWITCH.h to determine the offset address (i.e. after the tables)
"""
def get_address_offset(P4_SWITCH_dir, P4_SWITCH):
    global p4_regs
    for (dirpath, dirnames, filenames) in os.walk(P4_SWITCH_dir):
        for filename in filenames:
            if filename == P4_SWITCH + ".h":
                contents = open(os.path.join(P4_SWITCH_dir, filename)).read()
                for reg_name, reg_dict in p4_regs.items():
                    address_format = r"#define  {0}__{1}_reg_access__START_ADDRESS\s*([\dxabcdefABCDEF]*)".format(P4_SWITCH, reg_name)
                    searchObj = re.search(address_format, contents)
                    try:
                        assert(searchObj is not None)
                    except:
                        print >> sys.stderr, "ERROR: cannot find address for {0} in {1}".format(reg_name, filename)
                        sys.exit(1)
                    reg_dict['addr_offset'] = int(searchObj.group(1), 0)

"""
Fill out the register entries for the regs_gen.py script
"""
def fill_regs_dict():
    global p4_regs
    for reg_name, reg_dict in p4_regs.items():
        reg_dict['reg'] = reg_name
        reg_dict['type'] = "RWA"
        reg_dict['endian'] = "little"
        reg_dict['name'] = reg_name
        reg_dict['bits'] = str(reg_dict['width']-1)+":0"
        reg_dict['addr'] = str(reg_dict['addr_width']) + "'h0" # addressable register will always be at address 0 until arrays are supported 
        reg_dict['default'] = str(reg_dict['width'])+"'h0"
        reg_dict['width'] = str(reg_dict['width'])
        reg_dict['index_width'] = str(reg_dict['index_width'])

"""
Fill out and run the reg_gen.py template scripts with the p4_regs info
for each declared register
"""
def make_regs_gen_scripts(templates_dir, P4_SWITCH_dir, P4_SWITCH):
    global p4_regs
    for reg_name, reg_dict in p4_regs.items():
        regs_dict_replacement = """def create_regs_list():
  regsDict=[\n""" + \
        str(reg_dict) + ',\n]'
        template_content = open(os.path.join(templates_dir, REGS_GEN_SCRIPT)).read()
        try:
            assert(re.search(regs_dict_format, template_content) is not None)
        except:
            print >> sys.stderr, "ERROR: regs_dict_format not found in {0}".format(REGS_GEN_SCRIPT)
            sys.exit(1)
        newScript = re.sub(regs_dict_format, regs_dict_replacement, template_content)
        newScript = newScript.replace('MODULENAME', reg_name)
        # write the regs_gen.py script into the appropriate UserEngine directory
        reg_dir = find_reg_extern_dir(reg_name, P4_SWITCH_dir)
        with open(os.path.join(reg_dir, REGS_GEN_SCRIPT), 'w') as f:
            f.write(newScript)
        # execute the newly created regs_gen.py script
        rc = os.system('cd {0} && python {1}'.format(reg_dir, REGS_GEN_SCRIPT))
        if rc != 0:
            print >> sys.stderr, "ERROR: failed to run {0} for {1}".format(REGS_GEN_SCRIPT, reg_name) 
            sys.exit(1)

"""
Find the UserEngine directory corresponding to reg_name
"""
def find_reg_extern_dir(reg_name, P4_SWITCH_dir):
    # look for reg extern directoryies
    for (dirpath, dirnames, filenames) in os.walk(P4_SWITCH_dir):
        for dirname in dirnames:
            matchObj = re.match(r"^{0}_reg_access_.*\.HDL".format(reg_name), dirname)
            if matchObj:
                return os.path.join(P4_SWITCH_dir, dirname)                

"""
Creates the register extern modules from the templates
"""
def make_reg_extern_modules(templates_dir, P4_SWITCH_dir):
    for reg_name, reg_dict in p4_regs.items():
        extern_template = open(os.path.join(templates_dir, EXTERN_TEMPLATE_FILE)).read()
        reg_dir = find_reg_extern_dir(reg_name, P4_SWITCH_dir)
        module_name = os.path.basename(os.path.normpath(reg_dir)).replace(".HDL", "") 
        file_name = module_name + ".v" 
        newModule = extern_template.replace("REGNAME", reg_name)
        newModule = newModule.replace("REGUPPERNAME", reg_name.upper()) 
        newModule = newModule.replace("MODULENAME", module_name)
        newModule = newModule.replace("ADDRWIDTH", str(reg_dict['addr_width']))
        newModule = newModule.replace("INDEXWIDTH", str(reg_dict['index_width']))
        newModule = newModule.replace("REGDEPTH", str(2**int(reg_dict['index_width'])))
        with open(os.path.join(reg_dir, file_name), 'w') as f:
            f.write(newModule)

"""
Combine all of the reg defines for each register extern into a 
P4_SWITCH_reg_defines.py file to be used for SUME simulations
"""
def consolidate_reg_defines(P4_SWITCH_dir, testdata_dir, P4_SWITCH_base_addr, P4_SWITCH):
    contents = """
# This is an automatically generated file containing the register
# definitions for the P4_SWITCH. This is to be used for SUME simulations.\n\n"""
    for reg_name, reg_dict in p4_regs.items():
        reg_address = P4_SWITCH_base_addr + reg_dict['addr_offset']
        contents += "{0}_{1}_ADDR = ".format(P4_SWITCH, reg_name.upper()) + hex(reg_address) + '\n'
        contents += "{0}_{1}_DEFAULT = 0x".format(P4_SWITCH, reg_name.upper()) + reg_dict['default'].split('h')[1] + '\n' 
        contents += "{0}_{1}_WIDTH = ".format(P4_SWITCH, reg_name.upper()) + reg_dict['width'] + '\n\n'
    with open(os.path.join(testdata_dir, REG_DEFINES_FILE.format(P4_SWITCH)), 'w') as f:
        f.write(contents)

"""
Create a reg defines C header file and put it in the sw API folder
"""
def create_reg_API_file(P4_SWITCH_dir, sw_dir, P4_SWITCH_base_addr, P4_SWITCH): 
    contents = """
/* This is an automatically generated file containing the register
 * definitions for the P4_SWITCH. This is to be used as part of the 
 * P4_SWITCH API.
 */\n\n"""
    for reg_name, reg_dict in p4_regs.items():
        reg_address = P4_SWITCH_base_addr + reg_dict['addr_offset']
        contents += "#define {0}_{1}_ADDR  ".format(P4_SWITCH, reg_name.upper()) + hex(reg_address) + '\n'
        contents += "#define {0}_{1}_DEFAULT  0x".format(P4_SWITCH, reg_name.upper()) + reg_dict['default'].split('h')[1] + '\n' 
        contents += "#define {0}_{1}_WIDTH  ".format(P4_SWITCH, reg_name.upper()) + reg_dict['width'] + '\n\n'
    api_dir = os.path.join(sw_dir, API_dir)
    if not os.path.exists(api_dir):
        os.makedirs(api_dir)
    with open(os.path.join(api_dir, REG_API_FILE.format(P4_SWITCH)), 'w') as f:
        f.write(contents)

"""
Create a reg defines text file and put it in the sw CLI folder
"""
def create_reg_CLI_file(P4_SWITCH_dir, sw_dir, P4_SWITCH_base_addr, P4_SWITCH): 
    contents = """
/* This is an automatically generated file containing the register
 * definitions for the P4_SWITCH. This is to be used as part of the 
 * P4_SWITCH CLI.
 */\n\n"""
    for reg_name, reg_dict in p4_regs.items():
        reg_address = P4_SWITCH_base_addr + reg_dict['addr_offset']
        contents += "#define {0}_{1}_ADDR  ".format(P4_SWITCH, reg_name) + hex(reg_address) + '\n'
        contents += "#define {0}_{1}_DEFAULT  0x".format(P4_SWITCH, reg_name) + reg_dict['default'].split('h')[1] + '\n' 
        contents += "#define {0}_{1}_WIDTH  ".format(P4_SWITCH, reg_name) + reg_dict['width'] + '\n\n'
    cli_dir = os.path.join(sw_dir, CLI_dir)
    if not os.path.exists(cli_dir):
        os.makedirs(cli_dir)
    with open(os.path.join(cli_dir, REG_DEFINES_CLI.format(P4_SWITCH)), 'w') as f:
        f.write(contents)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('P4_SWITCH_dir', type=str, help="the config_writes.txt file")
    parser.add_argument('templates_dir', type=str, help="the base address of the P4_SWITCH")
    parser.add_argument('testdata_dir', type=str, help="the testdata directory to put the P4_SWITCH_reg_defines.py file")
    parser.add_argument('sw_dir', type=str, help="the software directory that will contain the auto generated API folder")
    parser.add_argument('--base_address', type=str, default="0x44020000", help="the base address of the P4_SWITCH module")
    args = parser.parse_args()

    P4_SWITCH = os.path.basename(os.path.normpath(args.P4_SWITCH_dir))

    find_p4_regs(args.P4_SWITCH_dir)

    print "p4_regs = ", str(p4_regs)

    get_address_offset(args.P4_SWITCH_dir, P4_SWITCH)
    fill_regs_dict()
    make_regs_gen_scripts(args.templates_dir, args.P4_SWITCH_dir, P4_SWITCH) 
    make_reg_extern_modules(args.templates_dir, args.P4_SWITCH_dir)
    consolidate_reg_defines(args.P4_SWITCH_dir, args.testdata_dir, int(args.base_address,0), P4_SWITCH) 
    create_reg_API_file(args.P4_SWITCH_dir, args.sw_dir, int(args.base_address,0), P4_SWITCH)
    create_reg_CLI_file(args.P4_SWITCH_dir, args.sw_dir, int(args.base_address,0), P4_SWITCH)

if __name__ == "__main__":
    main()


