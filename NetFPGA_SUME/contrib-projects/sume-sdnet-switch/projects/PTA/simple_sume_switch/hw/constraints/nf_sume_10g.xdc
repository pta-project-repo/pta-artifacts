
#
# Copyright (c) 2015 Noa Zilberman, Yury Audzevich
# All rights reserved.
#
#  File:
#        nf_sume_10g.xdc
#
#  Author: Noa Zilberman
#
#  Description:
#        Location constraints for 4x 10GbE SFP+ interface used in reference
#        projects.
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
# license agreements. See the NOTICE file distributed with this work for
# additional information regarding copyright ownership. NetFPGA licenses this
# file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at:
#
# http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@
#


# XGE-SFP0 -- SUME -- THE FIRST INTERFACE FROM THE TOP OF THE BOARD

set_property PACKAGE_PIN M18 [get_ports sfp0_tx_disable]
set_property IOSTANDARD LVCMOS15 [get_ports sfp0_tx_disable]
set_property PACKAGE_PIN M19 [get_ports sfp0_tx_fault]
set_property IOSTANDARD LVCMOS15 [get_ports sfp0_tx_fault]
set_property PACKAGE_PIN N18 [get_ports sfp0_tx_abs]

set_property IOSTANDARD LVCMOS15 [get_ports sfp0_tx_abs]
set_property LOC GTHE2_CHANNEL_X1Y39 [get_cells -hier -filter name=~*interface_0*gthe2_i]

# XGE-SFP1 -- SUME

set_property PACKAGE_PIN B31 [get_ports sfp1_tx_disable]
set_property IOSTANDARD LVCMOS15 [get_ports sfp1_tx_disable]
set_property PACKAGE_PIN C26 [get_ports sfp1_tx_fault]
set_property IOSTANDARD LVCMOS15 [get_ports sfp1_tx_fault]
set_property PACKAGE_PIN L19 [get_ports sfp1_tx_abs]
set_property IOSTANDARD LVCMOS15 [get_ports sfp1_tx_abs]

set_property LOC GTHE2_CHANNEL_X1Y38 [get_cells -hier -filter name=~*interface_1*gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y38 [get_cells nf_10g_interface_1/inst/nf_10g_interface_block_i/axi_10g_ethernet_i/inst/ten_gig_eth_pcs_pma/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_gth_10gbaser_i/gthe2_i]

# XGE-SFP2 -- SUME

set_property PACKAGE_PIN J38 [get_ports sfp2_tx_disable]
set_property IOSTANDARD LVCMOS15 [get_ports sfp2_tx_disable]
set_property PACKAGE_PIN E39 [get_ports sfp2_tx_fault]
set_property IOSTANDARD LVCMOS15 [get_ports sfp2_tx_fault]
set_property PACKAGE_PIN J37 [get_ports sfp2_tx_abs]
set_property IOSTANDARD LVCMOS15 [get_ports sfp2_tx_abs]

set_property LOC GTHE2_CHANNEL_X1Y37 [get_cells -hier -filter name=~*interface_2*gthe2_i]

# XGE-SFP3 -- SUME -- FIRST FROM THE BOTTOM (to PCIe)

set_property PACKAGE_PIN L21 [get_ports sfp3_tx_disable]
set_property IOSTANDARD LVCMOS15 [get_ports sfp3_tx_disable]
set_property PACKAGE_PIN J26 [get_ports sfp3_tx_fault]
set_property IOSTANDARD LVCMOS15 [get_ports sfp3_tx_fault]
set_property PACKAGE_PIN H36 [get_ports sfp3_tx_abs]
set_property IOSTANDARD LVCMOS15 [get_ports sfp3_tx_abs]

set_property LOC GTHE2_CHANNEL_X1Y36 [get_cells -hier -filter name=~*interface_3*gthe2_i]
#set_property LOC GTHE2_CHANNEL_X1Y36 [get_cells nf_10g_interface_3/inst/nf_10g_interface_block_i/axi_10g_ethernet_i/inst/ten_gig_eth_pcs_pma/inst/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_gth_10gbaser_i/gthe2_i]

## -- SFP clocks
## -- The clock is supplied by Si5324 chip;
## -- the clock is configured through microblaze.
set_property PACKAGE_PIN E10 [get_ports xphy_refclk_p]
set_property PACKAGE_PIN E9 [get_ports xphy_refclk_n]
create_clock -period 6.400 [get_ports xphy_refclk_p]

#create_clock -period 6.400 -name xgemac_clk_156 [get_ports xphy_refclk_p]

# XGE TX/RX LEDs
#   GRN - TX
#   YLW - RX
set_property PACKAGE_PIN G13 [get_ports sfp0_tx_led]
set_property PACKAGE_PIN AL22 [get_ports sfp1_tx_led]
set_property PACKAGE_PIN AY18 [get_ports sfp2_tx_led]
set_property PACKAGE_PIN P31 [get_ports sfp3_tx_led]

set_property PACKAGE_PIN L15 [get_ports sfp0_rx_led]
set_property PACKAGE_PIN BA20 [get_ports sfp1_rx_led]
set_property PACKAGE_PIN AY17 [get_ports sfp2_rx_led]
set_property PACKAGE_PIN K32 [get_ports sfp3_rx_led]

set_property IOSTANDARD LVCMOS15 [get_ports sfp?_?x_led]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets nf_10g_shared_i/inst/refclk]

## Timing Constraints
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_0*gthe2_i/RXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_0*gthe2_i/TXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_1*gthe2_i/RXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_1*gthe2_i/TXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_2*gthe2_i/RXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_2*gthe2_i/TXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_3*gthe2_i/RXOUTCLK]
create_clock -period 3.103 [get_pins -hier -filter name=~*interface_3*gthe2_i/TXOUTCLK]





## Timing Constraints

###################
## Other constraints
set_false_path -from [get_clocks xphy_refclk_p] -to [get_clocks clk_200]
set_false_path -from [get_clocks clk_200] -to [get_clocks xphy_refclk_p]

set_false_path -from [get_clocks clk_250mhz_mux_x0y1] -to [get_clocks clk_125mhz_x0y1]
set_false_path -from [get_clocks clk_125mhz_x0y1] -to [get_clocks clk_250mhz_mux_x0y1]

set_false_path -from [get_clocks userclk1] -to [get_clocks clk_200]
set_false_path -from [get_clocks clk_200] -to [get_clocks userclk1]

set_false_path -from [get_clocks userclk1] -to [get_clocks sys_clk]
set_false_path -from [get_clocks sys_clk] -to [get_clocks userclk1]

set_false_path -from [get_clocks userclk1] -to [get_clocks axi_clk]
set_false_path -from [get_clocks axi_clk] -to [get_clocks userclk1]

set_false_path -from [get_clocks userclk1] -to [get_clocks xphy_refclk_p]
set_false_path -from [get_clocks xphy_refclk_p] -to [get_clocks userclk1]

set_false_path -from [get_clocks -filter name=~*interface_*gthe2_i/RXOUTCLK] -to [get_clocks xphy_refclk_p]
set_false_path -from [get_clocks xphy_refclk_p] -to [get_clocks -filter name=~*interface_*gthe2_i/RXOUTCLK]

set_false_path -from [get_clocks -filter name=~*interface_*gthe2_i/TXOUTCLK] -to [get_clocks xphy_refclk_p]
set_false_path -from [get_clocks xphy_refclk_p] -to [get_clocks -filter name=~*interface_*gthe2_i/TXOUTCLK]




connect_debug_port u_ila_1/probe0 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[2]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[3]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[4]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[5]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[6]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[7]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[8]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[9]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[10]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[11]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[12]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[13]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[14]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[15]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[16]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[17]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[18]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[19]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[20]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[21]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[22]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[23]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[24]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[25]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[26]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[27]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[28]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[29]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[30]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_DATA_WR[31]}]]
connect_debug_port u_ila_1/probe1 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[2]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[3]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[4]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[5]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[6]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_ADDR[7]}]]
connect_debug_port u_ila_1/probe11 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_EN]]
connect_debug_port u_ila_1/probe12 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/p4_switch_inst/_CONTROL_P4_SWITCH__set_output_port_57_control_____set_output_port_57__control_RW]]

connect_debug_port u_ila_1/probe0 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[2]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[3]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[4]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[5]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[6]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[7]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[8]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[9]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[10]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[11]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[12]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[13]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[14]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[15]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[16]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[17]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[18]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[19]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[20]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[21]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[22]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[23]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[24]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[25]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[26]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[27]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[28]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[29]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[30]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_index[31]}]]
connect_debug_port u_ila_1/probe1 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/state_config_FSM[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/state_config_FSM[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/state_config_FSM[2]}]]
connect_debug_port u_ila_1/probe12 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_done]]
connect_debug_port u_ila_1/probe14 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/read_ack_debug]]
connect_debug_port u_ila_1/probe28 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/config_machine/write_ack_debug]]





connect_debug_port u_ila_0/probe0 [get_nets [list {nf_datapath_0/input_arbiter_v1_0/inst/in_arb_cur_queue[0]} {nf_datapath_0/input_arbiter_v1_0/inst/in_arb_cur_queue[1]} {nf_datapath_0/input_arbiter_v1_0/inst/in_arb_cur_queue[2]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[2]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[3]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[4]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[5]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[6]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[7]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[8]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[9]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[10]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[11]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[12]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[13]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[14]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[15]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[16]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[17]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[18]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[19]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[20]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[21]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[22]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[23]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[24]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[25]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[26]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[27]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[28]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[29]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[30]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[31]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[32]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[33]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[34]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[35]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[36]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[37]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[38]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[39]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[40]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[41]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[42]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[43]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[44]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[45]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[46]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[47]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[48]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[49]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[50]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[51]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[52]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[53]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[54]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[55]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[56]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[57]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[58]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[59]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[60]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[61]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[62]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[63]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[64]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[65]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[66]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[67]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[68]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[69]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[70]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[71]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[72]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[73]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[74]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[75]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[76]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[77]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[78]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[79]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[80]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[81]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[82]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[83]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[84]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[85]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[86]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[87]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[88]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[89]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[90]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[91]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[92]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[93]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[94]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[95]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[96]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[97]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[98]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[99]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[100]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[101]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[102]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[103]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[104]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[105]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[106]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[107]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[108]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[109]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[110]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[111]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[112]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[113]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[114]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[115]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[116]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[117]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[118]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[119]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[120]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[121]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[122]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[123]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[124]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[125]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[126]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/s_axis_tuser_swap[127]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[0]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[1]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[2]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[3]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[4]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[5]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[6]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[7]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[8]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[9]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[10]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[11]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[12]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[13]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[14]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[15]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[16]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[17]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[18]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[19]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[20]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[21]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[22]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[23]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[24]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[25]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[26]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[27]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[28]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[29]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[30]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[31]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[32]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[33]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[34]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[35]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[36]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[37]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[38]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[39]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[40]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[41]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[42]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[43]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[44]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[45]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[46]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[47]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[48]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[49]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[50]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[51]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[52]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[53]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[54]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[55]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[56]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[57]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[58]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[59]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[60]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[61]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[62]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[63]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[64]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[65]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[66]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[67]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[68]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[69]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[70]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[71]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[72]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[73]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[74]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[75]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[76]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[77]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[78]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[79]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[80]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[81]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[82]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[83]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[84]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[85]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[86]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[87]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[88]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[89]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[90]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[91]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[92]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[93]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[94]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[95]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[96]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[97]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[98]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[99]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[100]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[101]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[102]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[103]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[104]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[105]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[106]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[107]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[108]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[109]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[110]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[111]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[112]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[113]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[114]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[115]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[116]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[117]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[118]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[119]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[120]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[121]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[122]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[123]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[124]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[125]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[126]} {nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/m_axis_tuser_swap[127]}]]
connect_debug_port u_ila_0/probe36 [get_nets [list nf_datapath_0/input_arbiter_v1_0/inst/in_arb_state]]
connect_debug_port u_ila_0/probe46 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/tuple_in_VALID]]
connect_debug_port u_ila_0/probe47 [get_nets [list nf_datapath_0/nf_sume_sdnet_wrapper_1/inst/tuple_out_VALID]]

