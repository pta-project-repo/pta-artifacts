#!/bin/bash

# RUN TEST
alias rt_dpv='clear && python $DPV_P4V_SC/run_test.py'

# CONFIGURE CODE
alias cf_dpv='clear && python $DPV_P4V_SC/p4v-to-dpv.py'

# RESET FLAG
alias rf_dpv='clear && echo "" > $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag'

# COMPILE PROGRAM
alias cp_dpv='clear && $TOOLS/p4_build.sh -j6 --with-tofino $REPO/$DPV_NAME/data-plane/$DPV_NAME.p4 && echo "DONE COMPILING" > $REPO/$DPV_NAME/data-plane/$DPV_NAME.flag'

# LOAD BINARY
alias ld_dpv='clear && $SDE/run_switchd.sh -p $DPV_NAME'

# CONFIGURE PORTS
alias pc_dpv='clear && bfshell -f $REPO/$DPV_NAME/control-plane/ports_config.conf'

# WRITE TABLES
alias wt_dpv='clear && sudo -E $SDE/run_p4_tests.sh --no-status-srv -t $REPO/$DPV_NAME/control-plane/wr_tables/ --target hw'

# WRITE CONFIGURATION REGISTERS
alias wc_dpv='clear && sudo -E $SDE/run_p4_tests.sh --no-status-srv -t $REPO/$DPV_NAME/control-plane/wr_config_regs/ --target hw'

# READ RESULT REGISTERS
alias rr_dpv='clear && sudo -E $SDE/run_p4_tests.sh --no-status-srv -t $REPO/$DPV_NAME/control-plane/rd_res_regs/ --target hw > $REPO/$DPV_NAME/control-plane/rd_res_regs/test_results.txt'

# PROCESS RESULT REGISTERS
alias pr_dpv='clear && python $DPV_P4V_SC/process_results.py'

# RUN PACKETGEN
alias pg_dpv='clear && sudo -E $SDE/run_p4_tests.sh --no-status-srv -t $REPO/$DPV_NAME/pktgen --target hw'

# ENVIRONMENT VARIABLES
export DPV_TPG="$REPO/tpg"
export DPV_TPG_CP="$DPV_TPG/control-plane"
export DPV_TPG_DP="$DPV_TPG/data-plane"
export DPV_TPG_PG="$DPV_TPG/pktgen"

export DPV_PUT="$REPO/put"
export DPV_PUT_CP="$DPV_PUT/control-plane"
export DPV_PUT_DP="$DPV_PUT/data-plane"

export DPV_OPC="$REPO/opc"
export DPV_OPC_CP="$DPV_OPC/control-plane"
export DPV_OPC_DP="$DPV_OPC/data-plane"

export DPV_P4V="$REPO/p4v-to-dpv"
export DPV_P4V_SC="$DPV_P4V/scripts"
export DPV_P4V_TP="$DPV_P4V/templates"