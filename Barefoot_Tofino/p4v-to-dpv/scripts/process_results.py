#!/usr/bin/python

import os
import sys
import subprocess
import math
import re
import time

import library

# set the environment
def set_env(env):
    env[0] = os.getenv("REPO")
    env[1] = str(env[0]) + "/" + "p4v-to-dpv"
    env[2] = str(env[0]) + "/" + "tpg"
    env[3] = str(env[0]) + "/" + "put"
    env[4] = str(env[0]) + "/" + "opc"
    env[5] = str(env[0]) + "/" + "mgr"
    env[6] = os.getenv("DPV_USR")
    return env

def main():

    # environment: REPO P4VDPV    TPG   PUT   OPC   MGR    USR      -      -       -
    #       index:  0     1        2     3     4      5     6      7      8       9
    environment = [ "",   "",     "",   "",   "",    "",    "",    "",    "",     "",    ]
    environment = set_env(environment)

    filelines = library.exctallfile(str(environment[4]) + "/control-plane/rd_res_regs/test_results.txt")

    print("\nTEST RESULTS:\n")

    assertions = []
    assertion = ""
    (psdassumptions, psdassertions) = library.extract_pragmas(str(environment[3]) + "/data-plane/put.p4")
    for ass in psdassertions:
        for elem in ass:
            if str(elem) != "-1":
                if str(elem) == "aEQb":
                    elem = "=="
                elif str(elem) == "aNEQb":
                    elem = "!="
                elif str(elem) == "aGTb":
                    elem = ">"
                elif str(elem) == "aGTEb":
                    elem = ">="
                elif str(elem) == "aLTb":
                    elem = "<"
                elif str(elem) == "aLTEb":
                    elem = "<="
                assertion = assertion + str(elem) + " "
        assertions.append(assertion)
        assertion = ""

    results = []
    current = -1
    for line in filelines:
        if (str(line).find("RESULT") != -1):
            index = int(line[(str(line).find("RESULT")+6):str(line).find("$")])
            result = int(line[(str(line).find("f1=")+3):str(line).find(")")])
            if(index <= current):
                results[index] = int(results[index]) + int(result)
            else:
                results.append(int(result))
                current = index

    i = 0
    for result in results:
        if(int(result) > 0):
            outcome = "PASS"
        else:
            outcome = "FAIL"
        print("[" + str(i) + "] ( " + str(assertions[i]) + ") --> " + "RESULT: " + str(result) + " --> " + str(outcome) + "\n")
        i = i + 1

    # EXIT
    exit(0)

if __name__ == '__main__':
    main()
