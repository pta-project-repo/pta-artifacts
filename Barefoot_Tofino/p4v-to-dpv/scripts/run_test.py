#!/usr/bin/python

import os
import sys
import subprocess
import math
import re
import time
import datetime

import library

# set the environment
def set_env(env):
    env[0] = os.getenv("REPO")
    env[1] = str(env[0]) + "/" + "p4v-to-dpv"
    env[2] = str(env[0]) + "/" + "tpg"
    env[3] = str(env[0]) + "/" + "put"
    env[4] = str(env[0]) + "/" + "opc"
    env[5] = " "
    env[6] = os.getenv("DPV_USR")
    return env

# sleep_function
def sleep_function(sleeptime):
    print(str(datetime.datetime.now()) + " - " + "SLEEPING FOR " + str(sleeptime) + " SECONDS...")
    time.sleep(sleeptime)

def main():

    print("\n***************************************************************")
    print("***                           DPV                           ***")
    print("***************************************************************\n")
    
    slp_after_pktgen = 30

    # check arguments
    flag_sc = -1
    flag_sp = -1
    flag_mf = -1
    for arg in sys.argv:
        # skip first arg
        if(sys.argv.index(arg) == 0):
            pass
        else:
            # skip compiling (default is enabled)
            if (str(arg).find("-sc") != -1):
                flag_sc = 1
            # skip PUT (default is enabled)
            if (str(arg).find("-sp") != -1):
                flag_sp = 1
            # test multiple-files source code programs (default is enabled)
            if (str(arg).find("-mf") != -1):
                flag_mf = 1
    # DEFAULT VALUES
    if(flag_sc == -1):
        flag_sc = 0
    if(flag_sp == -1):
        flag_sp = 0
    if(flag_mf == -1):
        flag_mf = 0

    # environment: REPO P4VDPV    TPG   PUT   OPC   MGR    USR      -      -       -
    #       index:  0     1        2     3     4      5     6      7      8       9
    environment = [ "",   "",     "",   "",   "",    "",    "",    "",    "",     "",    ]
    environment = set_env(environment)

    # switches
    switches = ["tpg", "put", "opc"]
    switches_np = ["tpg", "opc"]

    # sessions
    sessions = ["dpv_cf", "dpv_cp", "dpv_ld", "dpv_pc", "dpv_wt", "dpv_wc", "dpv_rr", "dpv_pg"]

    ########################################################################################################################
    ###                           AUTOMATICALLY TEST SINGLE-FILE SOURCE-CODE PROGRAMS
    ########################################################################################################################
    if (flag_mf == 0):

        print("               SINGLE-FILE SOURCE-CODE PROGRAM                   \n")

        # remove "saturating" (BUGGED) from headers
        library.rmv_sat(environment)
        print(str(datetime.datetime.now()) + " - " + "\"SATURATING\" ATTRIBUTE (BUGGED) REMOVED FROM HEADERS")

        # clean PUT in the three switches
        with open(os.devnull, "w") as devnull:
            for switch in switches:
                command = "rm -rf $DPV_PUT_DP"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "OLD PROGRAM DELETED")

        # copy PUT from local machine (Manager) to the three switches
        with open(os.devnull, "w") as devnull:
            for switch in switches:
                subprocess.call("scp -r $DPV_PUT_DP " + str(environment[6]) + "@tofino_" + str(switch) + ":$(ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && printf $DPV_PUT_DP\')", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "NEW PROGRAM COPIED")

        # kill bf_switchd on the three switches
        with open(os.devnull, "w") as devnull:
            if (flag_sp == 0):
                for switch in switches:
                    command = "sudo killall bf_switchd"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
            else:
                print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                for switch in switches_np:
                    command = "sudo killall bf_switchd"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "BF_SWITCHD KILLED")

        with open(os.devnull, "w") as devnull:
            if (flag_sp == 0):
                # kill old TMUX sessions
                for switch in switches:
                    for session in sessions:
                        command = "tmux kill-session -t " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
                # start new TMUX sessions
                for switch in switches:
                    for session in sessions:
                        command = "tmux new-session -d -s " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
            else:
                print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                # kill old TMUX sessions
                for switch in switches_np:
                    for session in sessions:
                        command = "tmux kill-session -t " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
                # start new TMUX sessions
                for switch in switches_np:
                    for session in sessions:
                        command = "tmux new-session -d -s " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "TMUX SESSIONS RESET")

        # configure framework on the three switches
        if (flag_sp == 0):
            for switch in switches:
                command = "tmux send-keys -t dpv_cf cf_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        else:
            print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
            for switch in switches_np:
                command = "tmux send-keys -t dpv_cf cf_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "THE FRAMEWORK IS NOW CONFIGURED")
        sleep_function(2)

        # Reset flags
        for switch in switches:
            command = "tmux send-keys -t dpv_cp rf_dpv Enter"
            subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)

        # Compile code
        if (flag_sc == 0):
            if (flag_sp == 0):
                for switch in switches:
                    command = "tmux send-keys -t dpv_cp cp_dpv Enter"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            else:
                print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                for switch in switches_np:
                    command = "tmux send-keys -t dpv_cp cp_dpv Enter"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "COMPILING...")
            # Wait for completion
            flag_tpg = 0
            flag_put = 0
            flag_opc = 0
            while ((flag_tpg == 0) or (flag_put == 0) or (flag_opc == 0)):
                # tpg
                if (flag_tpg == 0):
                    ssh_tpg = subprocess.Popen(["ssh " + str(environment[6]) + "@tofino_tpg " + "\'source ~/.profile && cat $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag\'"], shell=True, stdout=subprocess.PIPE)
                    for line in ssh_tpg.stdout:
                        if (str(line).find("DONE COMPILING") != -1):
                            flag_tpg = 1
                            print(str(datetime.datetime.now()) + " - " + "DONE COMPILING TPG")
                # put
                if (flag_put == 0):
                    if (flag_sp == 0):
                        ssh_put = subprocess.Popen(["ssh " + str(environment[6]) + "@tofino_put " + "\'source ~/.profile && cat $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag\'"], shell=True, stdout=subprocess.PIPE)
                        for line in ssh_put.stdout:
                            if (str(line).find("DONE COMPILING") != -1):
                                flag_put = 1
                                print(str(datetime.datetime.now()) + " - " + "DONE COMPILING PUT")
                    else:
                        flag_put = 1
                        print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                # opc
                if (flag_opc == 0):
                    ssh_opc = subprocess.Popen(["ssh " + str(environment[6]) + "@tofino_opc " + "\'source ~/.profile && cat $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag\'"], shell=True, stdout=subprocess.PIPE)
                    for line in ssh_opc.stdout:
                        if (str(line).find("DONE COMPILING") != -1):
                            flag_opc = 1
                            print(str(datetime.datetime.now()) + " - " + "DONE COMPILING OPC")
            print(str(datetime.datetime.now()) + " - " + "THE FRAMEWORK IS NOW COMPILED")
            # Reset flags
            for switch in switches:
                command = "tmux send-keys -t dpv_cp rf_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        else:
            print(str(datetime.datetime.now()) + " - " + "SKIPPING COMPILATION")

        # load program & port configuration
        if (flag_sp == 0):
            for switch in switches:
                command = "tmux send-keys -t dpv_ld ld_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "LOADED DATA PLANE")
            sleep_function(15)
            for switch in switches:
                command = "tmux send-keys -t dpv_pc pc_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "LOADED PORT CONFIGURATION")
            sleep_function(10)
        else:
            print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
            for switch in switches_np:
                command = "tmux send-keys -t dpv_ld ld_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "LOADED DATA PLANE")
            sleep_function(15)
            for switch in switches_np:
                command = "tmux send-keys -t dpv_pc pc_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "LOADED PORT CONFIGURATION")
            sleep_function(10)

        # # PUT: write tables
        # if (flag_sp == 0):
        #     command = "tmux send-keys -t dpv_wt wt_dpv Enter"
        #     subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "put" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        #     sleep_function(2)

        # TPG & OPC: write configuration registers
        command = "tmux send-keys -t dpv_wc wc_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "tpg" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "LOADED CONTROL PLANE")
        sleep_function(2)

        # TPG: run pkgen
        print(str(datetime.datetime.now()) + " - " + "RUNNING TEST...")
        command = "tmux send-keys -t dpv_pg pg_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "tpg" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        sleep_function(slp_after_pktgen)

        # OPC: read result registers
        print(str(datetime.datetime.now()) + " - " + "READING RESULTS...")
        command = "tmux send-keys -t dpv_rr rr_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        sleep_function(2)
        command = "python $DPV_P4V_SC/process_results.py"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)

        # EXIT
        print("TEST DONE\n")
        exit(0)

    ########################################################################################################################
    ###                           AUTOMATICALLY TEST MULTIPLE-FILES SOURCE-CODE PROGRAMS
    ########################################################################################################################
    else:

        print("              MULTIPLE-FILES SOURCE-CODE PROGRAM                 \n")

        # remove "saturating" (BUGGED) from headers
        # library.rmv_sat(environment)
        # print(str(datetime.datetime.now()) + " - " + "\"SATURATING\" ATTRIBUTE (BUGGED) REMOVED FROM HEADERS")

        # clean PUT in the three switches
        # with open(os.devnull, "w") as devnull:
        #     for switch in switches:
        #         command = "rm -rf $DPV_PUT_DP"
        #         subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        # print(str(datetime.datetime.now()) + " - " + "OLD PROGRAM DELETED")

        # copy PUT from local machine (Manager) to the three switches
        # with open(os.devnull, "w") as devnull:
        #     for switch in switches:
        #         subprocess.call("scp -r $DPV_PUT_DP " + str(environment[6]) + "@tofino_" + str(switch) + ":$(ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && printf $DPV_PUT_DP\')", stdout=devnull, shell=True)
        # print(str(datetime.datetime.now()) + " - " + "NEW PROGRAM COPIED")

        # kill bf_switchd on the three switches
        with open(os.devnull, "w") as devnull:
            if (flag_sp == 0):
                for switch in switches:
                    command = "sudo killall bf_switchd"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
            else:
                print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                for switch in switches_np:
                    command = "sudo killall bf_switchd"
                    subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "BF_SWITCHD KILLED")

        with open(os.devnull, "w") as devnull:
            if (flag_sp == 0):
                # kill old TMUX sessions
                for switch in switches:
                    for session in sessions:
                        command = "tmux kill-session -t " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
                # start new TMUX sessions
                for switch in switches:
                    for session in sessions:
                        command = "tmux new-session -d -s " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
            else:
                print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                # kill old TMUX sessions
                for switch in switches_np:
                    for session in sessions:
                        command = "tmux kill-session -t " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
                # start new TMUX sessions
                for switch in switches_np:
                    for session in sessions:
                        command = "tmux new-session -d -s " + str(session)
                        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", stdout=devnull, shell=True)
        print(str(datetime.datetime.now()) + " - " + "TMUX SESSIONS RESET")

        # configure framework
        print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
        for switch in switches_np:
            command = "tmux send-keys -t dpv_cf cf_dpv Enter"
            subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "THE FRAMEWORK IS NOW CONFIGURED")
        sleep_function(2)

        # Reset flags
        for switch in switches_np:
            command = "tmux send-keys -t dpv_cp rf_dpv Enter"
            subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)

        # Compile code
        if (flag_sc == 0):
            print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
            for switch in switches_np:
                command = "tmux send-keys -t dpv_cp cp_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
            print(str(datetime.datetime.now()) + " - " + "COMPILING...")
            # Wait for completion
            flag_tpg = 0
            flag_put = 0
            flag_opc = 0
            while ((flag_tpg == 0) or (flag_put == 0) or (flag_opc == 0)):
                # tpg
                if (flag_tpg == 0):
                    ssh_tpg = subprocess.Popen(["ssh " + str(environment[6]) + "@tofino_tpg " + "\'source ~/.profile && cat $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag\'"], shell=True, stdout=subprocess.PIPE)
                    for line in ssh_tpg.stdout:
                        if (str(line).find("DONE COMPILING") != -1):
                            flag_tpg = 1
                            print(str(datetime.datetime.now()) + " - " + "DONE COMPILING TPG")
                # put
                if (flag_put == 0):
                    flag_put = 1
                    print(str(datetime.datetime.now()) + " - " + "SKIPPING PUT")
                # opc
                if (flag_opc == 0):
                    ssh_opc = subprocess.Popen(["ssh " + str(environment[6]) + "@tofino_opc " + "\'source ~/.profile && cat $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag\'"], shell=True, stdout=subprocess.PIPE)
                    for line in ssh_opc.stdout:
                        if (str(line).find("DONE COMPILING") != -1):
                            flag_opc = 1
                            print(str(datetime.datetime.now()) + " - " + "DONE COMPILING OPC")
            print(str(datetime.datetime.now()) + " - " + "THE FRAMEWORK IS NOW COMPILED")
            # Reset flags
            for switch in switches:
                command = "tmux send-keys -t dpv_cp rf_dpv Enter"
                subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        else:
            print(str(datetime.datetime.now()) + " - " + "SKIPPING COMPILATION")

        # load program & port configuration
        for switch in switches_np:
            command = "tmux send-keys -t dpv_ld ld_dpv Enter"
            subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "LOADED DATA PLANE, PUT SKIPPED")
        sleep_function(15)
        for switch in switches_np:
            command = "tmux send-keys -t dpv_pc pc_dpv Enter"
            subprocess.call("ssh " + str(environment[6]) + "@tofino_" + str(switch) + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "LOADED PORT CONFIGURATION, PUT SKIPPED")
        sleep_function(10)
        command = "tmux send-keys -t dpv_ld ld_$DPV_NAME Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_put \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "PUT: LOADED DATA PLANE")
        sleep_function(15)
        command = "tmux send-keys -t dpv_pc pc_$DPV_NAME Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_put \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "PUT: LOADED PORT CONFIGURATION")
        sleep_function(10)

        # # PUT: write tables
        # if (flag_sp == 0):
        #     command = "tmux send-keys -t dpv_wt wt_dpv Enter"
        #     subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "put" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        #     sleep_function(2)

        # TPG & OPC: write configuration registers
        command = "tmux send-keys -t dpv_wc wc_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "tpg" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        print(str(datetime.datetime.now()) + " - " + "LOADED CONTROL PLANE")
        sleep_function(2)

        # TPG: run pkgen
        print(str(datetime.datetime.now()) + " - " + "RUNNING TEST...")
        command = "tmux send-keys -t dpv_pg pg_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "tpg" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        sleep_function(10)

        # OPC: read result registers
        print(str(datetime.datetime.now()) + " - " + "READING RESULTS...")
        command = "tmux send-keys -t dpv_rr rr_dpv Enter"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)
        sleep_function(2)
        command = "python $DPV_P4V_SC/process_results.py"
        subprocess.call("ssh " + str(environment[6]) + "@tofino_" + "opc" + " \'source ~/.profile && " + str(command) + "\'", shell=True)

        # EXIT
        print("TEST DONE\n")
        exit(0)

    ########################################################################################################################

if __name__ == '__main__':
    main()
