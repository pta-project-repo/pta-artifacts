#!/usr/bin/python

import os
import sys
import subprocess
import math
import re

pkgen_size = 256
pktgen_batchs = 1
pkgen_pkts = 1

max_assertions = 50
max_assumptions = 50

# set the environment
def set_env(env):
    env[0] = os.getenv("SDE")
    env[1] = os.getenv("REPO")
    env[2] = str(env[1]) + "/" + "p4v-to-dpv"
    env[3] = str(env[2]) + "/" + "scripts"
    env[4] = str(env[1]) + "/" + "tpg"
    env[5] = str(env[4]) + "/" + "control-plane"
    env[6] = str(env[4]) + "/" + "data-plane"
    env[7] = str(env[1]) + "/" + "put"
    env[8] = str(env[7]) + "/" + "control-plane"
    env[9] = str(env[7]) + "/" + "data-plane"
    env[10] = str(env[1]) + "/" + "opc"
    env[11] = str(env[10]) + "/" + "control-plane"
    env[12] = str(env[10]) + "/" + "data-plane"
    return env

# insert list in list
def listinlist(target, input, entrypoint):
    # iterate over target list
    for line in target:
        # found entrypoint
        if (str(line).find(str(entrypoint)) != -1):
            x = 0
            # insert input lines in target list
            for elem in input:
                # target.insert((target.index(line)+(input.index(elem))+1), elem)
                target.insert((target.index(line)+x+1), elem)
                x += 1
    # return modified list
    return target

# extract pragmas from P4V-annotated code
def extract_pragmas(p4vfile):
    parsed_asm = []
    parsed_asr = []
    asm_cnt = 0
    asr_cnt = 0
    # extract all lines from file
    lines = exctallfile(p4vfile)
    # search for assertions
    for line in lines:
        # found assumption and count is below limit
        if ((asm_cnt < max_assumptions) and (str(line).find("@pragma assume") != -1)):
            # extract assumption
            index = str(line).find("@pragma assume") + 14
            assumption = line[index:]
            # parse assumption
            parsed_asm = parseasmr(asm_cnt, parsed_asm, assumption)
            # increment counter
            asm_cnt = asm_cnt+1
        # found assertion and count is below limit
        elif ((asr_cnt < max_assertions) and (str(line).find("@pragma assert") != -1)):
            # extract assertion
            index = str(line).find("@pragma assert") + 14
            assertion = line[index:]
            # parse assertion
            parsed_asr = parseasmr(asr_cnt, parsed_asr, assertion)
            # increment counter
            asr_cnt = asr_cnt+1
        else:
            # pragma not found or upper limit reached: skip line
            pass
    # remove whitespace, parenthesis and newline
    parsed_asm = cleanparsed(parsed_asm)
    parsed_asr = cleanparsed(parsed_asr)
    # return parsed assumptions and parsed assertions
    return (parsed_asm, parsed_asr)

# extract all lines from file
def exctallfile(path):
    extlines = []
    # open file
    with open(str(path), "r") as file:
        # extract lines from file
        for line in file:
            extlines.append(line)
    # return extracted lines
    return extlines

# replace string in list
def repstringlist(list, old, new):
    # iterate over list
    for line in list:
        # replace old with new
        if (str(line).find(str(old)) != -1):
            list[list.index(line)] = str(line).replace(str(old), str(new))
    # return modified list
    return list

# write list to file
def listtofile(path, list):
    # open file
    with open(path, "w") as file:
        # write lines to file
        for line in list:
            file.write(line)

# parse assumption/assertion
def parseasmr(i, parsed, asmr):
    # element: leftA, leftOP, leftB, midOP, rightA, rightOP, rightB
    element = ["-1", "-1", "-1", "-1", "-1", "-1", "-1"]
    midOP = "-1"
    left = "-1"
    right = "-1"
    if (str(asmr).find(" && ") != -1):
        mididx = str(asmr).find(" && ")
        element[3] = "&"
        left = asmr[0:(mididx)]
        right = asmr[(mididx+3):]
    elif (str(asmr).find(" or ") != -1):
        mididx = str(asmr).find(" or ")
        element[3] = "|"
        left = asmr[0:(mididx)]
        right = asmr[(mididx+3):]
    # midOP not found
    else:
        left = asmr
    # parse LEFT
    leftel = parselr(left)
    element[0] = leftel[0]
    element[1] = leftel[1]
    element[2] = leftel[2]
    # parse RIGHT
    if(str(element[3]) != "-1"):
        rightel = parselr(right)
        element[4] = rightel[0]
        element[5] = rightel[1]
        element[6] = rightel[2]
    # append element to parsed
    parsed.append(element)
    # return parsed assumption/assertion
    return parsed

# parse left or right
def parselr(exp):
    #              A, OP, B
    elements = ["-1", "-1", "-1"]
    if (str(exp).find("==") != -1):
        index = str(exp).find("==")
        elements[1] = "aEQb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("!=") != -1):
        index = str(exp).find("!=")
        elements[1] = "aNEQb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find(">=") != -1):
        index = str(exp).find(">=")
        elements[1] = "aGTEb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("<=") != -1):
        index = str(exp).find("<=")
        elements[1] = "aLTEb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find(">") != -1):
        index = str(exp).find(">")
        elements[1] = "aGTb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("<") != -1):
        index = str(exp).find("<")
        elements[1] = "aLTb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("+") != -1):
        index = str(exp).find("+")
        elements[1] = "aSUMb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("-") != -1):
        index = str(exp).find("-")
        elements[1] = "aSUBb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("&&") != -1):
        index = str(exp).find("&&")
        elements[1] = "aANDb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("or") != -1):
        index = str(exp).find("or")
        elements[1] = "aORb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    elif (str(exp).find("^") != -1):
        index = str(exp).find("^")
        elements[1] = "aXORb"
        elements[0] = exp[0:(index-1)]
        elements[2] = exp[(index+2):]
    else:
        elements[0] = str(exp)
    return elements

# remove whitespace, parenthesis and newline
def cleanparsed(prsd):
    # counters: open, close
    counter = [0, 0]
    # iterate over parsed assumptions/assertions
    for element in prsd:
        # iterate over fields of each element
        for j in range(7):
            # remove newline
            element[j] = str(element[j]).replace('\n','')
            # remove carriage return
            element[j] = str(element[j]).replace('\r','')
            # remove whitespace
            element[j] = str(element[j]).replace(' ','')
            # count parenthesis in sting
            counter[0] = element[j].count('(')
            counter[1] = element[j].count(')')
            # remove parenthesis
            if (counter[0]+counter[1]) == 1:
                element[j] = str(element[j]).replace('(','')
                element[j] = str(element[j]).replace(')','')
            elif counter[0] > counter[1]:
                element[j] = str(element[j][1:])
            elif counter[1] > counter[0]:
                element[j] = str(element[j][:-1])
            else:
                pass
    # return clean parsed assertions
    return prsd

# PUT: comment all @pragmas
def commentpragmas(p4vfile):
    lines = exctallfile(p4vfile)
    lines = repstringlist(lines, "@pragma", "// @pragma")
    listtofile(p4vfile, lines)

# TPG: write header fields
def wrfield(headers, w_value, w_hname, w_fname):
    for col in headers:
        if str(col[0][0]) == str(w_hname):
            for field in col:
                if str(field[0]) == str(w_fname):
                    field[1] = str(w_value)
    return headers

# TPG: search field
def getfield(headers, hname, fname):
    print(headers, hname, fname)
    for col in headers:
        if str(col[0][0]) == str(hname):
            for field in col:
                if str(field[0]) == str(fname):
                    value = field[1]
    return value

# TPG: identify header data
def identify_header_data(env, psdassumptions, headers, headers_sz):
    # read headers.p4
    puthdrs = str(env[9]) + "/include/headers.p4"
    hdrlns = exctallfile(puthdrs)
    # search for header names
    for ln in hdrlns:
        if (str(ln).find("header ") != -1):
            valstrt = (str(ln).find("header ")) + 7
            tidx = str(ln).find("_t")
            hdrval = str(ln[valstrt:tidx]) + "_t"
            hdrname = str(ln[(tidx+3):-2])
            # remove newline
            hdrval = str(hdrval).replace('\n','')
            hdrname = str(hdrname).replace('\n','')
            # remove carriage return
            hdrval = str(hdrval).replace('\r','')
            hdrname = str(hdrname).replace('\r','')
            # remove whitespace
            hdrval = str(hdrval).replace(' ','')
            hdrname = str(hdrname).replace(' ','')
            # remove semicolon
            hdrval = str(hdrval).replace(';','')
            hdrname = str(hdrname).replace(';','')
            # remove colon
            hdrval = str(hdrval).replace(':','')
            hdrname = str(hdrname).replace(':','')
            # remove comma
            hdrval = str(hdrval).replace(',','')
            hdrname = str(hdrname).replace(',','')
            # remove dot
            hdrval = str(hdrval).replace('.','')
            hdrname = str(hdrname).replace('.','')
            headers.append([[str(hdrname), str(hdrval)]])
            headers_sz.append([[str(hdrname), str(hdrval)]])
    # search for fields
    for ln in hdrlns:
        # found a header definition
        if (str(ln).find("header_type ") != -1):
            bgnnbr = hdrlns.index(ln)
            typidx = (str(ln).find("header_type ")) + 12
            nwln = ln[typidx:]
            tidx = str(nwln).find("_t")
            hdrval = str(nwln[0:(tidx)]) + "_t"
            # search for hdrval in headers
            for hdrel in headers:
                if(str(hdrel[0][1]) == str(hdrval)):
                    hdridx = headers.index(hdrel)
            # search for end of header definition
            endnbr = bgnnbr
            while (str(hdrlns[endnbr]).find("}") == -1):
                endnbr = endnbr + 1
            # extract fields
            for lnindex in range(bgnnbr, (endnbr+1)):
                ln2 = str(hdrlns[lnindex])
                if (str(ln2).find(":") != -1):
                    clmidx = (str(ln2).find(":"))
                    fldname = str(ln2[0:clmidx]).replace(' ','')
                    headers[hdridx].append([str(fldname), "-1"])
                    splt = str(ln2[clmidx:]).split()
                    for s in splt:
                        s = str(s).replace(';','')
                        s = str(s).replace('(','')
                        if s.isdigit():
                            fld_sz = int(s)
                    headers_sz[hdridx].append([str(fldname), fld_sz])
    return (headers, headers_sz)

# TPG: set fields based on conditions
def set_fields_cond(psdassumptions, offset, headers):
    for pasm in psdassumptions:
        value = str(pasm[2+offset])
        hname = str(pasm[0+offset][0:(str(pasm[0+offset]).find("."))])
        fname = str(pasm[0+offset][(str(pasm[0+offset]).find("."))+1:])
        # aEQb
        if (str(pasm[1+offset]) == "aEQb"):
            w_value = value
            w_hname = hname
            w_fname = fname
            headers = wrfield(headers, w_value, w_hname, w_fname)
        # aNEQb
        elif (str(pasm[1+offset]) == "aNEQb"):
            # number
            if (str(pasm[2+offset]).isdigit()):
                w_value = int(value) + 1
                w_hname = hname
                w_fname = fname
            # field
            else:
                ha = hname
                fa = fname
                va = getfield(headers, ha, fa)
                hb = str(pasm[2+offset][0:(str(pasm[2+offset]).find("."))])
                fb = str(pasm[2+offset][(str(pasm[2+offset]).find("."))+1:])
                vb = getfield(headers, hb, fb)
                if ((int(va) == -1) and (int(vb) == -1)):
                    va = str(1)
                    headers = wrfield(headers, va, ha, fa)
                    vb = str(3)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) == -1) and (int(vb) != -1)):
                    va = str(int(vb) + 1)
                    headers = wrfield(headers, va, ha, fa)
                elif ((int(va) != -1) and (int(vb) == -1)):
                    vb = str(int(va) + 1)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) != -1) and (int(vb) != -1) and (int(va) == int(vb))):
                    vb = str(int(va) + 1)
                    headers = wrfield(headers, vb, hb, fb)
        # aGT(E)b
        elif ((str(pasm[1+offset]) == "aGTb") or (str(pasm[1+offset]) == "aGTEb")):
            # number
            if (str(pasm[2+offset]).isdigit()):
                w_value = int(value) + 1
                w_hname = hname
                w_fname = fname
            # field
            else:
                ha = hname
                fa = fname
                va = getfield(headers, ha, fa)
                hb = str(pasm[2+offset][0:(str(pasm[2+offset]).find("."))])
                fb = str(pasm[2+offset][(str(pasm[2+offset]).find("."))+1:])
                vb = getfield(headers, hb, fb)
                if ((int(va) == -1) and (int(vb) == -1)):
                    va = str(3)
                    headers = wrfield(headers, va, ha, fa)
                    vb = str(1)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) == -1) and (int(vb) != -1)):
                    va = str(int(vb) + 1)
                    headers = wrfield(headers, va, ha, fa)
                elif ((int(va) != -1) and (int(vb) == -1)):
                    vb = str(int(va) - 1)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) != -1) and (int(vb) != -1) and (int(va) <= int(vb))):
                    va = str(int(vb) + 1)
                    headers = wrfield(headers, va, ha, fa)
        # aLT(E)b
        elif ((str(pasm[1+offset]) == "aLTb") or (str(pasm[1+offset]) == "aLTEb")):
            # number
            if (str(pasm[2+offset]).isdigit()):
                w_value = int(value) - 1
                w_hname = hname
                w_fname = fname
            # field
            else:
                ha = hname
                fa = fname
                va = getfield(headers, ha, fa)
                hb = str(pasm[2+offset][0:(str(pasm[2+offset]).find("."))])
                fb = str(pasm[2+offset][(str(pasm[2+offset]).find("."))+1:])
                vb = getfield(headers, hb, fb)
                if ((int(va) == -1) and (int(vb) == -1)):
                    va = str(1)
                    headers = wrfield(headers, va, ha, fa)
                    vb = str(3)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) == -1) and (int(vb) != -1)):
                    va = str(int(vb) - 1)
                    headers = wrfield(headers, va, ha, fa)
                elif ((int(va) != -1) and (int(vb) == -1)):
                    vb = str(int(va) + 1)
                    headers = wrfield(headers, vb, hb, fb)
                elif ((int(va) != -1) and (int(vb) != -1) and (int(va) >= int(vb))):
                    va = str(int(vb) - 1)
                    headers = wrfield(headers, va, ha, fa)

# TPG: set missing values
def set_missing_vals(headers):
    for col in headers:
        for field in col:
            if (str(field[1]) <= "-1"):
                field[1] = str(1)
    return headers

# TPG: write to tpg.p4
def wr_tpg_p4(environment, headers):
    filelines = exctallfile(str(environment[6]) + "/" + "tpg.p4")
    # parser
    newlines = []
    for col in headers:
        newlines.append("\textract(" + str(col[0][0]) + ");\n")
    filelines = listinlist(filelines, newlines, "@DPV tpg parser begin")
    # M/A: set_hdr
    newlines = []
    for col in headers:
        for field in col:
            if field == col[0]:
                newlines.append("\tadd_header(" + str(col[0][0]) + ");\n")
            else:
                newlines.append("\tmodify_field(" + str(col[0][0]) + "." + str(field[0]) + ", " + str(field[1]) + ");\n")
    filelines = listinlist(filelines, newlines, "@DPV tpg sethdr begin")
    # write lines to file
    listtofile(str(environment[6]) + "/" + "tpg.p4", filelines)

# TPG: prepare config data
def prep_tpg_config_data(config_data):
    reg_num = 0
    reg_idx = 0
    reg_val = 0x01010101
    config_data.append([reg_num, reg_idx, reg_val])
    return config_data

# TPG & OPC: write data to config registers
def wr_config_regs(environment, nbr, config_data):
    filelines = exctallfile(str(environment[nbr]) + "/" + "wr_config_regs" + "/" + "wr_config_regs.py")
    # indexes
    newlines = []
    for elem in config_data:
        newlines.append("        index_" + str(elem[0]) + "_" + str(elem[1]) + " = " + str(elem[1]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs indexes begin")
    # values
    newlines = []
    for elem in config_data:
        newlines.append("        value_" + str(elem[0]) + "_" + str(elem[1]) + " = " + str(elem[2]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs values begin")
    # reg read
    newlines = []
    for elem in config_data:
        # tpg
        if(nbr == 5):
            newlines.append("        self.client.register_hw_sync_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt)\n")
            newlines.append("        sync = tpg_register_flags_t(read_hw_sync = True)\n")
        # opc
        elif(nbr == 11):
            newlines.append("        self.client.register_hw_sync_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt)\n")
            newlines.append("        sync = opc_register_flags_t(read_hw_sync = True)\n")
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + " = " + "self.client.register_read_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt, " + str(elem[1]) + ", sync)" + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs read begin")
    # reuse data
    newlines = []
    for elem in config_data:
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + "[0].f0 = zero_high" + "\n")
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + "[0].f1 = value_" + str(elem[0]) + "_" + str(elem[1]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs data begin")
    # write data to registers
    newlines = []
    for elem in config_data:
        newlines.append("        self.client.register_write_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt, " + str(elem[1]) + ", " + "data_" + str(elem[0]) + "_" + str(elem[1]) + "[0]" + ")" + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs write begin")
    # write lines to file
    listtofile(str(environment[nbr]) + "/" + "wr_config_regs" + "/" + "wr_config_regs.py", filelines)

# TPG: compute header size
def cmp_hdr_sz(env):
    # read headers.p4
    puthdrs = str(env[9]) + "/include/headers.p4"
    lines = exctallfile(puthdrs)
    hdrsz = 0
    for ln in lines:
        if (str(ln).find(":") != -1):
            clm = str(ln).find(":")
            splt = str(ln[clm:]).split()
            for s in splt:
                s = str(s).replace(';','')
                s = str(s).replace('(','')
                if s.isdigit():
                    hdrsz = hdrsz + int(s)
    return (hdrsz/8)

# TPG: prepare pktgen_config
def prep_pktgen_config(environment, pktgen_config):
    hdrsz = cmp_hdr_sz(environment)
    pktsz = pkgen_size # 256
    numbtcs = pktgen_batchs
    ibgnano = 100
    numpkts = pkgen_pkts
    ipgnano = 100
    pktgen_config.append([hdrsz, pktsz, numbtcs, ibgnano, numpkts, ipgnano])
    return pktgen_config

# TPG: configure pktgen
def wr_pktgen_config(environment, pktgen_config):
    filelines = exctallfile(str(environment[4]) + "/" + "pktgen" + "/" + "pktgen.py")
    # pktsz
    newlines = []
    newlines.append("        pktsz = " + str(pktgen_config[0][1]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen pktsz begin")
    # hdrsz
    newlines = []
    newlines.append("        hdrsz = " + str(pktgen_config[0][0]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen hdrsz begin")
    # numbtcs
    newlines = []
    newlines.append("        numbtcs = " + str(pktgen_config[0][2]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen numbtcs begin")
    # ibgnano
    newlines = []
    newlines.append("        ibgnano = " + str(pktgen_config[0][3]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen ibgnano begin")
    # numpkts
    newlines = []
    newlines.append("        numpkts = " + str(pktgen_config[0][4]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen numpkts begin")
    # ipgnano
    newlines = []
    newlines.append("        ipgnano = " + str(pktgen_config[0][5]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV pktgen ipgnano begin")
    # write lines to file
    listtofile(str(environment[4]) + "/" + "pktgen" + "/" + "pktgen.py", filelines)

# OPC: write flags in metadata.p4
def wr_opc_flags(environment, headers_sz, neg_fields):
    if not neg_fields:
        pass
    else:
        filelines = exctallfile(str(environment[12]) + "/" + "include" + "/" + "metadata.p4")
        newlines = []
        newlines.append("header_type dpv_flags_t {\n")
        newlines.append("\tfields {\n")
        for line in headers_sz:
            for field in line:
                if (str(field[1]).find("_t") != -1):
                    hdr_name = str(field[0])
                else:
                    fieldname = str(hdr_name) + "_" + str(field[0])
                    for nf in neg_fields:
                        if (str(fieldname) == str(nf)):
                            newlines.append("\t\t" + str(fieldname) + ": " + str(8) + ";\n")
        newlines.append("\t}\n")
        newlines.append("}\n")
        newlines.append("metadata dpv_flags_t dpv_flags;\n")
        filelines = listinlist(filelines, newlines, "@DPV meta flags begin")
        # write lines to file
        listtofile(str(environment[12]) + "/" + "include" + "/" + "metadata.p4", filelines)

# OPC: write conf in metadata.p4
def wr_opc_conf(environment, neg_fields):
    if not neg_fields:
        pass
    else:
        qoz = (len(neg_fields)/8)
        res = (len(neg_fields)%8)
        filelines = exctallfile(str(environment[12]) + "/" + "include" + "/" + "metadata.p4")
        newlines = []
        newlines.append("header_type dpv_conf_t {\n")
        newlines.append("\tfields {\n")
        i = 0
        for reg in range(qoz):
            newlines.append("\t\tcfg_" + str(i) + ": " + str(8) + ";\n")
            i = i + 1
        if (res != 0):
            newlines.append("\t\tcfg_" + str(i) + ": " + str(8) + ";\n")
        newlines.append("\t}\n")
        newlines.append("}\n")
        newlines.append("metadata dpv_conf_t dpv_conf;\n")
        filelines = listinlist(filelines, newlines, "@DPV meta config begin")
        # write lines to file
        listtofile(str(environment[12]) + "/" + "include" + "/" + "metadata.p4", filelines)

# # OPC: prepare condition string
# def prep_conds(assertion, offset, lowhi, posneg):
#     if (str(posneg) == "pos"):
#         if(str(assertion[1+offset]) == "aEQb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " == 0;"
#         elif(str(assertion[1+offset]) == "aNEQb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " != 0;"
#         elif(str(assertion[1+offset]) == "aGTb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " > 0;"
#         elif(str(assertion[1+offset]) == "aGTEb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " >= 0;"
#         elif(str(assertion[1+offset]) == "aLTb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " < 0;"
#         elif(str(assertion[1+offset]) == "aLTEb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " <= 0;"
#     elif (str(posneg) == "neg"):
#         if(str(assertion[1+offset]) == "aEQb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " == 0;"
#         elif(str(assertion[1+offset]) == "aNEQb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " != 0;"
#         elif(str(assertion[1+offset]) == "aGTb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " < 0;"
#         elif(str(assertion[1+offset]) == "aGTEb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " <= 0;"
#         elif(str(assertion[1+offset]) == "aLTb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " > 0;"
#         elif(str(assertion[1+offset]) == "aLTEb"):
#             string = "condition_" + str(lowhi) + ": " + str(assertion[0+offset]) + " >= 0;"
#     return string

# OPC: generate ones for computing XOR
def allones(assertion, offset, headers_sz):
    for row in headers_sz:
        for elem in row:
            if (str(assertion[0+offset]) == str(row[0][0]) + "." + str(elem[0])):
                size = elem[1]
                binstr = ""
                for x in range((size)):
                    binstr = str(binstr) + str(1)
                decimal = 0
                position = 0
                for digit in binstr:
                    decimal = decimal + (int(digit) * pow(2, position))
                    position = position + 1
    return decimal

# OPC: fill XOR INC snippets
def fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, offset, neg_fields):
    asr_str = str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):])
    neg_fields.append(asr_str)
    snp_xor.append("\naction act_xor_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + "() {\n")
    snp_xor.append("\tbit_xor(" + str(assertion[offset]) + ", " + str(assertion[offset]) + ", " + str(allones(assertion, offset, headers_sz)) + ");\n")
    snp_xor.append("}\n")
    snp_xor.append("table xor_tbl_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + " {\n")
    snp_xor.append("\tactions {\n")
    snp_xor.append("\t\tact_xor_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + ";\n")
    snp_xor.append("\t}\n")
    snp_xor.append("\tdefault_action : act_xor_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + ";\n")
    snp_xor.append("}\n")
    snp_inc.append("\naction act_inc_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + "() {\n")
    snp_inc.append("\tadd_to_field(" + str(assertion[offset]) + ", 1);\n")
    snp_inc.append("}\n")
    snp_inc.append("table inc_tbl_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + " {\n")
    snp_inc.append("\tactions {\n")
    snp_inc.append("\t\tact_inc_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + ";\n")
    snp_inc.append("\t}\n")
    snp_inc.append("\tdefault_action : act_inc_" + str(assertion[offset][:(str(assertion[offset]).find("."))]) + "_" + str(assertion[offset][(str(assertion[offset]).find(".") + 1):]) + ";\n")
    snp_inc.append("}\n")
    return(snp_xor, snp_inc, neg_fields)

# OPC: populate checkreg snippet
def pop_chkreg(environment, snippet, snp_xor, snp_inc, assertion, index, headers_sz, type, neg_fields):
    chkreg_lines = exctallfile(str(environment[2]) + "/" + "templates" + "/" + "opc_checkreg.tpt")
    if (str(type) == "seqnq"):
        snippet.append("// >>>>>>>>> CHECK REG:" + str(index) + " SINGLE" + "\n")
        snippet = listinlist(snippet, chkreg_lines, "CHECK REG:")
        snippet = repstringlist(snippet, "<DPV_REG_NUM>", str(index))
        snippet = repstringlist(snippet, "<DPV_TYPE>", "SINGLE")
        snippet = repstringlist(snippet, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snippet = repstringlist(snippet, "<DPV_COND_HI>", "// <DPV_COND_HI>")
        snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo;")
    elif (str(type) == "sgtlt"):
        # pos
        snp_pos = []
        snp_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " SINGLE_POS" + "\n")
        snp_pos = listinlist(snp_pos, chkreg_lines, "CHECK REG:")
        snp_pos = repstringlist(snp_pos, "<DPV_REG_NUM>", str(index))
        snp_pos = repstringlist(snp_pos, "<DPV_TYPE>", "SINGLE_POS")
        snp_pos = repstringlist(snp_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos = repstringlist(snp_pos, "<DPV_COND_HI>", "// <DPV_COND_HI>")
        snp_pos = repstringlist(snp_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo;")
        # neg
        snp_neg = []
        snp_neg.append("// >>>>>>>>> CHECK REG:" + str(index) + " SINGLE_NEG" + "\n")
        snp_neg = listinlist(snp_neg, chkreg_lines, "CHECK REG:")
        snp_neg = repstringlist(snp_neg, "<DPV_REG_NUM>", str(index))
        snp_neg = repstringlist(snp_neg, "<DPV_TYPE>", "SINGLE_NEG")
        snp_neg = repstringlist(snp_neg, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "neg"))
        snp_neg = repstringlist(snp_neg, "<DPV_COND_HI>", "// <DPV_COND_HI>")
        snp_neg = repstringlist(snp_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo;")
        (snp_xor, snp_inc, neg_fields) = fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, 0, neg_fields)
        # snippet
        snippet = snp_pos + snp_neg
    elif (str(type) == "deqnqeqnq"):
        snippet.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE" + "\n")
        snippet = listinlist(snippet, chkreg_lines, "CHECK REG:")
        snippet = repstringlist(snippet, "<DPV_REG_NUM>", str(index))
        snippet = repstringlist(snippet, "<DPV_TYPE>", "DOUBLE")
        snippet = repstringlist(snippet, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snippet = repstringlist(snippet, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
    elif (str(type) == "deqnqgtlt"):
        # pos pos
        snp_pos_pos = []
        snp_pos_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_POS_POS" + "\n")
        snp_pos_pos = listinlist(snp_pos_pos, chkreg_lines, "CHECK REG:")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_REG_NUM>", str(index))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_TYPE>", "DOUBLE_POS_POS")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        # pos neg
        snp_pos_neg = []
        snp_pos_neg.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_POS_NEG" + "\n")
        snp_pos_neg = listinlist(snp_pos_neg, chkreg_lines, "CHECK REG:")
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_REG_NUM>", str(index))
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_TYPE>", "DOUBLE_POS_NEG")
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "neg"))
        if (str(assertion[3]) == "&"):
            snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        (snp_xor, snp_inc, neg_fields) = fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, 4, neg_fields)
        # snippet
        snippet = snp_pos_pos + snp_pos_neg
    elif (str(type) == "dgtlteqnq"):
        # neg pos
        snp_neg_pos = []
        snp_neg_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_NEG_POS" + "\n")
        snp_neg_pos = listinlist(snp_neg_pos, chkreg_lines, "CHECK REG:")
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_REG_NUM>", str(index))
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_TYPE>", "DOUBLE_NEG_POS")
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "neg"))
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        (snp_xor, snp_inc, neg_fields) = fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, 0, neg_fields)
        # pos pos
        snp_pos_pos = []
        snp_pos_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_POS_POS" + "\n")
        snp_pos_pos = listinlist(snp_pos_pos, chkreg_lines, "CHECK REG:")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_REG_NUM>", str(index))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_TYPE>", "DOUBLE_POS_POS")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        # snippet
        snippet = snp_neg_pos + snp_pos_pos
    elif (str(type) == "dgtltgtlt"):
        # pos pos
        snp_pos_pos = []
        snp_pos_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_POS_POS" + "\n")
        snp_pos_pos = listinlist(snp_pos_pos, chkreg_lines, "CHECK REG:")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_REG_NUM>", str(index))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_TYPE>", "DOUBLE_POS_POS")
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_pos_pos = repstringlist(snp_pos_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        # pos neg
        snp_pos_neg = []
        snp_pos_neg.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_POS_NEG" + "\n")
        snp_pos_neg = listinlist(snp_pos_neg, chkreg_lines, "CHECK REG:")
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_REG_NUM>", str(index))
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_TYPE>", "DOUBLE_POS_NEG")
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "pos"))
        snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "neg"))
        if (str(assertion[3]) == "&"):
            snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_pos_neg = repstringlist(snp_pos_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        # neg pos
        snp_neg_pos = []
        snp_neg_pos.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_NEG_POS" + "\n")
        snp_neg_pos = listinlist(snp_neg_pos, chkreg_lines, "CHECK REG:")
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_REG_NUM>", str(index))
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_TYPE>", "DOUBLE_NEG_POS")
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "neg"))
        snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "pos"))
        if (str(assertion[3]) == "&"):
            snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_neg_pos = repstringlist(snp_neg_pos, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        # neg neg
        snp_neg_neg = []
        snp_neg_neg.append("// >>>>>>>>> CHECK REG:" + str(index) + " DOUBLE_NEG_NEG" + "\n")
        snp_neg_neg = listinlist(snp_neg_neg, chkreg_lines, "CHECK REG:")
        snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_REG_NUM>", str(index))
        snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_TYPE>", "DOUBLE_NEG_NEG")
        snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo", "neg"))
        snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi", "neg"))
        if (str(assertion[3]) == "&"):
            snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snp_neg_neg = repstringlist(snp_neg_neg, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
        (snp_xor, snp_inc, neg_fields) = fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, 0, neg_fields)
        (snp_xor, snp_inc, neg_fields) = fill_xor_inc(snp_xor, snp_inc, headers_sz, assertion, 4, neg_fields)
        # snippet
        snippet = snp_pos_pos + snp_pos_neg + snp_neg_pos + snp_neg_neg
    return (snippet, snp_xor, snp_inc, neg_fields)

# OPC: prepare condition string
def prep_conds(assertion, offset, type):
    if(str(assertion[1+offset]) == "aEQb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " == 0;"
    elif(str(assertion[1+offset]) == "aNEQb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " != 0;"
    elif(str(assertion[1+offset]) == "aGTb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " > 0;"
    elif(str(assertion[1+offset]) == "aGTEb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " >= 0;"
    elif(str(assertion[1+offset]) == "aLTb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " < 0;"
    elif(str(assertion[1+offset]) == "aLTEb"):
        string = "condition_" + str(type) + ": " + str(assertion[0+offset]) + " <= 0;"
    return string

# OPC: prepare code snippet
def prepare_chkreg(assertion, idx, chkreg_lines, snippet):
    # reg num
    snippet = repstringlist(chkreg_lines, "<DPV_REG_NUM>", str(idx))
    # single cond
    if (str(assertion[3]) == "-1"):
        snippet = repstringlist(snippet, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo"))
        snippet = repstringlist(snippet, "<DPV_COND_HI>", "// <DPV_COND_HI>")
        snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo;")
    # double cond
    else:
        snippet = repstringlist(snippet, "<DPV_COND_LOW>", prep_conds(assertion, 0, "lo"))
        snippet = repstringlist(snippet, "<DPV_COND_HI>", prep_conds(assertion, 4, "hi"))
        if (str(assertion[3]) == "&"):
            snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo and condition_hi;")
        elif (str(assertion[3]) == "|"):
            snippet = repstringlist(snippet, "<DPV_UPD_LOW>", "update_lo_1_predicate: condition_lo or condition_hi;")
    return snippet

# OPC: write data to opc.p4
def wr_opc_config(environment, psdassertions, headers):
    # OPC Template
    opc_lines = exctallfile(str(environment[12]) + "/" + "opc.p4")
    # parser
    snippet = []
    for col in headers:
        snippet.append("\textract(" + str(col[0][0]) + ");\n")
    opc_lines = listinlist(opc_lines, snippet, "@DPV opc parser begin")
    # subtract actions
    snippet = []
    for assertion in psdassertions:
        # sub 1
        if (str(assertion[0]) != "-1" and str(assertion[2]) != "-1"):
            snippet.append("\tsubtract_from_field(" + str(assertion[0]) + ", " + str(assertion[2]) + ");\n")
        # sub 2
        if (str(assertion[4]) != "-1" and str(assertion[6]) != "-1"):
            snippet.append("\tsubtract_from_field(" + str(assertion[4]) + ", " + str(assertion[6]) + ");\n")
    opc_lines = listinlist(opc_lines, snippet, "@DPV opc sub_flds begin")
    # check regs
    i = 0
    for assertion in psdassertions:
        # OPC CheckREG Template
        snippet = []
        chkreg_lines = exctallfile(str(environment[2]) + "/" + "templates" + "/" + "opc_checkreg.tpt")
        snippet.append("// >>>>>>>>> CHECK REG:" + str(i) + "\n")
        snippet = listinlist(snippet, prepare_chkreg(assertion, i, chkreg_lines, snippet), "CHECK REG:")
        # add snippet to opc chkreg_lines
        opc_lines = listinlist(opc_lines, snippet, "@DPV opc check_regs begin")
        i = i + 1
    # M/A: Checks
    snippet = []
    i = 0
    for assertion in psdassertions:
        snippet.append("\tapply(check_tbl_" + str(i) + ");\n")
        i = i + 1
    opc_lines = listinlist(opc_lines, snippet, "@DPV opc checks begin")
    # write lines to file
    listtofile(str(environment[12]) + "/" + "opc.p4", opc_lines)

# OPC: convert to decimal
def bin_to_dec(psdassertions):
    for ass in psdassertions:
        for elem in ass:
            if (str(elem).find("0b") != -1):
                binstr = elem[(str(elem).find("0b") + 2):]
                binstr = ''.join(reversed(binstr))
                decimal = 0
                position = 0
                for digit in binstr:
                    decimal = decimal + (int(digit) * pow(2, position))
                    position = position + 1
                new_ass = ass
                new_ass[ass.index(elem)] = str(decimal)
                psdassertions[psdassertions.index(ass)] = new_ass
    return psdassertions

# OPC: identify destination
def idf_dst(string):
    string = str(string).replace(' ','')
    string = str(string).replace(',','')
    string = str(string).replace(';','')
    string = str(string).replace('\n','')
    string = str(string).replace('(','')
    string = str(string).replace(')','')
    return string

# OPC: identify field value
def idf_val(headers, string):
    value = "nf"
    string = str(string).replace(' ','')
    string = str(string).replace(',','')
    string = str(string).replace(';','')
    string = str(string).replace('\n','')
    string = str(string).replace('(','')
    string = str(string).replace(')','')
    for line in headers:
        for elem in line:
            if (str(string) == (str(line[0][0]) + "." + str(elem[0]))):
                value = str(elem[1])
    return value

# OPC: identify number
def idf_nbr(string):
    string = str(string).replace(' ','')
    string = str(string).replace(',','')
    string = str(string).replace(';','')
    string = str(string).replace('\n','')
    string = str(string).replace('(','')
    string = str(string).replace(')','')
    if string.isdigit():
        return string
    else:
        return "nf"

# OPC: update status
def upd_status(status, dest, val, fo, fv):
    lidx = 0
    for line in status:
        eidx = 0
        for elem in line:
            if (str(dest) == (str(line[0][0][0]) + "." + str(elem[0]))):
                status[lidx][eidx][1] = str((int(status[lidx][eidx][1])*int(fo)) + (int(val)*int(fv)))
            eidx = eidx + 1
        lidx = lidx + 1
    return status

# OPC: find val
def find_val(status, line, val):
    if (str(idf_val(status, str(line[str(line).find(","):]))) != "nf"):
        val = int(idf_val(status, str(line[str(line).find(","):])))
    elif (str(idf_nbr(str(line[str(line).find(","):]))) != "nf"):
        val = int(idf_nbr(str(line[str(line).find(","):])))
    return(line, val)

# OPC: convert binstring to decimal
def btd(binstr):
    binstr = ''.join(reversed(binstr))
    decimal = 0
    position = 0
    for digit in binstr:
        decimal = decimal + (int(digit) * pow(2, position))
        position = position + 1
    return decimal

# OPC: prepare config data
def prep_opc_config_data(config_data):
    reg_num = 0
    reg_idx = 0
    reg_val = 0x01010101
    config_data.append([reg_num, reg_idx, reg_val])
    return config_data

# OPC: write data to config registers
def wr_config_regs_opc(environment, nbr, config_data):
    filelines = exctallfile(str(environment[nbr]) + "/" + "wr_config_regs" + "/" + "wr_config_regs.py")
    # indexes
    newlines = []
    for elem in config_data:
        newlines.append("        index_" + str(elem[0]) + "_" + str(elem[1]) + " = " + str(elem[1]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs indexes begin")
    # values
    newlines = []
    for elem in config_data:
        newlines.append("        value_" + str(elem[0]) + "_" + str(elem[1]) + " = " + str(elem[2]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs values begin")
    # reg read
    newlines = []
    for elem in config_data:
        # tpg
        if(nbr == 5):
            newlines.append("        self.client.register_hw_sync_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt)\n")
            newlines.append("        sync = tpg_register_flags_t(read_hw_sync = True)\n")
        # opc
        elif(nbr == 11):
            newlines.append("        self.client.register_hw_sync_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt)\n")
            newlines.append("        sync = opc_register_flags_t(read_hw_sync = True)\n")
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + " = " + "self.client.register_read_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt, " + str(elem[1]) + ", sync)" + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs read begin")
    # reuse data
    newlines = []
    for elem in config_data:
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + "[0].f0 = zero_high" + "\n")
        newlines.append("        data_" + str(elem[0]) + "_" + str(elem[1]) + "[0].f1 = value_" + str(elem[0]) + "_" + str(elem[1]) + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs data begin")
    # write data to registers
    newlines = []
    for elem in config_data:
        newlines.append("        self.client.register_write_config_reg_" + str(elem[0]) + "(self.sess_hdl, self.dev_tgt, " + str(elem[1]) + ", " + "data_" + str(elem[0]) + "_" + str(elem[1]) + "[0]" + ")" + "\n")
    filelines = listinlist(filelines, newlines, "@DPV wr_config_regs write begin")
    # write lines to file
    listtofile(str(environment[nbr]) + "/" + "wr_config_regs" + "/" + "wr_config_regs.py", filelines)

# OPC: read data from result registers
def rd_res_regs(environment, psdassertions):
    filelines = exctallfile(str(environment[11]) + "/" + "rd_res_regs" + "/" + "rd_res_regs.py")
    # reg read
    newlines = []
    index = 0
    for asrt in psdassertions:
        newlines.append("        self.client.register_hw_sync_check_reg_" + str(index) + "(self.sess_hdl, self.dev_tgt)\n")
        newlines.append("        sync = opc_register_flags_t(read_hw_sync = True)\n")
        newlines.append("        data_" + str(index) + " = " + "self.client.register_read_check_reg_" + str(index) + "(self.sess_hdl, self.dev_tgt, " + str(0) + ", sync)" + "\n")
        newlines.append("        print(\"RESULT" + str(index) + "$\", data_" + str(index) + ")\n")
        newlines.append("        print(\"" + "\\" + "n" + "\")\n")
        index = index + 1
    filelines = listinlist(filelines, newlines, "@DPV rd_res_regs read begin")
    # write lines to file
    listtofile(str(environment[11]) + "/" + "rd_res_regs" + "/" + "rd_res_regs.py", filelines)

# PUT: remove "saturating" attribute
def rmv_sat(env):
    # read headers.p4
    puthdrs = str(env[3]) + "/data-plane/include/headers.p4"
    hdrlns = exctallfile(puthdrs)
    # search for header names
    for ln in hdrlns:
        if (str(ln).find("header ") != -1):
            valstrt = (str(ln).find("header ")) + 7
            tidx = str(ln).find("_t")
            hdrval = str(ln[valstrt:tidx]) + "_t"
            hdrname = str(ln[(tidx+3):-2])
    # search for fields
    for ln in hdrlns:
        # found a header definition
        if (str(ln).find("header_type ") != -1):
            bgnnbr = hdrlns.index(ln)
            typidx = (str(ln).find("header_type ")) + 12
            nwln = ln[typidx:]
            tidx = str(nwln).find("_t")
            hdrval = str(nwln[0:(tidx)]) + "_t"
            # search for end of header definition
            endnbr = bgnnbr
            while (str(hdrlns[endnbr]).find("}") == -1):
                endnbr = endnbr + 1
            # extract fields
            for ln2 in hdrlns:
                if ((hdrlns.index(ln2) >= bgnnbr) and (hdrlns.index(ln2) <= endnbr) and (str(ln2).find(":") != -1)):
                    clmidx = (str(ln2).find(":"))
                    line = str(ln2[(str(ln2).find(":")):(str(ln2).find(";"))])
                    line = str(line[(str(line).find("(")):(str(line).find(";"))])
                    # signed and saturating
                    if ((str(line).find("signed") != -1) and (str(line).find("saturating") != -1)):
                        newline = str(ln2[:(str(ln2).find("(")-1)]) + " (signed);" + " // saturating\n"
                        repstringlist(hdrlns, ln2, newline)
                    # signed only
                    elif ((str(line).find("signed") != -1) and (str(line).find("saturating") == -1)):
                        pass
                    # saturating only
                    elif ((str(line).find("signed") == -1) and (str(line).find("saturating") != -1)):
                        newline = str(ln2[:(str(ln2).find("(")-1)]) + ";" + " // saturating\n"
                        repstringlist(hdrlns, ln2, newline)
                    # unsigned and not saturating (default)
                    else:
                        pass
    # write to header file
    listtofile(puthdrs, hdrlns)
