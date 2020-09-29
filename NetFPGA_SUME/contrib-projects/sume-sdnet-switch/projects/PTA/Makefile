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


# Makefile to build the SUME-SDNet module / wrapper IP for use in the SUME project 

SDNET_PPL_OUT_DIR=nf_sume_sdnet_ppl_ip
SDNET_DBG_OUT_DIR=nf_sume_sdnet_dbg_ip
SDNET_VER_OUT_DIR=nf_sume_sdnet_ver_ip

PX=sdnet

PX_PPL_FLAGS=-skipEval -busType axi -busWidth 256 -singlecontrolport -workDir ${SDNET_PPL_OUT_DIR}
PX_DBG_FLAGS=-skipEval -busType axi -busWidth 256 -singlecontrolport -workDir ${SDNET_DBG_OUT_DIR}
PX_VER_FLAGS=-skipEval -busType axi -busWidth 256 -singlecontrolport -workDir ${SDNET_VER_OUT_DIR}

TARGET=${SUME_FOLDER}/lib/hw/contrib/cores

P4_SWITCH=SimpleSumeSwitch

PPL_P4_SWITCH=ppl_SimpleSumeSwitch
DBG_P4_SWITCH=dbg_SimpleSumeSwitch
VER_P4_SWITCH=ver_SimpleSumeSwitch

P4_SWITCH_PPL_BASE_ADDR=0x44020000
P4_SWITCH_DBG_BASE_ADDR=0x440B0000
P4_SWITCH_VER_BASE_ADDR=0x440D0000

PPL_PREFIX=ppl_
DBG_PREFIX=dbg_
VER_PREFIX=ver_

PPL_SWITCH_INFO=ppl_src/.sdnet_switch_info.dat
DBG_SWITCH_INFO=dbg_src/.sdnet_switch_info.dat
VER_SWITCH_INFO=ver_src/.sdnet_switch_info.dat

all: clean cleansumelib sumelib ppl dbg ver install_sdnet

ppl:
	# PPL
	make -C ppl_src/
	make -C ppl_testdata/
	$(PX) ./ppl_src/${P4_PPL_NAME}.sdnet $(PX_PPL_FLAGS) -prefix ${PPL_PREFIX}
	# rsync -av --ignore-missing-args ppl_src/*.tbl ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/
	cp ppl_src/*.tbl ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/
	cp ppl_testdata/*.txt ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/
	cp ppl_testdata/*.axi ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/
	#${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${PPL_SWITCH_INFO} ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/ ${SUME_SDNET}/templates/PPL_CLI_template ./ppl_testdata/ ./ppl_sw/ --base_address ${P4_SWITCH_PPL_BASE_ADDR}
	# ${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${PPL_SWITCH_INFO} ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./ppl_testdata/ ./ppl_sw/ --base_address ${P4_SWITCH_PPL_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${PPL_SWITCH_INFO} ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./ppl_testdata/ ./ppl_sw/ --base_address ${P4_SWITCH_PPL_BASE_ADDR} --ext_prefix ${PPL_PREFIX}
	${SUME_SDNET}/bin/gen_P4_SWITCH_API.py ${PPL_SWITCH_INFO} ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/ ppl_sw/ ${SUME_SDNET}/templates/PPL_CLI_template --base_address ${P4_SWITCH_PPL_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_CLI.py ${PPL_SWITCH_INFO} ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/ ppl_sw/ ${SUME_SDNET}/templates/PPL_CLI_template --base_address ${P4_SWITCH_PPL_BASE_ADDR}
	# The following command only applies if running PPL_P4_SWITCH Questa Simulation with Ubuntu
	sed -i 's/vsim/vsim \-ldflags \"\-B\/usr\/lib\/x86\_64\-linux-gnu\"/g' ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/questa.bash
	# modify the P4_SWITCH_tb so that it writes the table configuration writes to a file
	${SUME_SDNET}/bin/modify_P4_SWITCH_tb.py ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/Testbench/${PPL_P4_SWITCH}_tb.sv
	./ppl_sw/bin/update_idle_count.py ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/Testbench/${PPL_P4_SWITCH}_tb.sv
	# rename extern files:
	find ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH} -type f -exec sed -i 's/${PPL_PREFIX}${PPL_PREFIX}/${PPL_PREFIX}/g' {} +
	#-------------------------------------------------------------------------->FILE CONTENT
	find ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH} -depth -type d -name "*${PPL_PREFIX}${PPL_PREFIX}*SimpleSumeSwitch.TB" -exec cp -r {} "${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/${PPL_PREFIX}SimpleSumeSwitch.TB" \; -exec rm -R {} \;
	#-------------------------------------------------------------------------->DIRECTORY NAME
	find ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH} -name "*${PPL_PREFIX}${PPL_PREFIX}*.v.stub" -exec rename -v 's/${PPL_PREFIX}${PPL_PREFIX}/${PPL_PREFIX}/i' {} \;
	#-------------------------------------------------------------------------->FILE NAME
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY GENERATED PPL MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

dbg:
	# DBG
	make -C dbg_src/
	make -C dbg_testdata/
	$(PX) ./dbg_src/${P4_DBG_NAME}.sdnet $(PX_DBG_FLAGS)  -prefix ${DBG_PREFIX}
	# rsync -av --ignore-missing-args dbg_src/*.tbl ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/
	cp dbg_src/*.tbl ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/
	cp dbg_testdata/*.txt ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/
	cp dbg_testdata/*.axi ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/
	#${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${DBG_SWITCH_INFO} ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/ ${SUME_SDNET}/templates/DBG_CLI_template ./dbg_testdata/ ./dbg_sw/ --base_address ${P4_SWITCH_DBG_BASE_ADDR}
	# ${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${DBG_SWITCH_INFO} ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./dbg_testdata/ ./dbg_sw/ --base_address ${P4_SWITCH_DBG_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${DBG_SWITCH_INFO} ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./dbg_testdata/ ./dbg_sw/ --base_address ${P4_SWITCH_DBG_BASE_ADDR} --ext_prefix ${DBG_PREFIX}
	${SUME_SDNET}/bin/gen_P4_SWITCH_API.py ${DBG_SWITCH_INFO} ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/ dbg_sw/ ${SUME_SDNET}/templates/DBG_CLI_template --base_address ${P4_SWITCH_DBG_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_CLI.py ${DBG_SWITCH_INFO} ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/ dbg_sw/ ${SUME_SDNET}/templates/DBG_CLI_template --base_address ${P4_SWITCH_DBG_BASE_ADDR}
	# The following command only applies if running DBG_P4_SWITCH Questa Simulation with Ubuntu
	sed -i 's/vsim/vsim \-ldflags \"\-B\/usr\/lib\/x86\_64\-linux-gnu\"/g' ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/questa.bash
	# modify the P4_SWITCH_tb so that it writes the table configuration writes to a file
	${SUME_SDNET}/bin/modify_P4_SWITCH_tb.py ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/Testbench/${DBG_P4_SWITCH}_tb.sv
	./dbg_sw/bin/update_idle_count.py ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/Testbench/${DBG_P4_SWITCH}_tb.sv
	# rename extern files:
	find ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH} -type f -exec sed -i 's/${DBG_PREFIX}${DBG_PREFIX}/${DBG_PREFIX}/g' {} +
	#-------------------------------------------------------------------------->FILE CONTENT
	find ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH} -depth -type d -name "*${DBG_PREFIX}${DBG_PREFIX}*SimpleSumeSwitch.TB" -exec cp -r {} "${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/${DBG_PREFIX}SimpleSumeSwitch.TB" \; -exec rm -R {} \;
	#-------------------------------------------------------------------------->DIRECTORY NAME
	find ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH} -name "*${DBG_PREFIX}${DBG_PREFIX}*.v.stub" -exec rename -v 's/${DBG_PREFIX}${DBG_PREFIX}/${DBG_PREFIX}/i' {} \;
	#-------------------------------------------------------------------------->FILE NAME
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY GENERATED DBG MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ver:
	# VER
	make -C ver_src/
	make -C ver_testdata/
	$(PX) ./ver_src/${P4_VER_NAME}.sdnet $(PX_VER_FLAGS) -prefix ${VER_PREFIX}
	# rsync -av --ignore-missing-args ver_src/*.tbl ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/
	cp ver_src/*.tbl ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/
	cp ver_testdata/*.txt ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/
	cp ver_testdata/*.axi ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/
	# ${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${VER_SWITCH_INFO} ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/ ${SUME_SDNET}/templates/VER_CLI_template ./ver_testdata/ ./ver_sw/ --base_address ${P4_SWITCH_VER_BASE_ADDR}
	# ${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${VER_SWITCH_INFO} ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./ver_testdata/ ./ver_sw/ --base_address ${P4_SWITCH_VER_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_externs.py ${VER_SWITCH_INFO} ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/ ${SUME_SDNET}/templates/ ./ver_testdata/ ./ver_sw/ --base_address ${P4_SWITCH_VER_BASE_ADDR} --ext_prefix ${VER_PREFIX}
	${SUME_SDNET}/bin/gen_P4_SWITCH_API.py ${VER_SWITCH_INFO} ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/ ver_sw/ ${SUME_SDNET}/templates/VER_CLI_template --base_address ${P4_SWITCH_VER_BASE_ADDR}
	${SUME_SDNET}/bin/gen_P4_SWITCH_CLI.py ${VER_SWITCH_INFO} ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/ ver_sw/ ${SUME_SDNET}/templates/VER_CLI_template --base_address ${P4_SWITCH_VER_BASE_ADDR}
	# The following command only applies if running VER_P4_SWITCH Questa Simulation with Ubuntu
	sed -i 's/vsim/vsim \-ldflags \"\-B\/usr\/lib\/x86\_64\-linux-gnu\"/g' ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/questa.bash
	# modify the P4_SWITCH_tb so that it writes the table configuration writes to a file
	${SUME_SDNET}/bin/modify_P4_SWITCH_tb.py ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/Testbench/${VER_P4_SWITCH}_tb.sv
	./ver_sw/bin/update_idle_count.py ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/Testbench/${VER_P4_SWITCH}_tb.sv
	# rename extern files:
	find ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH} -type f -exec sed -i 's/${VER_PREFIX}${VER_PREFIX}/${VER_PREFIX}/g' {} +
	#-------------------------------------------------------------------------->FILE CONTENT
	find ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH} -depth -type d -name "*${VER_PREFIX}${VER_PREFIX}*SimpleSumeSwitch.TB" -exec cp -r {} "${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/${VER_PREFIX}SimpleSumeSwitch.TB" \; -exec rm -R {} \;
	#-------------------------------------------------------------------------->DIRECTORY NAME
	find ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH} -name "*${VER_PREFIX}${VER_PREFIX}*.v.stub" -exec rename -v 's/${VER_PREFIX}${VER_PREFIX}/${VER_PREFIX}/i' {} \;
	#-------------------------------------------------------------------------->FILE NAME
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY GENERATED VER MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
config_writes:
	# PPL
	${SUME_SDNET}/bin/gen_config_writes.py ${SDNET_PPL_OUT_DIR}/${PPL_P4_SWITCH}/config_writes.txt ${P4_SWITCH_PPL_BASE_ADDR} ppl_testdata
	# DBG
	${SUME_SDNET}/bin/gen_config_writes.py ${SDNET_DBG_OUT_DIR}/${DBG_P4_SWITCH}/config_writes.txt ${P4_SWITCH_DBG_BASE_ADDR} dbg_testdata
	# VER
	${SUME_SDNET}/bin/gen_config_writes.py ${SDNET_VER_OUT_DIR}/${VER_P4_SWITCH}/config_writes.txt ${P4_SWITCH_VER_BASE_ADDR} ver_testdata

# install the SDNet core as a NetFPGA-SUME-SDNet library core 
install_sdnet: uninstall_sdnet install_ppl install_dbg install_ver

install_ppl:
	# PPL
	cp -r ${SDNET_PPL_OUT_DIR} ${TARGET}/
	mkdir -pv ${TARGET}/${SDNET_PPL_OUT_DIR}/wrapper
	cp ${SUME_SDNET}/templates/PPL_sss_wrapper/hdl/* ${TARGET}/${SDNET_PPL_OUT_DIR}/wrapper/
	cp ${SUME_SDNET}/templates/PPL_sss_wrapper/tcl/* ${TARGET}/${SDNET_PPL_OUT_DIR}/
	cp ${SUME_SDNET}/templates/PPL_sss_wrapper/Makefile ${TARGET}/${SDNET_PPL_OUT_DIR}/
	make -C ${TARGET}/${SDNET_PPL_OUT_DIR}/
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY INSTALLED PPL MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

install_dbg:
	# DBG
	cp -r ${SDNET_DBG_OUT_DIR} ${TARGET}/
	mkdir -pv ${TARGET}/${SDNET_DBG_OUT_DIR}/wrapper
	cp ${SUME_SDNET}/templates/DBG_sss_wrapper/hdl/* ${TARGET}/${SDNET_DBG_OUT_DIR}/wrapper/
	cp ${SUME_SDNET}/templates/DBG_sss_wrapper/tcl/* ${TARGET}/${SDNET_DBG_OUT_DIR}/
	cp ${SUME_SDNET}/templates/DBG_sss_wrapper/Makefile ${TARGET}/${SDNET_DBG_OUT_DIR}/
	make -C ${TARGET}/${SDNET_DBG_OUT_DIR}/
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY INSTALLED DBG MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

install_ver:
	# VER
	cp -r ${SDNET_VER_OUT_DIR} ${TARGET}/
	mkdir -pv ${TARGET}/${SDNET_VER_OUT_DIR}/wrapper
	cp ${SUME_SDNET}/templates/VER_sss_wrapper/hdl/* ${TARGET}/${SDNET_VER_OUT_DIR}/wrapper/
	cp ${SUME_SDNET}/templates/VER_sss_wrapper/tcl/* ${TARGET}/${SDNET_VER_OUT_DIR}/
	cp ${SUME_SDNET}/templates/VER_sss_wrapper/Makefile ${TARGET}/${SDNET_VER_OUT_DIR}/
	make -C ${TARGET}/${SDNET_VER_OUT_DIR}/
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	#SUCCESSFULLY INSTALLED VER MODULE
	#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

uninstall_sdnet:
	# PPL
	rm -rf ${TARGET}/${SDNET_PPL_OUT_DIR}
	# DBG
	rm -rf ${TARGET}/${SDNET_DBG_OUT_DIR}
	# VER
	rm -rf ${TARGET}/${SDNET_VER_OUT_DIR}

clean:
	make -C ppl_src/ clean
	make -C dbg_src/ clean
	make -C ver_src/ clean
	make -C ppl_testdata/ clean
	make -C dbg_testdata/ clean
	make -C ver_testdata/ clean
	rm -rf ${SDNET_PPL_OUT_DIR}/
	rm -rf ${SDNET_DBG_OUT_DIR}/
	rm -rf ${SDNET_VER_OUT_DIR}/
	rm -f $(shell find -name *.log -o -name *.jou)
	rm -f ppl_sw/config_tables.c
	rm -f dbg_sw/config_tables.c
	rm -f ver_sw/config_tables.c

cleansumelib:
	cd ${SUME_SDNET}/sw/sume &&	make clean
	cd ${P4_PROJECT_DIR}

sumelib:
	cd ${SUME_SDNET}/sw/sume &&	make
	cd ${P4_PROJECT_DIR}
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
	@echo "					SUCCESSFULLY COMPILED SUMELIB";
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
