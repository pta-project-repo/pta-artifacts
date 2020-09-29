#
# Copyright (c) 2017 -, -
# All rights reserved.
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

# Vivado Launch Script
#### Change design settings here #######
set design splt
set top splt
set device xc7vx690t-3-ffg1761
set proj_dir ./ip_proj
set ip_version 1.00
set lib_name NetFPGA
#####################################
# set IP paths
#####################################
set axi_lite_ipif_ip_path ../../../xilinx/cores/axi_lite_ipif/source/
#####################################
# Project Settings
#####################################
create_project -name ${design} -force -dir "./${proj_dir}" -part ${device} -ip
set_property source_mgmt_mode All [current_project]  
set_property top ${top} [current_fileset]
set_property ip_repo_paths $::env(SUME_FOLDER)/lib/hw/  [current_fileset]
puts "Creating Splt IP"
# Project Constraints
#####################################
# Project Structure & IP Build
#####################################
read_verilog "./hdl/splt_cpu_regs_defines.v"
read_verilog "./hdl/splt_cpu_regs.v"
read_verilog "./hdl/splt.v"

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
ipx::package_project

set_property name ${design} [ipx::current_core]
set_property library ${lib_name} [ipx::current_core]
set_property vendor_display_name {NetFPGA} [ipx::current_core]
set_property company_url {http://www.netfpga.org} [ipx::current_core]
set_property vendor {NetFPGA} [ipx::current_core]
set_property supported_families {{virtex7} {Production}} [ipx::current_core]
set_property taxonomy {{/NetFPGA/Generic}} [ipx::current_core]
set_property version ${ip_version} [ipx::current_core]
set_property display_name ${design} [ipx::current_core]
set_property description ${design} [ipx::current_core]

ipx::add_user_parameter {C_M_AXIS_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property display_name {C_M_AXIS_DATA_WIDTH} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value {256} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_M_AXIS_DATA_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_M_AXIS_TUSER_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property display_name {C_M_AXIS_TUSER_WIDTH} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value {136} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_M_AXIS_TUSER_WIDTH [ipx::current_core]]

# ipx::add_user_parameter {NUM_QUEUES} [ipx::current_core]
# set_property value_resolve_type {user} [ipx::get_user_parameter NUM_QUEUES [ipx::current_core]]
# set_property display_name {NUM_QUEUES} [ipx::get_user_parameter NUM_QUEUES [ipx::current_core]]
# set_property value {1} [ipx::get_user_parameter NUM_QUEUES [ipx::current_core]]
# set_property value_format {long} [ipx::get_user_parameter NUM_QUEUES [ipx::current_core]]

ipx::add_user_parameter {C_S_AXI_DATA_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXI_DATA_WIDTH} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property value {32} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXI_DATA_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_S_AXI_ADDR_WIDTH} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property display_name {C_S_AXI_ADDR_WIDTH} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property value {32} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]
set_property value_format {long} [ipx::get_user_parameter C_S_AXI_ADDR_WIDTH [ipx::current_core]]

ipx::add_user_parameter {C_BASEADDR} [ipx::current_core]
set_property value_resolve_type {user} [ipx::get_user_parameter C_BASEADDR [ipx::current_core]]
set_property display_name {C_BASEADDR} [ipx::get_user_parameter C_BASEADDR [ipx::current_core]]
set_property value {0x00000000} [ipx::get_user_parameter C_BASEADDR [ipx::current_core]]
set_property value_format {bitstring} [ipx::get_user_parameter C_BASEADDR [ipx::current_core]]

ipx::add_subcore NetFPGA:NetFPGA:fallthrough_small_fifo:1.00 [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_subcore NetFPGA:NetFPGA:fallthrough_small_fifo:1.00 [ipx::get_file_groups xilinx_anylanguagebehavioralsimulation -of_objects [ipx::current_core]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m_axis_0 -of_objects [ipx::current_core]]

ipx::associate_bus_interfaces -busif m_axis_0 -clock axis_aclk [ipx::current_core]

ipx::infer_user_parameters [ipx::current_core]

ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
update_ip_catalog
close_project

file delete -force ${proj_dir} 
