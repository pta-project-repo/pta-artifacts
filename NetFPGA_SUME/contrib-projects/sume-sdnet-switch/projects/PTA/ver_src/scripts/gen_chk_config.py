#!/usr/bin/python

import os
import sys
import subprocess
import math

import library

# constraints
max_stages = 8
max_sume_meta = 15
max_user_meta = 24
max_assertions = 8
max_assumptions = 100

# directories
controlplane = "../controlplane"
dataplane = "../dataplane"
scripts = "./"
templates = "../templates"

# extract pragmas from P4V-annotated code
def extract_pragmas(p4vfile):
    parsed_asm = []
    parsed_asr = []
    asm_cnt = 0
    asr_cnt = 0
    # extract all lines from file
    lines = library.exctallfile(p4vfile)
    # search for assertions
    for line in lines:
        # found assumption and count is below limit
        if ((asm_cnt < max_assumptions) and (str(line).find("@pragma assume") != -1)):
            # extract assumption
            index = str(line).find("@pragma assume") + 14
            assumption = line[index:]
            # parse assumption
            parsed_asm = library.parseasmr(asm_cnt, parsed_asm, assumption)
            # increment counter
            asm_cnt = asm_cnt+1
        # found assertion and count is below limit
        elif ((asr_cnt < max_assertions) and (str(line).find("@pragma assert") != -1)):
            # extract assertion
            index = str(line).find("@pragma assert") + 14
            assertion = line[index:]
            # parse assertion
            parsed_asr = library.parseasmr(asr_cnt, parsed_asr, assertion)
            # increment counter
            asr_cnt = asr_cnt+1
        else:
            # pragma not found or upper limit reached: skip line
            pass
    # remove whitespace, parenthesis and newline
    parsed_asm = library.cleanparsed(parsed_asm)
    parsed_asr = library.cleanparsed(parsed_asr)
    # return parsed assumptions and parsed assertions
    return (parsed_asm, parsed_asr)

# map assertions to hardware library
def maptohwlib(psdassertions):
    # hwassertions: type, number, fieldA, fieldB, fieldC
    hwassertions = []
    # counters: A | C | T | P
    counters = [0, 0, 0, 0]
    # iterate over parsed assertions
    for asr in psdassertions:
        # left + right + mid expressions
        if(str(asr[3]) != -1):
            # left
            (hwassertions, counters) = library.mapexp(hwassertions, counters, psdassertions, psdassertions.index(asr), "L")
            # right
            (hwassertions, counters) = library.mapexp(hwassertions, counters, psdassertions, psdassertions.index(asr), "R")
            # mid
            (hwassertions, counters) = library.mapexp(hwassertions, counters, psdassertions, psdassertions.index(asr), "M")
        # only left expression
        else:
            # left
            (hwassertions, counters) = library.mapexp(hwassertions, counters, psdassertions, psdassertions.index(asr), "L")
    # return hwassertions
    return hwassertions

# extract dataplane from mapped
def datafrommap(mapped):
    dataplane = ""
    for stage in mapped:
        dataplane = str(dataplane) + str(stage[0])
    return dataplane

# generate checker's dataplane
def gen_chk_dataplane(pipeline):
    # check pipe length
    if(len(pipeline) > max_stages):
        print("Requested pipeline needs more than " + str(max_stages) + " stages!!! \n")
        print("Implementing pipeline:" + str(pipeline)[0:max_stages] + "\n")
        pipestr = str(pipeline)[0:max_stages]
    else:
        pipestr = str(pipeline)
    # parse pipe
    parsedpipe = library.parsepipe(pipestr)
    # populate externs
    library.popexts(parsedpipe)
    # assign metadata fields
    (assigned_meta, sume_fields, user_fields) = library.meta_assign(parsedpipe)
    # populate variables
    library.popvars(parsedpipe)
    # populate instances
    library.popinsts(parsedpipe)
    # populate stages
    library.popstages(parsedpipe, assigned_meta)
    # print message: SUCCESS!!!
    print("\n\nCODE GENERATED SUCCESSFULLY!!! \n\n")
    # return free meta fields
    return (sume_fields, user_fields)

# generate checker's controlplane
def gen_chk_controlplane(asrlist, sume_fields, user_fields):
    # sume_meta_lines: num | string
    sume_meta_lines = []
    # alu_key_cnt: opa | opb | oper
    alu_key_cnt = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0],[0, 0, 0]]
    # iterate over elements of the list
    for elem in asrlist:
        # stage type: ALU
        if elem[0] == 'A':
            (alu_key_cnt, sume_fields, user_fields, sume_meta_lines) = library.popalu(elem, alu_key_cnt, sume_fields, user_fields, "opa", sume_meta_lines)
            (alu_key_cnt, sume_fields, user_fields, sume_meta_lines) = library.popalu(elem, alu_key_cnt, sume_fields, user_fields, "opb", sume_meta_lines)
            (alu_key_cnt, sume_fields, user_fields, sume_meta_lines) = library.popalu(elem, alu_key_cnt, sume_fields, user_fields, "oper", sume_meta_lines)
        # TODO unsupported stage type: C | T | P
        else:
            pass
    # return meta fields
    return (sume_fields, user_fields, sume_meta_lines)

# round meta fields
def roundmeta(sume_fields, user_fields):
    if (math.modf(sume_fields[0])[0] != 0):
        sume_fields[0] = sume_fields[0] - 0.5
        sume_fields[1] = sume_fields[1] + 0.5
    if (math.modf(user_fields[0])[0] != 0):
        user_fields[0] = user_fields[0] - 0.5
        user_fields[1] = user_fields[1] + 0.5
    return(sume_fields, user_fields)

# update metadata assignements
def updmetaassign(sume_meta_lines):
    # extract lines from meta_assign.txt file
    filelines = library.exctallfile(str(dataplane) + "/" + "meta_assign.txt")
    # iterate over sume_meta_lines
    for smln in sume_meta_lines:
        # change lines
        filelines = library.repstringlist(filelines, ("meta_" + str(smln[0]) + " : FREE") , ("meta_" + str(smln[0]) + " : " + str(smln[1])))
    # write lines to meta_assign.txt file
    library.listtofile(dataplane, "meta_assign.txt", filelines)

def main():
    # rest code
    subprocess.call([scripts + "./reset_code.sh"])
    # check for missing arguments
    if(len(sys.argv) != 2):
        print("\n\nERROR!!! \n")
        print("\n\nExpected one argument: path to P4V-annotated code. \n\n")
        library.printhelp()
        exit(1)
    # set file name
    p4vfile = str(sys.argv[1])
    # extract pragmas from P4V-annotated code
    (psdassumptions, psdassertions) = extract_pragmas(p4vfile)
    # print parsed assumptions
    print("PARSED ASSUMPTIONS:")
    for asm in psdassumptions:
        print(asm)
    print("\n")
    # print parsed assertions
    print("PARSED ASSERTIONS:")
    for asr in psdassertions:
        print(asr)
    print("\n")
    # map assertions to hardware library
    mappedasr = maptohwlib(psdassertions)
    # print mapped assertions
    print("MAPPED ASSERTIONS:")
    for masr in mappedasr:
        print(masr)
    print("\n")
    # extract dataplane from mapped
    dataplanestages = datafrommap(mappedasr)
    # print dataplane configuration
    print("DATA PLANE CONFIGURATION: " + dataplanestages)
    print("\n")
    # generate checker's dataplane
    (sume_fields, user_fields) = gen_chk_dataplane(dataplanestages)
    # round meta fields
    (sume_fields, user_fields) = roundmeta(sume_fields, user_fields)
    # map header fields to 8-bit header fields
    # TODO
    # generate checker's controlplane
    (sume_fields, user_fields, sume_meta_lines) = gen_chk_controlplane(mappedasr, sume_fields, user_fields)
    # update metadata assignements
    updmetaassign(sume_meta_lines)
    # print message: SUCCESS!!!
    print("\n\nCHECKER CONFIGURED SUCCESSFULLY!!! \n\n")
    exit(0)

if __name__ == '__main__':
    main()
