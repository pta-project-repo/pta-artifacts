#
# Copyright (c) 2015 University of Cambridge
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
################################################################################
#  File:
#        Makefile
#
#  Project:
#        Makes all the cores of NetFPGA library
#
#  Description:
#        This makefile is used to generate and compile SDK project for NetFPGA reference projects.
#

# the first argument is target

SCRIPTS_DIR  = tools/
LIB_REPO = lib/hw/ip_repo
LIB_HW_DIR  = lib/hw
LIB_SW_DIR  = lib/sw
LIB_HW_DIR_INSTANCES := $(shell cd $(LIB_HW_DIR) && find . -maxdepth 4 -type d)
LIB_HW_DIR_INSTANCES := $(basename $(patsubst ./%,%,$(LIB_HW_DIR_INSTANCES)))
LIB_SW_DIR_INSTANCES := $(shell cd $(LIB_SW_DIR) && find . -maxdepth 4 -type d)
LIB_SW_DIR_INSTANCES := $(basename $(patsubst ./%,%,$(LIB_SW_DIR_INSTANCES)))

TOOLS_DIR = tools
TOOLS_DIR_INSTANCES := $(shell cd $(TOOLS_DIR) && find . -maxdepth 3 -type d)
TOOLS_DIR_INSTANCES := $(basename $(patsubst ./%,%,$(TOOLS_DIR_INSTANCES)))

PROJECTS_DIR = projects
PROJECTS_DIR_INSTANCES := $(shell cd $(PROJECTS_DIR) && find . -maxdepth 1 -type d)
PROJECTS_DIR_INSTANCES := $(basename $(patsubst ./%,%,$(PROJECTS_DIR_INSTANCES)))

DEVPROJECTS_DIR = dev-projects
DEVPROJECTS_DIR_INSTANCES := $(shell cd $(DEVPROJECTS_DIR) && find . -maxdepth 1 -type d)
DEVPROJECTS_DIR_INSTANCES := $(basename $(patsubst ./%,%,$(DEVPROJECTS_DIR_INSTANCES)))



RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
all:	clean sume hwtestlib stuff

clean: libclean toolsclean projectsclean hwtestlibclean swclean
	rm -rfv *.*~
	rm -f $(shell find -name vivado.log -o -name vivado.jou -o -name webtalk*.jou)

#sume:	devprojects
sume:
	make -C $(LIB_HW_DIR)/contrib/cores/nf_endianess_manager_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/fallthrough_small_fifo_v1_0_0/
	# make -C $(LIB_HW_DIR)/std/cores/input_arbiter_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/output_queues_v1_0_0/
	# make -C $(LIB_HW_DIR)/std/cores/router_output_port_lookup_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/switch_output_port_lookup_v1_0_1/
	# make -C $(LIB_HW_DIR)/std/cores/switch_lite_output_port_lookup_v1_0_0/
	# make -C $(LIB_HW_DIR)/std/cores/nic_output_port_lookup_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/nf_axis_converter_v1_0_0/.
	make -C $(LIB_HW_DIR)/std/cores/nf_riffa_dma_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/barrier_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/axis_sim_record_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/axis_sim_stim_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/axi_sim_transactor_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/barrier_gluelogic_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/identifier_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/nf_10ge_attachment_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/nf_10ge_interface_shared_v1_0_0/
	make -C $(LIB_HW_DIR)/std/cores/nf_10ge_interface_v1_0_0/
	make -C $(LIB_HW_DIR)/contrib/cores/sss_fallthrough_small_fifo_v1_0_0/
	make -C $(LIB_HW_DIR)/contrib/cores/nf_sume_splt_v1_0_0/
	make -C $(LIB_HW_DIR)/contrib/cores/nf_sume_pktgen_v1_0_0/
	make -C $(LIB_HW_DIR)/contrib/cores/input_arbiter_6in_v1_0_0/
	make -C $(LIB_HW_DIR)/contrib/cores/emudns_output_port_lookup_v1_0_0/
	@echo "/////////////////////////////////////////";
	@echo "//Library cores created.";
	@echo "/////////////////////////////////////////";




libclean:
	rm -rf $(LIB_REPO)
	for lib in $(LIB_HW_DIR_INSTANCES) ; do \
					if test -f $(LIB_HW_DIR)/$$lib/Makefile; \
						then $(MAKE) -C $(LIB_HW_DIR)/$$lib clean; \
					fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//Library cores cleaned.";
	@echo "/////////////////////////////////////////";


toolsclean:
	if test -f $(TOOLS_DIR)/Makefile; \
		then $(MAKE) -C $(TOOLS_DIR) clean; \
	fi; \

	@echo "/////////////////////////////////////////";
	@echo "//tools cleaned.";
	@echo "/////////////////////////////////////////";


projectsclean:
	for lib in $(PROJECTS_DIR_INSTANCES) ; do \
		if test -f $(PROJECTS_DIR)/$$lib/Makefile; \
			then $(MAKE) -C $(PROJECTS_DIR)/$$lib/ clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//projects cleaned.";
	@echo "/////////////////////////////////////////";


devprojectsclean:
	for lib in $(DEVPROJECTS_DIR_INSTANCES) ; do \
		if test -f $(DEVPROJECTS_DIR)/$$lib/Makefile; \
			then $(MAKE) -C $(DEVPROJECTS_DIR)/$$lib/ clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//devprojects cleaned.";
	@echo "/////////////////////////////////////////";

devprojects:
	for lib in $(DEVPROJECTS_DIR_INSTANCES) ; do \
		if test -f $(DEVPROJECTS_DIR)/$$lib/Makefile; \
			then $(MAKE) -C $(DEVPROJECTS_DIR)/$$lib/; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//devprojects cleaned.";
	@echo "/////////////////////////////////////////";

hwtestlib:
	$(MAKE) -C lib/sw/std/hwtestlib

hwtestlibclean:
	$(MAKE) -C lib/sw/std/hwtestlib clean

swclean:
	for swlib in $(LIB_SW_DIR_INSTANCES) ; do \
		if test -f $(LIB_SW_DIR)/$$swlib/Makefile; \
			then $(MAKE) -C $(LIB_SW_DIR)/$$swlib clean; \
		fi; \
	done;
	@echo "/////////////////////////////////////////";
	@echo "//SW Library cleaned.";
	@echo "/////////////////////////////////////////";

updatecams:
	cd ${XILINX_IP_FOLDER}/cam_v1_1_0 && make update
	cd ${XILINX_IP_FOLDER}/tcam_v1_1_0 && make update
	cd ${SUME_FOLDER}
	@echo "/////////////////////////////////////////";
	@echo "//Successfully updated CAM & TCAM";
	@echo "/////////////////////////////////////////";

cams:
	cd ${XILINX_IP_FOLDER}/cam_v1_1_0 && make
	cd ${XILINX_IP_FOLDER}/tcam_v1_1_0 && make
	cd ${SUME_FOLDER}
	@echo "/////////////////////////////////////////";
	@echo "//Successfully generated CAM & TCAM";
	@echo "/////////////////////////////////////////";

driver:
	cd ${DRIVER_FOLDER} && make
	cd ${DRIVER_FOLDER} && make modules_install
	cd ${SUME_FOLDER}
	@echo "/////////////////////////////////////////";
	@echo "//Successfully installed DRIVER";
	@echo "/////////////////////////////////////////";

rwaxi:
	cd ${RWAXI} && make
	cd ${SUME_FOLDER}
	@echo "/////////////////////////////////////////";
	@echo "//Successfully built RWAXI";
	@echo "/////////////////////////////////////////";

swsume:
	cd ${SUME_SDNET}/sw/sume && make
	cd ${SUME_FOLDER}
	@echo "/////////////////////////////////////////";
	@echo "//Successfully built LIBSUMEREG";
	@echo "/////////////////////////////////////////";

stuff: cams driver swsume rwaxi

sdnet:
	cd ${P4_PROJECT_DIR} && make
	cd ${SUME_FOLDER}

sume_prj:
	cd ${P4_PROJECT_DIR}/simple_sume_switch && make

p4prj: clean sume hwtestlib stuff sdnet sume_prj
