#!/usr/bin/python

import os
import sys
import subprocess
import math
import re
import library

def main():
    # environment: SDE   REPO   P4VDPV   P4VDPVSP   TPG   TPGCP   TPGDP   PUT   PUTCP   PUTDP   OPC   OPCCP   OPCDP
    #       index:  0     1        2        3        4      5       6      7      8       9      10    11      12
    environment = [ "",   "",     "",       "",      "",    "",    "",    "",    "",     "",    "",    "",     "" ]
    environment = library.set_env(environment)
    p4vfile = str(environment[9]) + "/" + "put.p4"
    # reset code
    subprocess.call([str(environment[3]) + "/" + "./reset_code.sh"])

    print("*********************************")
    print("              PUT                ")
    print("*********************************")
    # comment all @pragmas
    library.commentpragmas(p4vfile)
    # extract pragmas
    (psdassumptions, psdassertions) = library.extract_pragmas(p4vfile)
    #TODO: generate control plane
    print("*********************************")
    print("              TPG                ")
    print("*********************************")
    # print parsed assumptions
    print("PARSED ASSUMPTIONS:")
    for asm in psdassumptions:
        print(asm)
    print("\n")
    asm_headers = []
    headers_sz = []
    # identify header data
    (asm_headers, headers_sz) = library.identify_header_data(environment, psdassumptions, asm_headers, headers_sz)
    # LEFT: set fields based on conditions
    library.set_fields_cond(psdassumptions, 0, asm_headers)
    # RIGHT: set fields based on conditions
    library.set_fields_cond(psdassumptions, 4, asm_headers)
    # TODO: check AND/OR conditions
    # set missing values
    library.set_missing_vals(asm_headers)
    # print header data
    print("HEADERS TO BE GENERATED:")
    for x in asm_headers:
        print(x)
    print("\n")
    # write to tpg.p4
    library.wr_tpg_p4(environment, asm_headers)
    # prepare config data
    tpg_config_data = []
    tpg_config_data = library.prep_tpg_config_data(tpg_config_data)
    # write data to config registers
    library.wr_config_regs(environment, 5, tpg_config_data)
    # prepare pktgen_config
    pktgen_config = []
    pktgen_config = library.prep_pktgen_config(environment, pktgen_config)
    # print pktgen config
    print("PKTGEN CONFIGURATION:")
    print("hsz, psz, btc, ibg, pkt, ipg")
    for x in pktgen_config:
        print(x)
    print("\n")
    # write data to pktgen
    library.wr_pktgen_config(environment, pktgen_config)
    print("*********************************")
    print("              OPC                ")
    print("*********************************")
    # convert assertions to decimal
    psdassertions = library.bin_to_dec(psdassertions)
    # print parsed assertions
    print("PARSED ASSERTIONS:")
    for asr in psdassertions:
        print(asr)
    print("\n")
    # write data to opc.p4
    library.wr_opc_config(environment, psdassertions, asm_headers)
    # prepare config data
    opc_config_data = []
    opc_config_data = library.prep_opc_config_data(opc_config_data)
    # write data to config registers
    library.wr_config_regs(environment, 11, opc_config_data)
    # read data from result registers
    library.rd_res_regs(environment, psdassertions)

    # EXIT
    exit(0)

if __name__ == '__main__':
    main()
