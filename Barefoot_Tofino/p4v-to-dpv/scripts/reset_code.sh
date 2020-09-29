#!/bin/bash

################################
###          TPG
################################

# reset data plane
rm -f ${REPO}/tpg/data-plane/tpg.p4
cp ${REPO}/p4v-to-dpv/templates/tpg.p4.tpt ${REPO}/tpg/data-plane/tpg.p4

# get headers from PUT
rm -f ${REPO}/tpg/data-plane/include/headers.p4
mkdir -pv ${REPO}/tpg/data-plane/include
cp ${REPO}/put/data-plane/include/headers.p4 ${REPO}/tpg/data-plane/include/headers.p4

# reset metadata
cp ${REPO}/p4v-to-dpv/templates/metadata.p4.tpt ${REPO}/tpg/data-plane/include/metadata.p4

# reset control plane (write config registers)
rm -f ${REPO}/tpg/control-plane/wr_config_regs/wr_config_regs.py
mkdir -pv ${REPO}/tpg/control-plane/wr_config_regs
cp ${REPO}/p4v-to-dpv/templates/tpg_wr_config_regs.py.tpt ${REPO}/tpg/control-plane/wr_config_regs/wr_config_regs.py

# reset pktgen.py
rm -f ${REPO}/tpg/pktgen/pktgen.py
mkdir -pv ${REPO}/tpg/pktgen
cp ${REPO}/p4v-to-dpv/templates/tpg_pktgen.py.tpt ${REPO}/tpg/pktgen/pktgen.py

################################
###          OPC
################################

# reset data plane
rm -f ${REPO}opcg/data-plane/opc.p4
cp ${REPO}/p4v-to-dpv/templates/opc.p4.tpt ${REPO}/opc/data-plane/opc.p4

# get headers from PUT
rm -f ${REPO}/opc/data-plane/include/headers.p4
mkdir -pv ${REPO}/opc/data-plane/include
cp ${REPO}/put/data-plane/include/headers.p4 ${REPO}/opc/data-plane/include/headers.p4

# reset metadata
cp ${REPO}/p4v-to-dpv/templates/metadata.p4.tpt ${REPO}/opc/data-plane/include/metadata.p4

# reset control plane (write config registers)
rm -f ${REPO}/opc/control-plane/wr_config_regs/wr_config_regs.py
mkdir -pv ${REPO}/opc/control-plane/wr_config_regs
cp ${REPO}/p4v-to-dpv/templates/opc_wr_config_regs.py.tpt ${REPO}/opc/control-plane/wr_config_regs/wr_config_regs.py

# reset control plane (read result registers)
rm -f ${REPO}/opc/control-plane/rd_res_regs/rd_res_regs.py
mkdir -pv ${REPO}/opc/control-plane/rd_res_regs
cp ${REPO}/p4v-to-dpv/templates/opc_rd_res_regs.py.tpt ${REPO}/opc/control-plane/rd_res_regs/rd_res_regs.py

echo " "
echo " "
echo "CODE HAS BEEN RESET!!!"
echo " "
echo " "

exit 0
