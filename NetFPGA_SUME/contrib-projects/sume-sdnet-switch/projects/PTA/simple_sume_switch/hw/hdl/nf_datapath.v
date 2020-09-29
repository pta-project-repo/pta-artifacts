`timescale 1ns / 1ps
//-
// Copyright (c) 2015 Noa Zilberman
// All rights reserved.
//
// This software was developed by Stanford University and the University of Cambridge Computer Laboratory
// under National Science Foundation under Grant No. CNS-0855268,
// the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
// by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"),
// as part of the DARPA MRC research programme.
//
//  File:
//        nf_datapath.v
//
//  Module:
//        nf_datapath
//
//  Author: Noa Zilberman
//
//  Description:
//        NetFPGA user data path wrapper, wrapping input arbiter, output port lookup and output queues
//
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  NetFPGA licenses this
// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.netfpga-cic.org
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
//


module nf_datapath #(
    //Slave AXI parameters
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 32,
    parameter C_BASEADDR            = 32'h00000000,

    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH=256,
    parameter C_S_AXIS_DATA_WIDTH=256,
    parameter C_M_AXIS_TUSER_WIDTH=128,
    parameter C_S_AXIS_TUSER_WIDTH=128,
    parameter NUM_QUEUES=5,
    parameter DIGEST_WIDTH =80
)
(
    //Datapath clock
    input                                     axis_aclk,
    input                                     axis_resetn,
    //Registers clock
    input                                     axi_aclk,
    input                                     axi_resetn,

    // Slave AXI Ports
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S0_AXI_AWADDR,
    input                                     S0_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S0_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S0_AXI_WSTRB,
    input                                     S0_AXI_WVALID,
    input                                     S0_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S0_AXI_ARADDR,
    input                                     S0_AXI_ARVALID,
    input                                     S0_AXI_RREADY,
    output                                    S0_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S0_AXI_RDATA,
    output     [1 : 0]                        S0_AXI_RRESP,
    output                                    S0_AXI_RVALID,
    output                                    S0_AXI_WREADY,
    output     [1 :0]                         S0_AXI_BRESP,
    output                                    S0_AXI_BVALID,
    output                                    S0_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S1_AXI_AWADDR,
    input                                     S1_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S1_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S1_AXI_WSTRB,
    input                                     S1_AXI_WVALID,
    input                                     S1_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S1_AXI_ARADDR,
    input                                     S1_AXI_ARVALID,
    input                                     S1_AXI_RREADY,
    output                                    S1_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S1_AXI_RDATA,
    output     [1 : 0]                        S1_AXI_RRESP,
    output                                    S1_AXI_RVALID,
    output                                    S1_AXI_WREADY,
    output     [1 :0]                         S1_AXI_BRESP,
    output                                    S1_AXI_BVALID,
    output                                    S1_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S2_AXI_AWADDR,
    input                                     S2_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S2_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S2_AXI_WSTRB,
    input                                     S2_AXI_WVALID,
    input                                     S2_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S2_AXI_ARADDR,
    input                                     S2_AXI_ARVALID,
    input                                     S2_AXI_RREADY,
    output                                    S2_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S2_AXI_RDATA,
    output     [1 : 0]                        S2_AXI_RRESP,
    output                                    S2_AXI_RVALID,
    output                                    S2_AXI_WREADY,
    output     [1 :0]                         S2_AXI_BRESP,
    output                                    S2_AXI_BVALID,
    output                                    S2_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S3_AXI_AWADDR,
    input                                     S3_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S3_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S3_AXI_WSTRB,
    input                                     S3_AXI_WVALID,
    input                                     S3_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S3_AXI_ARADDR,
    input                                     S3_AXI_ARVALID,
    input                                     S3_AXI_RREADY,
    output                                    S3_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S3_AXI_RDATA,
    output     [1 : 0]                        S3_AXI_RRESP,
    output                                    S3_AXI_RVALID,
    output                                    S3_AXI_WREADY,
    output     [1 :0]                         S3_AXI_BRESP,
    output                                    S3_AXI_BVALID,
    output                                    S3_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S4_AXI_AWADDR,
    input                                     S4_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S4_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S4_AXI_WSTRB,
    input                                     S4_AXI_WVALID,
    input                                     S4_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S4_AXI_ARADDR,
    input                                     S4_AXI_ARVALID,
    input                                     S4_AXI_RREADY,
    output                                    S4_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S4_AXI_RDATA,
    output     [1 : 0]                        S4_AXI_RRESP,
    output                                    S4_AXI_RVALID,
    output                                    S4_AXI_WREADY,
    output     [1 :0]                         S4_AXI_BRESP,
    output                                    S4_AXI_BVALID,
    output                                    S4_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S5_AXI_AWADDR,
    input                                     S5_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S5_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S5_AXI_WSTRB,
    input                                     S5_AXI_WVALID,
    input                                     S5_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S5_AXI_ARADDR,
    input                                     S5_AXI_ARVALID,
    input                                     S5_AXI_RREADY,
    output                                    S5_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S5_AXI_RDATA,
    output     [1 : 0]                        S5_AXI_RRESP,
    output                                    S5_AXI_RVALID,
    output                                    S5_AXI_WREADY,
    output     [1 :0]                         S5_AXI_BRESP,
    output                                    S5_AXI_BVALID,
    output                                    S5_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S6_AXI_AWADDR,
    input                                     S6_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S6_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S6_AXI_WSTRB,
    input                                     S6_AXI_WVALID,
    input                                     S6_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S6_AXI_ARADDR,
    input                                     S6_AXI_ARVALID,
    input                                     S6_AXI_RREADY,
    output                                    S6_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S6_AXI_RDATA,
    output     [1 : 0]                        S6_AXI_RRESP,
    output                                    S6_AXI_RVALID,
    output                                    S6_AXI_WREADY,
    output     [1 :0]                         S6_AXI_BRESP,
    output                                    S6_AXI_BVALID,
    output                                    S6_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S7_AXI_AWADDR,
    input                                     S7_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S7_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S7_AXI_WSTRB,
    input                                     S7_AXI_WVALID,
    input                                     S7_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S7_AXI_ARADDR,
    input                                     S7_AXI_ARVALID,
    input                                     S7_AXI_RREADY,
    output                                    S7_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S7_AXI_RDATA,
    output     [1 : 0]                        S7_AXI_RRESP,
    output                                    S7_AXI_RVALID,
    output                                    S7_AXI_WREADY,
    output     [1 :0]                         S7_AXI_BRESP,
    output                                    S7_AXI_BVALID,
    output                                    S7_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S8_AXI_AWADDR,
    input                                     S8_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S8_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S8_AXI_WSTRB,
    input                                     S8_AXI_WVALID,
    input                                     S8_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S8_AXI_ARADDR,
    input                                     S8_AXI_ARVALID,
    input                                     S8_AXI_RREADY,
    output                                    S8_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S8_AXI_RDATA,
    output     [1 : 0]                        S8_AXI_RRESP,
    output                                    S8_AXI_RVALID,
    output                                    S8_AXI_WREADY,
    output     [1 :0]                         S8_AXI_BRESP,
    output                                    S8_AXI_BVALID,
    output                                    S8_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S9_AXI_AWADDR,
    input                                     S9_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S9_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S9_AXI_WSTRB,
    input                                     S9_AXI_WVALID,
    input                                     S9_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S9_AXI_ARADDR,
    input                                     S9_AXI_ARVALID,
    input                                     S9_AXI_RREADY,
    output                                    S9_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S9_AXI_RDATA,
    output     [1 : 0]                        S9_AXI_RRESP,
    output                                    S9_AXI_RVALID,
    output                                    S9_AXI_WREADY,
    output     [1 :0]                         S9_AXI_BRESP,
    output                                    S9_AXI_BVALID,
    output                                    S9_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S10_AXI_AWADDR,
    input                                     S10_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S10_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S10_AXI_WSTRB,
    input                                     S10_AXI_WVALID,
    input                                     S10_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S10_AXI_ARADDR,
    input                                     S10_AXI_ARVALID,
    input                                     S10_AXI_RREADY,
    output                                    S10_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S10_AXI_RDATA,
    output     [1 : 0]                        S10_AXI_RRESP,
    output                                    S10_AXI_RVALID,
    output                                    S10_AXI_WREADY,
    output     [1 :0]                         S10_AXI_BRESP,
    output                                    S10_AXI_BVALID,
    output                                    S10_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S11_AXI_AWADDR,
    input                                     S11_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S11_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S11_AXI_WSTRB,
    input                                     S11_AXI_WVALID,
    input                                     S11_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S11_AXI_ARADDR,
    input                                     S11_AXI_ARVALID,
    input                                     S11_AXI_RREADY,
    output                                    S11_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S11_AXI_RDATA,
    output     [1 : 0]                        S11_AXI_RRESP,
    output                                    S11_AXI_RVALID,
    output                                    S11_AXI_WREADY,
    output     [1 :0]                         S11_AXI_BRESP,
    output                                    S11_AXI_BVALID,
    output                                    S11_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S12_AXI_AWADDR,
    input                                     S12_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S12_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S12_AXI_WSTRB,
    input                                     S12_AXI_WVALID,
    input                                     S12_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S12_AXI_ARADDR,
    input                                     S12_AXI_ARVALID,
    input                                     S12_AXI_RREADY,
    output                                    S12_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S12_AXI_RDATA,
    output     [1 : 0]                        S12_AXI_RRESP,
    output                                    S12_AXI_RVALID,
    output                                    S12_AXI_WREADY,
    output     [1 :0]                         S12_AXI_BRESP,
    output                                    S12_AXI_BVALID,
    output                                    S12_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S13_AXI_AWADDR,
    input                                     S13_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S13_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S13_AXI_WSTRB,
    input                                     S13_AXI_WVALID,
    input                                     S13_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S13_AXI_ARADDR,
    input                                     S13_AXI_ARVALID,
    input                                     S13_AXI_RREADY,
    output                                    S13_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S13_AXI_RDATA,
    output     [1 : 0]                        S13_AXI_RRESP,
    output                                    S13_AXI_RVALID,
    output                                    S13_AXI_WREADY,
    output     [1 :0]                         S13_AXI_BRESP,
    output                                    S13_AXI_BVALID,
    output                                    S13_AXI_AWREADY,

    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S14_AXI_AWADDR,
    input                                     S14_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S14_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S14_AXI_WSTRB,
    input                                     S14_AXI_WVALID,
    input                                     S14_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S14_AXI_ARADDR,
    input                                     S14_AXI_ARVALID,
    input                                     S14_AXI_RREADY,
    output                                    S14_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S14_AXI_RDATA,
    output     [1 : 0]                        S14_AXI_RRESP,
    output                                    S14_AXI_RVALID,
    output                                    S14_AXI_WREADY,
    output     [1 :0]                         S14_AXI_BRESP,
    output                                    S14_AXI_BVALID,
    output                                    S14_AXI_AWREADY,

    // Slave Stream Ports (interface from Rx queues)
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_0_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_0_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_0_tuser,
    input                                     s_axis_0_tvalid,
    output                                    s_axis_0_tready,
    input                                     s_axis_0_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_1_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_1_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_1_tuser,
    input                                     s_axis_1_tvalid,
    output                                    s_axis_1_tready,
    input                                     s_axis_1_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_2_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_2_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_2_tuser,
    input                                     s_axis_2_tvalid,
    output                                    s_axis_2_tready,
    input                                     s_axis_2_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_3_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_3_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_3_tuser,
    input                                     s_axis_3_tvalid,
    output                                    s_axis_3_tready,
    input                                     s_axis_3_tlast,
    input [C_S_AXIS_DATA_WIDTH - 1:0]         s_axis_4_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_4_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_4_tuser,
    input                                     s_axis_4_tvalid,
    output                                    s_axis_4_tready,
    input                                     s_axis_4_tlast,


    // Master Stream Ports (interface to TX queues)
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_0_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_0_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_0_tuser,
    output                                     m_axis_0_tvalid,
    input                                      m_axis_0_tready,
    output                                     m_axis_0_tlast,

    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_1_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_1_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_1_tuser,
    output                                     m_axis_1_tvalid,
    input                                      m_axis_1_tready,
    output                                     m_axis_1_tlast,

    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_2_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_2_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_2_tuser,
    output                                     m_axis_2_tvalid,
    input                                      m_axis_2_tready,
    output                                     m_axis_2_tlast
    ,
    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_3_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_3_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_3_tuser,
    output                                     m_axis_3_tvalid,
    input                                      m_axis_3_tready,
    output                                     m_axis_3_tlast,

    output [C_M_AXIS_DATA_WIDTH - 1:0]         m_axis_4_tdata,
    output [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_4_tkeep,
    output [C_M_AXIS_TUSER_WIDTH-1:0]          m_axis_4_tuser,
    output                                     m_axis_4_tvalid,
    input                                      m_axis_4_tready,
    output                                     m_axis_4_tlast


    );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             QUEUE SIZE
    //////////////////////////////////////////////////////////////////////////////////////

    localparam Q_SIZE_WIDTH = 16;
    (* mark_debug = "true" *) wire [Q_SIZE_WIDTH-1:0]    nf0_q_size;
    (* mark_debug = "true" *) wire [Q_SIZE_WIDTH-1:0]    nf1_q_size;
    (* mark_debug = "true" *) wire [Q_SIZE_WIDTH-1:0]    nf2_q_size;
    (* mark_debug = "true" *) wire [Q_SIZE_WIDTH-1:0]    nf3_q_size;
    (* mark_debug = "true" *) wire [Q_SIZE_WIDTH-1:0]    dma_q_size;

    //////////////////////////////////////////////////////////////////////////////////////
    ///             INTERNAL CONNECTIVITY
    //////////////////////////////////////////////////////////////////////////////////////

    // -: PKTG --> DBG
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         pktg_dbg_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] pktg_dbg_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  pktg_dbg_tuser;
    wire                                     pktg_dbg_tvalid;
    wire                                     pktg_dbg_tready;
    wire                                     pktg_dbg_tlast;

    // -: DBG --> IA
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         dbg_ia_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] dbg_ia_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  dbg_ia_tuser;
    wire                                     dbg_ia_tvalid;
    wire                                     dbg_ia_tready;
    wire                                     dbg_ia_tlast;

    // -: IA --> PPL
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         ia_ppl_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] ia_ppl_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  ia_ppl_tuser;
    wire                                     ia_ppl_tvalid;
    wire                                     ia_ppl_tready;
    wire                                     ia_ppl_tlast;

    // -: PPL --> SPLT
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         ppl_splt_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] ppl_splt_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  ppl_splt_tuser;
    wire                                     ppl_splt_tvalid;
    wire                                     ppl_splt_tready;
    wire                                     ppl_splt_tlast;

    // -: SPLT --> OQS
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         splt_oqs_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] splt_oqs_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  splt_oqs_tuser;
    wire                                     splt_oqs_tvalid;
    wire                                     splt_oqs_tready;
    wire                                     splt_oqs_tlast;

    // -: SPLT --> VER
    wire [C_M_AXIS_DATA_WIDTH - 1:0]         splt_ver_tdata;
    wire [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] splt_ver_tkeep;
    wire [((C_M_AXIS_TUSER_WIDTH + 128)-1):0]  splt_ver_tuser;
    wire                                     splt_ver_tvalid;
    wire                                     splt_ver_tready;
    wire                                     splt_ver_tlast;

    //////////////////////////////////////////////////////////////////////////////////////
    ///             PACKET GENERATOR (PKTGEN)
    //////////////////////////////////////////////////////////////////////////////////////

    nf_sume_pktgen_ip
    nf_sume_pktgen_ip_inst(

      .axis_aclk              (axis_aclk),
      .axis_resetn            (axis_resetn),

      .m_axis_0_tdata         (pktg_dbg_tdata),
      .m_axis_0_tkeep         (pktg_dbg_tkeep),
      .m_axis_0_tuser         (pktg_dbg_tuser),
      .m_axis_0_tvalid        (pktg_dbg_tvalid),
      .m_axis_0_tready        (pktg_dbg_tready),
      .m_axis_0_tlast         (pktg_dbg_tlast),

      .S_AXI_ACLK             (axi_aclk),
      .S_AXI_ARESETN          (axi_resetn),

      .S_AXI_AWADDR           (S3_AXI_AWADDR),
      .S_AXI_AWVALID          (S3_AXI_AWVALID),
      .S_AXI_WDATA            (S3_AXI_WDATA),
      .S_AXI_WSTRB            (S3_AXI_WSTRB),
      .S_AXI_WVALID           (S3_AXI_WVALID),
      .S_AXI_BREADY           (S3_AXI_BREADY),
      .S_AXI_ARADDR           (S3_AXI_ARADDR),
      .S_AXI_ARVALID          (S3_AXI_ARVALID),
      .S_AXI_RREADY           (S3_AXI_RREADY),
      .S_AXI_ARREADY          (S3_AXI_ARREADY),
      .S_AXI_RDATA            (S3_AXI_RDATA),
      .S_AXI_RRESP            (S3_AXI_RRESP),
      .S_AXI_RVALID           (S3_AXI_RVALID),
      .S_AXI_WREADY           (S3_AXI_WREADY),
      .S_AXI_BRESP            (S3_AXI_BRESP),
      .S_AXI_BVALID           (S3_AXI_BVALID),
      .S_AXI_AWREADY          (S3_AXI_AWREADY)

      );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             DEBUG PIPELINE (DBG)
    //////////////////////////////////////////////////////////////////////////////////////

    nf_sume_sdnet_dbg_ip
    nf_sume_sdnet_dbg_inst(

      .axis_aclk(axis_aclk),
      .axis_resetn(axis_resetn),

      .m_axis_tdata (dbg_ia_tdata),
      .m_axis_tkeep (dbg_ia_tkeep),
      .m_axis_tuser (dbg_ia_tuser),
      .m_axis_tvalid(dbg_ia_tvalid),
      .m_axis_tready(dbg_ia_tready),
      .m_axis_tlast (dbg_ia_tlast),

      .s_axis_tdata (pktg_dbg_tdata),
      .s_axis_tkeep (pktg_dbg_tkeep),
      .s_axis_tuser ({dma_q_size, nf3_q_size, nf2_q_size, nf1_q_size, nf0_q_size, pktg_dbg_tuser[C_M_AXIS_TUSER_WIDTH+128-DIGEST_WIDTH-1:0]}), // +128 to include the metadata fields
      .s_axis_tvalid(pktg_dbg_tvalid),
      .s_axis_tready(pktg_dbg_tready),
      .s_axis_tlast (pktg_dbg_tlast),

      .S_AXI_AWADDR(S5_AXI_AWADDR),
      .S_AXI_AWVALID(S5_AXI_AWVALID),
      .S_AXI_WDATA(S5_AXI_WDATA),
      .S_AXI_WSTRB(S5_AXI_WSTRB),
      .S_AXI_WVALID(S5_AXI_WVALID),
      .S_AXI_BREADY(S5_AXI_BREADY),
      .S_AXI_ARADDR(S5_AXI_ARADDR),
      .S_AXI_ARVALID(S5_AXI_ARVALID),
      .S_AXI_RREADY(S5_AXI_RREADY),
      .S_AXI_ARREADY(S5_AXI_ARREADY),
      .S_AXI_RDATA(S5_AXI_RDATA),
      .S_AXI_RRESP(S5_AXI_RRESP),
      .S_AXI_RVALID(S5_AXI_RVALID),
      .S_AXI_WREADY(S5_AXI_WREADY),
      .S_AXI_BRESP(S5_AXI_BRESP),
      .S_AXI_BVALID(S5_AXI_BVALID),
      .S_AXI_AWREADY(S5_AXI_AWREADY),

      .S_AXI_ACLK (axi_aclk),
      .S_AXI_ARESETN(axi_resetn)

    );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             INPUT ARBITER 6 INPUTS
    //////////////////////////////////////////////////////////////////////////////////////

       input_arbiter_6in_ip
       input_arbiter_6in_ip_inst (

            .axis_aclk(axis_aclk),
            .axis_resetn(axis_resetn),

            .m_axis_tdata (ia_ppl_tdata),
            .m_axis_tkeep (ia_ppl_tkeep),
            .m_axis_tuser (ia_ppl_tuser),
            .m_axis_tvalid(ia_ppl_tvalid),
            .m_axis_tready(ia_ppl_tready),
            .m_axis_tlast (ia_ppl_tlast),

            .s_axis_0_tdata (s_axis_0_tdata),
            .s_axis_0_tkeep (s_axis_0_tkeep),
            .s_axis_0_tuser (s_axis_0_tuser),
            .s_axis_0_tvalid(s_axis_0_tvalid),
            .s_axis_0_tready(s_axis_0_tready),
            .s_axis_0_tlast (s_axis_0_tlast),

            .s_axis_1_tdata (s_axis_1_tdata),
            .s_axis_1_tkeep (s_axis_1_tkeep),
            .s_axis_1_tuser (s_axis_1_tuser),
            .s_axis_1_tvalid(s_axis_1_tvalid),
            .s_axis_1_tready(s_axis_1_tready),
            .s_axis_1_tlast (s_axis_1_tlast),

            .s_axis_2_tdata (s_axis_2_tdata),
            .s_axis_2_tkeep (s_axis_2_tkeep),
            .s_axis_2_tuser (s_axis_2_tuser),
            .s_axis_2_tvalid(s_axis_2_tvalid),
            .s_axis_2_tready(s_axis_2_tready),
            .s_axis_2_tlast (s_axis_2_tlast),

            .s_axis_3_tdata (s_axis_3_tdata),
            .s_axis_3_tkeep (s_axis_3_tkeep),
            .s_axis_3_tuser (s_axis_3_tuser),
            .s_axis_3_tvalid(s_axis_3_tvalid),
            .s_axis_3_tready(s_axis_3_tready),
            .s_axis_3_tlast (s_axis_3_tlast),

            .s_axis_4_tdata (s_axis_4_tdata),
            .s_axis_4_tkeep (s_axis_4_tkeep),
            .s_axis_4_tuser (s_axis_4_tuser),
            .s_axis_4_tvalid(s_axis_4_tvalid),
            .s_axis_4_tready(s_axis_4_tready),
            .s_axis_4_tlast (s_axis_4_tlast),

            // -
            .s_axis_5_tdata (dbg_ia_tdata),
            .s_axis_5_tkeep (dbg_ia_tkeep),
            .s_axis_5_tuser (dbg_ia_tuser),
            .s_axis_5_tvalid(dbg_ia_tvalid),
            .s_axis_5_tready(dbg_ia_tready),
            .s_axis_5_tlast (dbg_ia_tlast),

            .S_AXI_AWADDR(S0_AXI_AWADDR),
            .S_AXI_AWVALID(S0_AXI_AWVALID),
            .S_AXI_WDATA(S0_AXI_WDATA),
            .S_AXI_WSTRB(S0_AXI_WSTRB),
            .S_AXI_WVALID(S0_AXI_WVALID),
            .S_AXI_BREADY(S0_AXI_BREADY),
            .S_AXI_ARADDR(S0_AXI_ARADDR),
            .S_AXI_ARVALID(S0_AXI_ARVALID),
            .S_AXI_RREADY(S0_AXI_RREADY),
            .S_AXI_ARREADY(S0_AXI_ARREADY),
            .S_AXI_RDATA(S0_AXI_RDATA),
            .S_AXI_RRESP(S0_AXI_RRESP),
            .S_AXI_RVALID(S0_AXI_RVALID),
            .S_AXI_WREADY(S0_AXI_WREADY),
            .S_AXI_BRESP(S0_AXI_BRESP),
            .S_AXI_BVALID(S0_AXI_BVALID),
            .S_AXI_AWREADY(S0_AXI_AWREADY),
            .S_AXI_ACLK (axi_aclk),
            .S_AXI_ARESETN(axi_resetn),
            .pkt_fwd()
          );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             OUTPUT PORT LOOKUP (PPL)
    //////////////////////////////////////////////////////////////////////////////////////

    output_port_lookup_ip
    output_port_lookup_ip_inst
    (

      .axis_aclk(axis_aclk),
      .axis_resetn(axis_resetn),

      .m_axis_tdata (ppl_splt_tdata),
      .m_axis_tkeep (ppl_splt_tkeep),
      .m_axis_tuser (ppl_splt_tuser),
      .m_axis_tvalid(ppl_splt_tvalid),
      .m_axis_tready(ppl_splt_tready),
      .m_axis_tlast (ppl_splt_tlast),

      .s_axis_tdata (ia_ppl_tdata),
      .s_axis_tkeep (ia_ppl_tkeep),
      .s_axis_tuser ({dma_q_size, nf3_q_size, nf2_q_size, nf1_q_size, nf0_q_size, ia_ppl_tuser[C_M_AXIS_TUSER_WIDTH+128-DIGEST_WIDTH-1:0]}), // +128 to include the metadata fields
      .s_axis_tvalid(ia_ppl_tvalid),
      .s_axis_tready(ia_ppl_tready),
      .s_axis_tlast (ia_ppl_tlast),

      .S_AXI_AWADDR(S1_AXI_AWADDR),
      .S_AXI_AWVALID(S1_AXI_AWVALID),
      .S_AXI_WDATA(S1_AXI_WDATA),
      .S_AXI_WSTRB(S1_AXI_WSTRB),
      .S_AXI_WVALID(S1_AXI_WVALID),
      .S_AXI_BREADY(S1_AXI_BREADY),
      .S_AXI_ARADDR(S1_AXI_ARADDR),
      .S_AXI_ARVALID(S1_AXI_ARVALID),
      .S_AXI_RREADY(S1_AXI_RREADY),
      .S_AXI_ARREADY(S1_AXI_ARREADY),
      .S_AXI_RDATA(S1_AXI_RDATA),
      .S_AXI_RRESP(S1_AXI_RRESP),
      .S_AXI_RVALID(S1_AXI_RVALID),
      .S_AXI_WREADY(S1_AXI_WREADY),
      .S_AXI_BRESP(S1_AXI_BRESP),
      .S_AXI_BVALID(S1_AXI_BVALID),
      .S_AXI_AWREADY(S1_AXI_AWREADY),

      .S_AXI_ACLK (axi_aclk),
      .S_AXI_ARESETN(axi_resetn)

    );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             SPLITTER (SPLT)
    //////////////////////////////////////////////////////////////////////////////////////

    splt_ip
    splt_ip_inst  (

    // Global Ports
    .axis_aclk   (axis_aclk),
    .axis_resetn (axis_resetn),

    .m_axis_0_tdata       (splt_oqs_tdata),
    .m_axis_0_tkeep       (splt_oqs_tkeep),
    .m_axis_0_tuser       (splt_oqs_tuser),
    .m_axis_0_tvalid      (splt_oqs_tvalid),
    .m_axis_0_tready      (splt_oqs_tready),
    .m_axis_0_tlast       (splt_oqs_tlast),

    .m_axis_1_tdata       (splt_ver_tdata),
    .m_axis_1_tkeep       (splt_ver_tkeep),
    .m_axis_1_tuser       (splt_ver_tuser),
    .m_axis_1_tvalid      (splt_ver_tvalid),
    .m_axis_1_tready      (splt_ver_tready),
    .m_axis_1_tlast       (splt_ver_tlast),

    .s_axis_0_tdata       (ppl_splt_tdata),
    .s_axis_0_tkeep       (ppl_splt_tkeep),
    .s_axis_0_tuser       (ppl_splt_tuser),
    .s_axis_0_tvalid      (ppl_splt_tvalid),
    .s_axis_0_tready      (ppl_splt_tready),
    .s_axis_0_tlast       (ppl_splt_tlast),

    // Slave AXI Ports
    .S_AXI_ACLK          (S8_AXI_ACLK),
    .S_AXI_ARESETN       (S8_AXI_ARESETN),
    .S_AXI_AWADDR        (S8_AXI_AWADDR),
    .S_AXI_AWVALID       (S8_AXI_AWVALID),
    .S_AXI_WDATA         (S8_AXI_WDATA),
    .S_AXI_WSTRB         (S8_AXI_WSTRB),
    .S_AXI_WVALID        (S8_AXI_WVALID),
    .S_AXI_BREADY        (S8_AXI_BREADY),
    .S_AXI_ARADDR        (S8_AXI_ARADDR),
    .S_AXI_ARVALID       (S8_AXI_ARVALID),
    .S_AXI_RREADY        (S8_AXI_RREADY),
    .S_AXI_ARREADY       (S8_AXI_ARREADY),
    .S_AXI_RDATA         (S8_AXI_RDATA),
    .S_AXI_RRESP         (S8_AXI_RRESP),
    .S_AXI_RVALID        (S8_AXI_RVALID),
    .S_AXI_WREADY        (S8_AXI_WREADY),
    .S_AXI_BRESP         (S8_AXI_BRESP),
    .S_AXI_BVALID        (S8_AXI_BVALID),
    .S_AXI_AWREADY       (S8_AXI_AWREADY)

    );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             VERIFIER PIPELINE (VER)
    //////////////////////////////////////////////////////////////////////////////////////

    nf_sume_sdnet_ver_ip
    nf_sume_sdnet_ver_inst  (

      .axis_aclk(axis_aclk),
      .axis_resetn(axis_resetn),

      .m_axis_tdata (/*N.C.*/),
      .m_axis_tkeep (/*N.C.*/),
      .m_axis_tuser (/*N.C.*/),
      .m_axis_tvalid(/*N.C.*/),
      .m_axis_tready(1'b1),
      .m_axis_tlast (/*N.C.*/),

      .s_axis_tdata (splt_ver_tdata),
      .s_axis_tkeep (splt_ver_tkeep),
      .s_axis_tuser ({dma_q_size, nf3_q_size, nf2_q_size, nf1_q_size, nf0_q_size, splt_ver_tuser[C_M_AXIS_TUSER_WIDTH+128-DIGEST_WIDTH-1:0]}), // +128 to include the metadata fields
      .s_axis_tvalid(splt_ver_tvalid),
      .s_axis_tready(splt_ver_tready),
      .s_axis_tlast (splt_ver_tlast),

      .S_AXI_AWADDR(S7_AXI_AWADDR),
      .S_AXI_AWVALID(S7_AXI_AWVALID),
      .S_AXI_WDATA(S7_AXI_WDATA),
      .S_AXI_WSTRB(S7_AXI_WSTRB),
      .S_AXI_WVALID(S7_AXI_WVALID),
      .S_AXI_BREADY(S7_AXI_BREADY),
      .S_AXI_ARADDR(S7_AXI_ARADDR),
      .S_AXI_ARVALID(S7_AXI_ARVALID),
      .S_AXI_RREADY(S7_AXI_RREADY),
      .S_AXI_ARREADY(S7_AXI_ARREADY),
      .S_AXI_RDATA(S7_AXI_RDATA),
      .S_AXI_RRESP(S7_AXI_RRESP),
      .S_AXI_RVALID(S7_AXI_RVALID),
      .S_AXI_WREADY(S7_AXI_WREADY),
      .S_AXI_BRESP(S7_AXI_BRESP),
      .S_AXI_BVALID(S7_AXI_BVALID),
      .S_AXI_AWREADY(S7_AXI_AWREADY),

      .S_AXI_ACLK (axi_aclk),
      .S_AXI_ARESETN(axi_resetn)

    );

    //////////////////////////////////////////////////////////////////////////////////////
    ///             OUTPUT QUEUES (OQS)
    //////////////////////////////////////////////////////////////////////////////////////

    (* mark_debug = "true" *) wire [C_S_AXI_DATA_WIDTH-1:0] bytes_dropped;
    (* mark_debug = "true" *) wire [5-1:0] pkt_dropped;

    //Output queues
    output_queues_ip
    output_queues_inst (

      .axis_aclk(axis_aclk),
      .axis_resetn(axis_resetn),

      .s_axis_tdata   (splt_oqs_tdata),
      .s_axis_tkeep   (splt_oqs_tkeep),
      .s_axis_tuser   (splt_oqs_tuser),
      .s_axis_tvalid  (splt_oqs_tvalid),
      .s_axis_tready  (splt_oqs_tready),
      .s_axis_tlast   (splt_oqs_tlast),

      .m_axis_0_tdata (m_axis_0_tdata),
      .m_axis_0_tkeep (m_axis_0_tkeep),
      .m_axis_0_tuser (m_axis_0_tuser),
      .m_axis_0_tvalid(m_axis_0_tvalid),
      .m_axis_0_tready(m_axis_0_tready),
      .m_axis_0_tlast (m_axis_0_tlast),

      .m_axis_1_tdata (m_axis_1_tdata),
      .m_axis_1_tkeep (m_axis_1_tkeep),
      .m_axis_1_tuser (m_axis_1_tuser),
      .m_axis_1_tvalid(m_axis_1_tvalid),
      .m_axis_1_tready(m_axis_1_tready),
      .m_axis_1_tlast (m_axis_1_tlast),

      .m_axis_2_tdata (m_axis_2_tdata),
      .m_axis_2_tkeep (m_axis_2_tkeep),
      .m_axis_2_tuser (m_axis_2_tuser),
      .m_axis_2_tvalid(m_axis_2_tvalid),
      .m_axis_2_tready(m_axis_2_tready),
      .m_axis_2_tlast (m_axis_2_tlast),

      .m_axis_3_tdata (m_axis_3_tdata),
      .m_axis_3_tkeep (m_axis_3_tkeep),
      .m_axis_3_tuser (m_axis_3_tuser),
      .m_axis_3_tvalid(m_axis_3_tvalid),
      .m_axis_3_tready(m_axis_3_tready),
      .m_axis_3_tlast (m_axis_3_tlast),

      .m_axis_4_tdata (m_axis_4_tdata),
      .m_axis_4_tkeep (m_axis_4_tkeep),
      .m_axis_4_tuser (m_axis_4_tuser),
      .m_axis_4_tvalid(m_axis_4_tvalid),
      .m_axis_4_tready(m_axis_4_tready),
      .m_axis_4_tlast (m_axis_4_tlast),

      //.nf0_q_size(nf0_q_size),
      //.nf1_q_size(nf1_q_size),
      //.nf2_q_size(nf2_q_size),
      //.nf3_q_size(nf3_q_size),
      //.dma_q_size(dma_q_size),

      .bytes_stored(),
      .pkt_stored(),
      .bytes_removed_0(),
      .bytes_removed_1(),
      .bytes_removed_2(),
      .bytes_removed_3(),
      .bytes_removed_4(),
      .pkt_removed_0(),
      .pkt_removed_1(),
      .pkt_removed_2(),
      .pkt_removed_3(),
      .pkt_removed_4(),

      .S_AXI_AWADDR(S2_AXI_AWADDR),
      .S_AXI_AWVALID(S2_AXI_AWVALID),
      .S_AXI_WDATA(S2_AXI_WDATA),
      .S_AXI_WSTRB(S2_AXI_WSTRB),
      .S_AXI_WVALID(S2_AXI_WVALID),
      .S_AXI_BREADY(S2_AXI_BREADY),
      .S_AXI_ARADDR(S2_AXI_ARADDR),
      .S_AXI_ARVALID(S2_AXI_ARVALID),
      .S_AXI_RREADY(S2_AXI_RREADY),
      .S_AXI_ARREADY(S2_AXI_ARREADY),
      .S_AXI_RDATA(S2_AXI_RDATA),
      .S_AXI_RRESP(S2_AXI_RRESP),
      .S_AXI_RVALID(S2_AXI_RVALID),
      .S_AXI_WREADY(S2_AXI_WREADY),
      .S_AXI_BRESP(S2_AXI_BRESP),
      .S_AXI_BVALID(S2_AXI_BVALID),
      .S_AXI_AWREADY(S2_AXI_AWREADY),
      .S_AXI_ACLK (axi_aclk),
      .S_AXI_ARESETN(axi_resetn),

      .bytes_dropped(bytes_dropped),
      .pkt_dropped(pkt_dropped)

    );

endmodule
