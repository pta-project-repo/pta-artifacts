#!/bin/bash

# ALU 0
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu0_opa_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu0_opb_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu0_oper_0.txt
sleep 1

# CAM 0
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/cam0_keytab_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/cam0_camtab_0.txt
sleep 1

# TCAM 0
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/tcam0_keytab_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/tcam0_tcamtab_0.txt
sleep 1

# ALU 1
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu1_opa_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu1_opb_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/alu1_oper_0.txt
sleep 1

# CAM 1
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/cam1_keytab_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/cam1_camtab_0.txt
sleep 1

# TCAM 1
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/tcam1_keytab_0.txt
${VERSW}/CLI/P4_SWITCH_CLI.py < ${VERSRC}/scripts/tcam1_tcamtab_0.txt
sleep 1

exit 0
