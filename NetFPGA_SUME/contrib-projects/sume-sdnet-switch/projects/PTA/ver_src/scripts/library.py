#!/usr/bin/python

import os
import sys
import subprocess
import math

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

# print help message
def printhelp():
    print("This script extracts assertions from P4V-annotated code \n\n")
    print("and generates the configuration of the checker module (data plane+control plane). \n\n")
    print("!!! WARNING !!!")
    print("The maximum supported length of the pipeline is "  + str(max_stages) + " stages.")
    print("The maximum supported number of assertions is " + str(max_assertions) + ".")
    print("Only the first " + str(max_assertions) + " assertions in the input P4V-annotated program will be processed.")
    print("Additional assertions will be discarded. \n\n")

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

# parse pipe string
def parsepipe(string):
    parsed = [['z', -1], ['z', -1], ['z', -1], ['z', -1], ['z', -1], ['z', -1], ['z', -1], ['z', -1]]
    i = 0
    a = 0
    c = 0
    t = 0
    p = 0
    for chr in string:
        if (chr == 'A'):
            parsed[i][0] = 'a'
            parsed[i][1] = a
            i = i+1
            a = a+1
        elif (chr == 'C'):
            parsed[i][0] = 'c'
            parsed[i][1] = c
            i = i+1
            c = c+1
        elif (chr == 'T'):
            parsed[i][0] = 't'
            parsed[i][1] = t
            i = i+1
            t = t+1
        elif (chr == 'P'):
            parsed[i][0] = 'p'
            parsed[i][1] = p
            i = i+1
            p = p+1
        else:
            print("\n\nERROR!!! \n\n")
            printhelp()
            exit(1)
    return parsed

# extract snippet from file
def exctsnippetfile(dirname, filename, begin, end):
    flag = False
    extlines = []
    # open file
    with open(str(dirname) + "/" + str(filename), "r") as file:
        # iterate over file
        for line in file:
            # found beginning of code snippet
            if (str(line).find(str(begin)) != -1):
                flag = True
            # extract lines in between begin and end
            elif ((str(line).find(str(end)) == -1) and (flag != False)):
                    extlines.append(line)
            # found end of code snippet
            elif (str(line).find(str(end)) != -1):
                    flag = False
            # skip other lines
            else:
                pass
        # reset file pointer
        file.seek(0)
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

# insert list in list
def listinlist(target, input, entrypoint):
    # iterate over target list
    for line in target:
        # found entrypoint
        if (str(line).find(str(entrypoint)) != -1):
            x = 0
            # insert input lines in target list
            for elem in input:
                target.insert((target.index(line)+(input.index(elem))+1), elem)
                x += 1
    # return modified list
    return target

# write list to file
def listtofile(dirname, filename, list):
    # open file
    with open(str(dirname) + "/" + str(filename), "w") as file:
        # write lines to file
        for line in list:
            file.write(line)

# populate externs
def popexts(pipe):
    # iterate over stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # ALU stage
        elif(stage[0] == 'a'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "externs.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "externs.txt", "@pta tempext alu begin", "@pta tempext alu end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta extern alu begin")
            # write lines to p4 file
            listtofile(dataplane, "externs.p4", filelines)
        # CAM stage
        elif(stage[0] == 'c'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "externs.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "externs.txt", "@pta tempext cam begin", "@pta tempext cam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta extern cam begin")
            # write lines to p4 file
            listtofile(dataplane, "externs.p4", filelines)
        # TCAM stage
        elif(stage[0] == 't'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "externs.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "externs.txt", "@pta tempext tcam begin", "@pta tempext tcam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta extern tcam begin")
            # write lines to p4 file
            listtofile(dataplane, "externs.p4", filelines)
        # Packet Counter stage
        elif(stage[0] == 'p'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "externs.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "externs.txt", "@pta tempext pktcnt begin", "@pta tempext pktcnt end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta extern pktcnt begin")
            # write lines to p4 file
            listtofile(dataplane, "externs.p4", filelines)
        # Unidentified stage
        else:
            pass

# populate variables
def popvars(pipe):
    # iterate over stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # ALU stage
        elif(stage[0] == 'a'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "variables.txt", "@pta tempvar alu begin", "@pta tempvar alu end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta variables alu begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # CAM stage
        elif(stage[0] == 'c'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "variables.txt", "@pta tempvar cam begin", "@pta tempvar cam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta variables cam begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # TCAM stage
        elif(stage[0] == 't'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "variables.txt", "@pta tempvar tcam begin", "@pta tempvar tcam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta variables tcam begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # Unidentified stage
        else:
            pass

# populate instances
def popinsts(pipe):
    # iterate over stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # ALU stage
        elif(stage[0] == 'a'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "instances.txt", "@pta tempinst alu begin", "@pta tempinst alu end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta instances alu begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # CAM stage
        elif(stage[0] == 'c'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "instances.txt", "@pta tempinst cam begin", "@pta tempinst cam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta instances cam begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # TCAM stage
        elif(stage[0] == 't'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "instances.txt", "@pta tempinst tcam begin", "@pta tempinst tcam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta instances tcam begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # Unidentified stage
        else:
            pass

# populate stages
def popstages(pipe, assigned_meta):
    # iterate over stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # ALU stage
        elif(stage[0] == 'a'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "stages.txt", "@pta tempstage alu begin", "@pta tempstage alu end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # replace metadata fields
            for elem in assigned_meta:
                if ((elem[0] == stageidx) and (elem[1] == ("alu" + str(pipe[stageidx][1])))):
                    extracted = repstringlist(extracted, ("*" + str(elem[2]) + "*"), str(elem[3]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta stage " + str(stageidx) + " begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # CAM stage
        elif(stage[0] == 'c'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "stages.txt", "@pta tempstage cam begin", "@pta tempstage cam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # replace metadata fields
            for elem in assigned_meta:
                if ((elem[0] == stageidx) and (elem[1] == ("cam" + str(pipe[stageidx][1])))):
                    extracted = repstringlist(extracted, ("*" + str(elem[2]) + "*"), str(elem[3]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta stage " + str(stageidx) + " begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # TCAM stage
        elif(stage[0] == 't'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "stages.txt", "@pta tempstage tcam begin", "@pta tempstage tcam end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # replace metadata fields
            for elem in assigned_meta:
                if ((elem[0] == stageidx) and (elem[1] == ("tcam" + str(pipe[stageidx][1])))):
                    extracted = repstringlist(extracted, ("*" + str(elem[2]) + "*"), str(elem[3]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta stage " + str(stageidx) + " begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # Packet Counter stage
        elif(stage[0] == 'p'):
            # local variables
            stageidx = pipe.index(stage)
            extracted = []
            filelines = []
            # extract lines from p4 file
            filelines = exctallfile(str(dataplane) + "/" + "pipe.p4")
            # extract lines from template file
            extracted = exctsnippetfile(templates, "stages.txt", "@pta tempstage pktcnt begin", "@pta tempstage pktcnt end")
            # replace $ with index
            extracted = repstringlist(extracted, "$", str(pipe[stageidx][1]))
            # insert template lines in p4 file list
            filelines = listinlist(filelines, extracted, "@pta stage " + str(stageidx) + " begin")
            # write lines to p4 file
            listtofile(dataplane, "pipe.p4", filelines)
        # Unidentified stage
        else:
            pass

# assign metadata fields
def meta_assign(pipe):
    # local variables
    sume_meta_fields = max_sume_meta
    sume_meta_idx = 1.0
    user_meta_fields = max_user_meta
    user_meta_idx = 0.0
    sume_fields = []
    user_fields = []
    assigned = []
    # iterate over ALU stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # ALU stage
        elif(stage[0] == 'a'):
            # local variables
            stageidx = pipe.index(stage)
            filelines = []
            # check available metadata fields
            if ((sume_meta_fields >= 2.5) and (user_meta_fields >= 3)):
                # sume metadata
                # extract lines from meta_assign.txt file
                filelines = exctallfile(str(dataplane) + "/" + "meta_assign.txt")
                # check index
                if ((sume_meta_idx).is_integer()):
                    # add ALU fields in order and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " keya"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keya"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " keyb"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keyb"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " keyoper |"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keyoper"
                    number = str(int(sume_meta_idx)) + "[3:0]"
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 0.5
                    sume_meta_fields -= 0.5
                else:
                    # add OPER field first and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx - 0.5)) + " : " + "alu" + str((pipe[stageidx][1]) - 1) + " keyoper |") , ("meta_" + str(int(sume_meta_idx - 0.5)) + " : " + "alu" + str((pipe[stageidx][1]) - 1) + " keyoper | " + "alu" + str(pipe[stageidx][1]) + " keyoper"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keyoper"
                    number = str(int(sume_meta_idx - 0.5)) + "[7:4]"
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 0.5
                    sume_meta_fields -= 0.5
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " keya"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keya"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " keyb"))
                    stage = stageidx
                    type = ("alu" + str(pipe[stageidx][1]))
                    name = "keyb"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                # user metadata
                # add ALU fields in order and populate metadata fileds list
                filelines = repstringlist(filelines, ("um_" + str(int(user_meta_idx)) + " : FREE") , ("um_" + str(int(user_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " opa"))
                stage = stageidx
                type = ("alu" + str(pipe[stageidx][1]))
                name = "opa"
                number = str(int(user_meta_idx))
                assigned.append((stage, type, name, number))
                user_meta_idx += 1
                user_meta_fields -= 1
                filelines = repstringlist(filelines, ("um_" + str(int(user_meta_idx)) + " : FREE") , ("um_" + str(int(user_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " opb"))
                stage = stageidx
                type = ("alu" + str(pipe[stageidx][1]))
                name = "opb"
                number = str(int(user_meta_idx))
                assigned.append((stage, type, name, number))
                user_meta_idx += 1
                user_meta_fields -= 1
                filelines = repstringlist(filelines, ("um_" + str(int(user_meta_idx)) + " : FREE") , ("um_" + str(int(user_meta_idx)) + " : " + "alu" + str(pipe[stageidx][1]) + " oper"))
                stage = stageidx
                type = ("alu" + str(pipe[stageidx][1]))
                name = "oper"
                number = str(int(user_meta_idx))
                assigned.append((stage, type, name, number))
                user_meta_idx += 1
                user_meta_fields -= 1
                # write lines to meta_assign.txt file
                listtofile(dataplane, "meta_assign.txt", filelines)
            else:
                print("\n\nERROR!!! \n\n")
                print("NOT ENOUGH METADATA FIELDS AVAILABLE!!! \n\n")
                exit(1)
    # iterate over CAM stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # CAM stage
        elif(stage[0] == 'c'):
            # local variables
            stageidx = pipe.index(stage)
            filelines = []
            # check available metadata fields
            if ((sume_meta_fields >= 1) and (user_meta_fields >= 1)):
                # sume metadata
                # extract lines from meta_assign.txt file
                filelines = exctallfile(str(dataplane) + "/" + "meta_assign.txt")
                # check index
                if ((sume_meta_idx).is_integer()):
                    # add CAM field and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "cam" + str(pipe[stageidx][1]) + " key"))
                    stage = stageidx
                    type = ("cam" + str(pipe[stageidx][1]))
                    name = "key"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                else:
                    # update index
                    sume_meta_idx += 0.5
                    sume_meta_fields -= 0.5
                    # add CAM field and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "cam" + str(pipe[stageidx][1]) + " key"))
                    stage = stageidx
                    type = ("cam" + str(pipe[stageidx][1]))
                    name = "key"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                # user metadata
                # add CAM field and populate metadata fileds list
                filelines = repstringlist(filelines, ("um_" + str(int(user_meta_idx)) + " : FREE") , ("um_" + str(int(user_meta_idx)) + " : " + "cam" + str(pipe[stageidx][1]) + " mc"))
                stage = stageidx
                type = ("cam" + str(pipe[stageidx][1]))
                name = "mc"
                number = str(int(user_meta_idx))
                assigned.append((stage, type, name, number))
                user_meta_idx += 1
                user_meta_fields -= 1
                # write lines to meta_assign.txt file
                listtofile(dataplane, "meta_assign.txt", filelines)
            else:
                print("\n\nERROR!!! \n\n")
                print("NOT ENOUGH METADATA FIELDS AVAILABLE!!! \n\n")
                exit(1)
    # iterate over TCAM stages
    for stage in pipe:
        # invalid stage ==> pass
        if((stage[0] == 'z') or (stage[1] == -1)):
            pass
        # TCAM stage
        elif(stage[0] == 't'):
            # local variables
            stageidx = pipe.index(stage)
            filelines = []
            # check available metadata fields
            if ((sume_meta_fields >= 1) and (user_meta_fields >= 1)):
                # sume metadata
                # extract lines from meta_assign.txt file
                filelines = exctallfile(str(dataplane) + "/" + "meta_assign.txt")
                # check index
                if ((sume_meta_idx).is_integer()):
                    # add TCAM field and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "tcam" + str(pipe[stageidx][1]) + " key"))
                    stage = stageidx
                    type = ("tcam" + str(pipe[stageidx][1]))
                    name = "key"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                else:
                    # update index
                    sume_meta_idx += 0.5
                    sume_meta_fields -= 0.5
                    # add TCAM field and populate metadata fileds list
                    filelines = repstringlist(filelines, ("meta_" + str(int(sume_meta_idx)) + " : FREE") , ("meta_" + str(int(sume_meta_idx)) + " : " + "tcam" + str(pipe[stageidx][1]) + " key"))
                    stage = stageidx
                    type = ("tcam" + str(pipe[stageidx][1]))
                    name = "key"
                    number = str(int(sume_meta_idx))
                    assigned.append((stage, type, name, number))
                    sume_meta_idx += 1
                    sume_meta_fields -= 1
                # user metadata
                # add TCAM field and populate metadata fileds list
                filelines = repstringlist(filelines, ("um_" + str(int(user_meta_idx)) + " : FREE") , ("um_" + str(int(user_meta_idx)) + " : " + "tcam" + str(pipe[stageidx][1]) + " mc"))
                stage = stageidx
                type = ("tcam" + str(pipe[stageidx][1]))
                name = "mc"
                number = str(int(user_meta_idx))
                assigned.append((stage, type, name, number))
                user_meta_idx += 1
                user_meta_fields -= 1
                # write lines to meta_assign.txt file
                listtofile(dataplane, "meta_assign.txt", filelines)
            else:
                print("\n\nERROR!!! \n\n")
                print("NOT ENOUGH METADATA FIELDS AVAILABLE!!! \n\n")
                exit(1)
    # return assigned metadata fields, free meta fields
    sume_fields.append(sume_meta_fields)
    sume_fields.append(sume_meta_idx)
    user_fields.append(user_meta_fields)
    user_fields.append(user_meta_idx)
    return (assigned, sume_fields, user_fields)

# parse assumption/assertion
def parseasmr(i, parsed, asmr):
    # element: leftA, leftOP, leftB, midOP, rightA, rightOP, rightB
    element = ["-1", "-1", "-1", "-1", "-1", "-1", "-1"]
    midOP = "-1"
    left = "-1"
    right = "-1"
    if (str(asmr).find("&&") != -1):
        mididx = str(asmr).find("&&")
        element[3] = "&"
        left = asmr[0:(mididx-1)]
        right = asmr[(mididx+2):]
    elif (str(asmr).find("or") != -1):
        mididx = str(asmr).find("or")
        element[3] = "|"
        left = asmr[0:(mididx-1)]
        right = asmr[(mididx+2):]
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

# map parsed assertion to hw library
def mapexp(datastructure, counters, assertions, idx, location):
    # set opidx
    if (str(location) == "L"):
        opidx = 1
    elif (str(location) == "M"):
        opidx = 3
    elif (str(location) == "R"):
        opidx = 5
    else:
        pass
    # check for unsupported assertions TODO: add support
    if (str(assertions[idx][opidx]) == "-1") or ((str(assertions[idx][1]) == "-1") and (str(assertions[idx][5]) == "-1")):
        pass
    else:
        # ALU stage
        if ((str(assertions[idx][opidx]) == "|") or (str(assertions[idx][opidx]) == "&") or (str(assertions[idx][opidx]) == "aEQb") or (str(assertions[idx][opidx]) == "aNEQb") or (str(assertions[idx][opidx]) == "aGTb") or (str(assertions[idx][opidx]) == "aGTEb") or (str(assertions[idx][opidx]) == "aLTb") or (str(assertions[idx][opidx]) == "aLTEb") or (str(assertions[idx][opidx]) == "aSUMb") or (str(assertions[idx][opidx]) == "aSUBb") or (str(assertions[idx][opidx]) == "aANDb") or (str(assertions[idx][opidx]) == "aORb") or (str(assertions[idx][opidx]) == "aXORb")):
            # compute current position of ALU oper in user metadata
            current = (3*counters[0]) + counters[1] + counters[2] + 2
            # mid
            if(opidx == 3):
                if (str(assertions[idx][opidx]) == "|"):
                    operation = "aORb"
                elif (str(assertions[idx][opidx]) == "e"):
                    operation = "aANDb"
                else:
                    pass
                datastructure.append(["A", counters[0], ("uf" + str(current - 6)), ("uf" + str(current - 3)), str(operation)])
            # left or right
            else:
                datastructure.append(["A", counters[0], str(assertions[idx][opidx-1]), str(assertions[idx][opidx+1]), str(assertions[idx][opidx])])
            # increment counters
            counters[0] += 1
        # TODO: add support for other stages (CAM, TCAM, PKTCOUNT)
        else:
            pass
    # return mapped assertion
    return (datastructure, counters)

# populate alu tables
def popalu(elem, key_cnt, sume_fields, user_fields, table, sume_meta_lines):
    # open table file
    with open(str(controlplane) + "/" + "alu" + str(elem[1]) + "_" + str(table) + "_0.txt", "a+") as file:
        # table: OPA
        if (str(table) == "opa"):
            if((elem[2].isdigit()) or (elem[2].find("0b") != -1)):
                if(sume_fields[0] >= 1):
                    line = (int(sume_fields[1]), ("alu" + str(elem[1]) + " val"))
                    sume_meta_lines.append(line)
                    field = "mf" + str(int(sume_fields[1]))
                    sume_fields[0] -= 1
                    sume_fields[1] += 1
                    file.write("table_cam_add_entry alu"+ str(elem[1]) + "_" + str(table) + "_0" + " " + str(table) + str(field) + " " + str(key_cnt[elem[1]][0]))
                else:
                    print("ERROR!!!")
                    print("Need more FREE sume metadata fields\n")
                    exit(1)
            else:
                file.write("table_cam_add_entry alu"+ str(elem[1]) + "_" + str(table) + "_0" + " " + str(table) + str(elem[2]) + " " + str(key_cnt[elem[1]][0]))
        # table: OPB
        elif (str(table) == "opb"):
            if((elem[3].isdigit()) or (elem[3].find("0b") != -1)):
                if(sume_fields[0] >= 1):
                    line = (int(sume_fields[1]), ("alu" + str(elem[1]) + " val"))
                    sume_meta_lines.append(line)
                    field = "mf" + str(int(sume_fields[1]))
                    sume_fields[0] -= 1
                    sume_fields[1] += 1
                    file.write("table_cam_add_entry alu"+ str(elem[1]) + "_" + str(table) + "_0" + " " + str(table) + str(field) + " " + str(key_cnt[elem[1]][1]))
                else:
                    print("ERROR!!!")
                    print("Need more FREE sume metadata fields\n")
                    exit(1)
            else:
                file.write("table_cam_add_entry alu"+ str(elem[1]) + "_" + str(table) + "_0" + " " + str(table) + str(elem[3]) + " " + str(key_cnt[elem[1]][1]))
        # table: OPER
        elif (str(table) == "oper"):
            file.write("table_cam_add_entry alu"+ str(elem[1]) + "_" + str(table) + "_0" + " " + str(elem[4]) + " " + str(key_cnt[elem[1]][2]) + " " + "=>" + " " + str(key_cnt[elem[1]][2]))
    return (key_cnt, sume_fields, user_fields, sume_meta_lines)
