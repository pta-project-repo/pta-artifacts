//
// Copyright (c) 2018 -, -
// All rights reserved.
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
/*******************************************************************************
 *  File:
 *        nf_sume_pktgen.v
 *
 *  Library:
 *        hw/contrib/cores/nf_sume_pktgen
 *
 *  Module:
 *        nf_sume_pktgen
 *
 *  Author:
 *        -
 *
 *  Description:
 *       Customizable internal packet generator,
 *       running at full speed (~50Gbps).
 *
 */

`include "nf_sume_pktgen_cpu_regs_defines.v"

//parameters to be added to the top module parameters
module nf_sume_pktgen
#(

    parameter C_BASEADDR = 32'h00000000,

    // Master AXI Stream Data Width
    parameter C_M_AXIS_DATA_WIDTH = 256,
    parameter C_M_AXIS_TUSER_WIDTH = 256,

    // AXI Registers Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 32
)
//ports to be added to the top module ports
(

  // Global Ports
  input axis_aclk,
  input axis_resetn,

  // Master Stream Ports (interface to TX queues)
  (* keep = "true" *) output reg [C_M_AXIS_DATA_WIDTH - 1:0] m_axis_0_tdata,
  (* keep = "true" *) output reg [((C_M_AXIS_DATA_WIDTH / 8)) - 1:0] m_axis_0_tkeep,
  (* keep = "true" *) output reg [C_M_AXIS_TUSER_WIDTH-1:0] m_axis_0_tuser,
  (* keep = "true" *) output reg m_axis_0_tvalid,
  (* keep = "true" *) input m_axis_0_tready,
  (* keep = "true" *) output reg m_axis_0_tlast,

// Signals for AXI_IP and IF_REG (Added for debug purposes)
    // Slave AXI Ports
    input                                     S_AXI_ACLK,
    input                                     S_AXI_ARESETN,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_AWADDR,
    input                                     S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input                                     S_AXI_WVALID,
    input                                     S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input                                     S_AXI_ARVALID,
    input                                     S_AXI_RREADY,
    output                                    S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
    output     [1 : 0]                        S_AXI_RRESP,
    output                                    S_AXI_RVALID,
    output                                    S_AXI_WREADY,
    output     [1 :0]                         S_AXI_BRESP,
    output                                    S_AXI_BVALID,
    output                                    S_AXI_AWREADY
);

    // define registers
    reg      [`REG_ID_BITS]    id_reg;
    reg      [`REG_VERSION_BITS]    version_reg;
    wire     [`REG_RESET_BITS]    reset_reg;
    reg      [`REG_FLIP_BITS]    ip2cpu_flip_reg;
    wire     [`REG_FLIP_BITS]    cpu2ip_flip_reg;
    reg      [`REG_DEBUG_BITS]    ip2cpu_debug_reg;
    wire     [`REG_DEBUG_BITS]    cpu2ip_debug_reg;
    reg      [`REG_PKTIN_BITS]    pktin_reg;
    wire                             pktin_reg_clear;
    reg      [`REG_PKTOUT_BITS]    pktout_reg;
    wire                             pktout_reg_clear;
    wire     [`REG_TRIGGER_BITS]    trigger_reg;
    reg      [`REG_SIZE_BITS]    ip2cpu_size_reg;
    wire     [`REG_SIZE_BITS]    cpu2ip_size_reg;
    reg      [`REG_NUMPKTS_BITS]    ip2cpu_numpkts_reg;
    wire     [`REG_NUMPKTS_BITS]    cpu2ip_numpkts_reg;
    reg      [`REG_GAP_BITS]    ip2cpu_gap_reg;
    wire     [`REG_GAP_BITS]    cpu2ip_gap_reg;
    reg      [`REG_KEEP_BITS]    ip2cpu_keep_reg;
    wire     [`REG_KEEP_BITS]    cpu2ip_keep_reg;

    reg      [`REG_META0_BITS]    ip2cpu_meta0_reg;
    wire     [`REG_META0_BITS]    cpu2ip_meta0_reg;

    reg      [`REG_META1_BITS]    ip2cpu_meta1_reg;
    wire     [`REG_META1_BITS]    cpu2ip_meta1_reg;

    reg      [`REG_META2_BITS]    ip2cpu_meta2_reg;
    wire     [`REG_META2_BITS]    cpu2ip_meta2_reg;

    reg      [`REG_META3_BITS]    ip2cpu_meta3_reg;
    wire     [`REG_META3_BITS]    cpu2ip_meta3_reg;

    reg      [`REG_META4_BITS]    ip2cpu_meta4_reg;
    wire     [`REG_META4_BITS]    cpu2ip_meta4_reg;

    reg      [`REG_META5_BITS]    ip2cpu_meta5_reg;
    wire     [`REG_META5_BITS]    cpu2ip_meta5_reg;

    reg      [`REG_META6_BITS]    ip2cpu_meta6_reg;
    wire     [`REG_META6_BITS]    cpu2ip_meta6_reg;

    reg      [`REG_META7_BITS]    ip2cpu_meta7_reg;
    wire     [`REG_META7_BITS]    cpu2ip_meta7_reg;

    reg      [`REG_META8_BITS]    ip2cpu_meta8_reg;
    wire     [`REG_META8_BITS]    cpu2ip_meta8_reg;

    reg      [`REG_META9_BITS]    ip2cpu_meta9_reg;
    wire     [`REG_META9_BITS]    cpu2ip_meta9_reg;

    reg      [`REG_META10_BITS]    ip2cpu_meta10_reg;
    wire     [`REG_META10_BITS]    cpu2ip_meta10_reg;

    reg      [`REG_META11_BITS]    ip2cpu_meta11_reg;
    wire     [`REG_META11_BITS]    cpu2ip_meta11_reg;

    reg      [`REG_META12_BITS]    ip2cpu_meta12_reg;
    wire     [`REG_META12_BITS]    cpu2ip_meta12_reg;

    reg      [`REG_META13_BITS]    ip2cpu_meta13_reg;
    wire     [`REG_META13_BITS]    cpu2ip_meta13_reg;

    reg      [`REG_META14_BITS]    ip2cpu_meta14_reg;
    wire     [`REG_META14_BITS]    cpu2ip_meta14_reg;

    reg      [`REG_META15_BITS]    ip2cpu_meta15_reg;
    wire     [`REG_META15_BITS]    cpu2ip_meta15_reg;

    //----------------------------
    //  nf_sume_pktgen INTERNAL REGISTERS:
    //----------------------------
    reg      [`REG_PKTOUT_BITS]    gen_counter; // assigned to pktout_reg
    reg      [15:0]                nf_sume_pktgen_cycles; // # of cycles
    reg      [15:0]                nf_sume_pktgen_pktsize; // packet size
    reg      [`REG_KEEP_BITS]      nf_sume_pktgen_keep; // tkeep bits
    reg      [`REG_NUMPKTS_BITS]   nf_sume_pktgen_burst; // # of packets
    reg      [`REG_GAP_BITS]       nf_sume_pktgen_gap; // gap size
    reg      [3:0]                 nf_sume_pktgen_state; // FSM states

//Registers section
 nf_sume_pktgen_cpu_regs
 #(
     .C_BASE_ADDRESS        (C_BASEADDR),
     .C_S_AXI_DATA_WIDTH    (C_S_AXI_DATA_WIDTH),
     .C_S_AXI_ADDR_WIDTH    (C_S_AXI_ADDR_WIDTH)
 ) nf_sume_pktgen_cpu_regs_inst
 (
   // General ports
    .clk                    (axis_aclk),
    .resetn                 (axis_resetn),
   // AXI Lite ports
    .S_AXI_ACLK             (S_AXI_ACLK),
    .S_AXI_ARESETN          (S_AXI_ARESETN),
    .S_AXI_AWADDR           (S_AXI_AWADDR),
    .S_AXI_AWVALID          (S_AXI_AWVALID),
    .S_AXI_WDATA            (S_AXI_WDATA),
    .S_AXI_WSTRB            (S_AXI_WSTRB),
    .S_AXI_WVALID           (S_AXI_WVALID),
    .S_AXI_BREADY           (S_AXI_BREADY),
    .S_AXI_ARADDR           (S_AXI_ARADDR),
    .S_AXI_ARVALID          (S_AXI_ARVALID),
    .S_AXI_RREADY           (S_AXI_RREADY),
    .S_AXI_ARREADY          (S_AXI_ARREADY),
    .S_AXI_RDATA            (S_AXI_RDATA),
    .S_AXI_RRESP            (S_AXI_RRESP),
    .S_AXI_RVALID           (S_AXI_RVALID),
    .S_AXI_WREADY           (S_AXI_WREADY),
    .S_AXI_BRESP            (S_AXI_BRESP),
    .S_AXI_BVALID           (S_AXI_BVALID),
    .S_AXI_AWREADY          (S_AXI_AWREADY),

   // Register ports
   .id_reg          (id_reg),
   .version_reg          (version_reg),
   .reset_reg          (reset_reg),
   .ip2cpu_flip_reg          (ip2cpu_flip_reg),
   .cpu2ip_flip_reg          (cpu2ip_flip_reg),
   .ip2cpu_debug_reg          (ip2cpu_debug_reg),
   .cpu2ip_debug_reg          (cpu2ip_debug_reg),
   .pktin_reg          (pktin_reg),
   .pktin_reg_clear    (pktin_reg_clear),
   .pktout_reg          (pktout_reg),
   .pktout_reg_clear    (pktout_reg_clear),
   .trigger_reg          (trigger_reg),
   .ip2cpu_size_reg          (ip2cpu_size_reg),
   .cpu2ip_size_reg          (cpu2ip_size_reg),
   .ip2cpu_numpkts_reg          (ip2cpu_numpkts_reg),
   .cpu2ip_numpkts_reg          (cpu2ip_numpkts_reg),
   .ip2cpu_gap_reg          (ip2cpu_gap_reg),
   .cpu2ip_gap_reg          (cpu2ip_gap_reg),
   .ip2cpu_keep_reg          (ip2cpu_keep_reg),
   .cpu2ip_keep_reg          (cpu2ip_keep_reg),

   .ip2cpu_meta0_reg          (ip2cpu_meta0_reg),
   .cpu2ip_meta0_reg          (cpu2ip_meta0_reg),

   .ip2cpu_meta1_reg          (ip2cpu_meta1_reg),
   .cpu2ip_meta1_reg          (cpu2ip_meta1_reg),

   .ip2cpu_meta2_reg          (ip2cpu_meta2_reg),
   .cpu2ip_meta2_reg          (cpu2ip_meta2_reg),

   .ip2cpu_meta3_reg          (ip2cpu_meta3_reg),
   .cpu2ip_meta3_reg          (cpu2ip_meta3_reg),

   .ip2cpu_meta4_reg          (ip2cpu_meta4_reg),
   .cpu2ip_meta4_reg          (cpu2ip_meta4_reg),

   .ip2cpu_meta5_reg          (ip2cpu_meta5_reg),
   .cpu2ip_meta5_reg          (cpu2ip_meta5_reg),

   .ip2cpu_meta6_reg          (ip2cpu_meta6_reg),
   .cpu2ip_meta6_reg          (cpu2ip_meta6_reg),

   .ip2cpu_meta7_reg          (ip2cpu_meta7_reg),
   .cpu2ip_meta7_reg          (cpu2ip_meta7_reg),

   .ip2cpu_meta8_reg          (ip2cpu_meta8_reg),
   .cpu2ip_meta8_reg          (cpu2ip_meta8_reg),

   .ip2cpu_meta9_reg          (ip2cpu_meta9_reg),
   .cpu2ip_meta9_reg          (cpu2ip_meta9_reg),

   .ip2cpu_meta10_reg          (ip2cpu_meta10_reg),
   .cpu2ip_meta10_reg          (cpu2ip_meta10_reg),

   .ip2cpu_meta11_reg          (ip2cpu_meta11_reg),
   .cpu2ip_meta11_reg          (cpu2ip_meta11_reg),

   .ip2cpu_meta12_reg          (ip2cpu_meta12_reg),
   .cpu2ip_meta12_reg          (cpu2ip_meta12_reg),

   .ip2cpu_meta13_reg          (ip2cpu_meta13_reg),
   .cpu2ip_meta13_reg          (cpu2ip_meta13_reg),

   .ip2cpu_meta14_reg          (ip2cpu_meta14_reg),
   .cpu2ip_meta14_reg          (cpu2ip_meta14_reg),

   .ip2cpu_meta15_reg          (ip2cpu_meta15_reg),
   .cpu2ip_meta15_reg          (cpu2ip_meta15_reg),


   // Global Registers - user can select if to use
   .cpu_resetn_soft(),//software reset, after cpu module
   .resetn_soft    (),//software reset to cpu module (from central reset management)
   .resetn_sync    (resetn_sync)//synchronized reset, use for better timing
);

 ////////////////////////////////////////////////////////////////////////////////
 //                          PACKET GENERATOR LOGIC (FSM)
 ////////////////////////////////////////////////////////////////////////////////

 always @(posedge axis_aclk) begin

     // check reset signal
     if ((~axis_resetn) || (reset_reg !=0)) begin

          gen_counter <= 0;

          m_axis_0_tuser <= 0;
          m_axis_0_tdata <= 0;
          m_axis_0_tkeep <= 0;
          m_axis_0_tvalid <= 0;
          m_axis_0_tlast <= 0;

          nf_sume_pktgen_cycles <= 0;
          nf_sume_pktgen_pktsize <= 0;
          nf_sume_pktgen_keep <= 0;
          nf_sume_pktgen_burst <= 0;
          nf_sume_pktgen_gap <= 0;

          nf_sume_pktgen_state <= 4'b0000;

     end
     else begin

             case(nf_sume_pktgen_state)

                  //----------------------------
                  //         S0 : IDLE
                  //----------------------------
                  4'b0000 : begin

                  // TRIGGER != 0 --> S1
                  if(trigger_reg != 0) begin

                    gen_counter <= gen_counter;

                    m_axis_0_tuser <= 0;
                    m_axis_0_tdata <= 0;
                    m_axis_0_tkeep <= 0;
                    m_axis_0_tvalid <= 0;
                    m_axis_0_tlast <= 0;

                    nf_sume_pktgen_cycles <= cpu2ip_size_reg[31:16];
                    nf_sume_pktgen_pktsize <= cpu2ip_size_reg[15:0];
                    nf_sume_pktgen_keep <= cpu2ip_keep_reg;
                    nf_sume_pktgen_burst <= cpu2ip_numpkts_reg;
                    nf_sume_pktgen_gap <= cpu2ip_gap_reg;

                    nf_sume_pktgen_state <= 4'b0001;

                  end

                  // TRIGGER == 0 --> S0
                  else begin

                    gen_counter <= gen_counter;

                    m_axis_0_tuser <= 0;
                    m_axis_0_tdata <= 0;
                    m_axis_0_tkeep <= 0;
                    m_axis_0_tvalid <= 0;
                    m_axis_0_tlast <= 0;

                    nf_sume_pktgen_cycles <= 0;
                    nf_sume_pktgen_pktsize <= 0;
                    nf_sume_pktgen_keep <= 0;
                    nf_sume_pktgen_burst <= 0;
                    nf_sume_pktgen_gap <= 0;

                    nf_sume_pktgen_state <= 4'b0000;

                  end

                 end // S0

                  //----------------------------
                  //        S1 : PKT
                  //----------------------------
                  4'b0001 : begin

                    // (CYCLES <= 1 && BURST > 1 && GAP < 1) --> S1
                    if ((nf_sume_pktgen_cycles <= 1) && (nf_sume_pktgen_burst > 1) && (nf_sume_pktgen_gap < 1)) begin

                     gen_counter <= gen_counter + 1;

                     m_axis_0_tuser <= 0;
                     m_axis_0_tdata <= 0;
                     m_axis_0_tkeep <= nf_sume_pktgen_keep;
                     m_axis_0_tvalid <= 1;
                     m_axis_0_tlast <= 1;

                     nf_sume_pktgen_cycles <= cpu2ip_size_reg[31:16];
                     nf_sume_pktgen_pktsize <= nf_sume_pktgen_pktsize;
                     nf_sume_pktgen_keep <= nf_sume_pktgen_keep;
                     nf_sume_pktgen_burst <= nf_sume_pktgen_burst - 1;
                     nf_sume_pktgen_gap <= nf_sume_pktgen_gap;

                     nf_sume_pktgen_state <= 4'b0001;

                    end // if


                    // (CYCLES <= 1 && BURST > 1 && GAP >= 1) --> S2
                    else if ((nf_sume_pktgen_cycles <= 1) && (nf_sume_pktgen_burst > 1) && (nf_sume_pktgen_gap >= 1)) begin

                      gen_counter <= gen_counter + 1;

                      m_axis_0_tuser <= 0;
                      m_axis_0_tdata <= 0;
                      m_axis_0_tkeep <= nf_sume_pktgen_keep;
                      m_axis_0_tvalid <= 1;
                      m_axis_0_tlast <= 1;

                      nf_sume_pktgen_cycles <= cpu2ip_size_reg[31:16];
                      nf_sume_pktgen_pktsize <= nf_sume_pktgen_pktsize;
                      nf_sume_pktgen_keep <= nf_sume_pktgen_keep;
                      nf_sume_pktgen_burst <= nf_sume_pktgen_burst - 1;
                      nf_sume_pktgen_gap <= nf_sume_pktgen_gap;

                      nf_sume_pktgen_state <= 4'b0010;

                    end // else if

                    // (CYCLES <= 1 && BURST <= 1) --> S0
                    else if ((nf_sume_pktgen_cycles <= 1) && (nf_sume_pktgen_burst <= 1)) begin

                      gen_counter <= gen_counter + 1;

                      m_axis_0_tuser <= 0;
                      m_axis_0_tdata <= 0;
                      m_axis_0_tkeep <= nf_sume_pktgen_keep;
                      m_axis_0_tvalid <= 1;
                      m_axis_0_tlast <= 1;

                      nf_sume_pktgen_cycles <= 0;
                      nf_sume_pktgen_pktsize <= 0;
                      nf_sume_pktgen_keep <= 0;
                      nf_sume_pktgen_burst <= 0;
                      nf_sume_pktgen_gap <= 0;

                      nf_sume_pktgen_state <= 4'b0000;

                    end // else if

                    // CYCLES > 1 --> S1
                    else begin

                      gen_counter <= gen_counter;

                      //***************************************************************************************************
                      // PACKET METADATA {112'b0, pkt_len[15:0], meta0 [7:0], ..., meta0 [15:0]}
                      //***************************************************************************************************

                      m_axis_0_tuser <= {112'b0, nf_sume_pktgen_pktsize, cpu2ip_meta0_reg[7:0], cpu2ip_meta1_reg[7:0], cpu2ip_meta2_reg[7:0], cpu2ip_meta3_reg[7:0], cpu2ip_meta4_reg[7:0], cpu2ip_meta5_reg[7:0], cpu2ip_meta6_reg[7:0], cpu2ip_meta7_reg[7:0], cpu2ip_meta8_reg[7:0], cpu2ip_meta9_reg[7:0], cpu2ip_meta10_reg[7:0], cpu2ip_meta11_reg[7:0], cpu2ip_meta12_reg[7:0], cpu2ip_meta13_reg[7:0], cpu2ip_meta14_reg[7:0], cpu2ip_meta15_reg[7:0]};

                      //***************************************************************************************************
                      // >>>> PACKET DATA {END, [X:0], START}
                      //***************************************************************************************************

                      m_axis_0_tdata <= 0;

                      //***************************************************************************************************

                      m_axis_0_tkeep <= {32{1'b1}};
                      m_axis_0_tvalid <= 1;
                      m_axis_0_tlast <= 0;

                      nf_sume_pktgen_cycles <= nf_sume_pktgen_cycles - 1;
                      nf_sume_pktgen_pktsize <= nf_sume_pktgen_pktsize;
                      nf_sume_pktgen_keep <= nf_sume_pktgen_keep;
                      nf_sume_pktgen_burst <= nf_sume_pktgen_burst;
                      nf_sume_pktgen_gap <= nf_sume_pktgen_gap;

                      nf_sume_pktgen_state <= 4'b0001;

                    end // else

                 end // S1

                 //----------------------------
                 //         S2 : GAP
                 //----------------------------
                 4'b0010 : begin

                    // GAP <= 1 --> S1
                    if (nf_sume_pktgen_gap <= 1) begin

                     gen_counter <= gen_counter;

                     m_axis_0_tuser <= 0;
                     m_axis_0_tdata <= 0;
                     m_axis_0_tkeep <= 0;
                     m_axis_0_tvalid <= 0;
                     m_axis_0_tlast <= 0;

                     nf_sume_pktgen_cycles <= nf_sume_pktgen_cycles;
                     nf_sume_pktgen_pktsize <= nf_sume_pktgen_pktsize;
                     nf_sume_pktgen_keep <= nf_sume_pktgen_keep;
                     nf_sume_pktgen_burst <= nf_sume_pktgen_burst;
                     nf_sume_pktgen_gap <= cpu2ip_gap_reg;

                     nf_sume_pktgen_state <= 4'b0001;

                    end

                    // GAP > 1 --> S2
                    else begin

                     gen_counter <= gen_counter;

                     m_axis_0_tuser <= 0;
                     m_axis_0_tdata <= 0;
                     m_axis_0_tkeep <= 0;
                     m_axis_0_tvalid <= 0;
                     m_axis_0_tlast <= 0;

                     nf_sume_pktgen_cycles <= nf_sume_pktgen_cycles;
                     nf_sume_pktgen_pktsize <= nf_sume_pktgen_pktsize;
                     nf_sume_pktgen_keep <= nf_sume_pktgen_keep;
                     nf_sume_pktgen_burst <= nf_sume_pktgen_burst;
                     nf_sume_pktgen_gap <= nf_sume_pktgen_gap - 1;

                     nf_sume_pktgen_state <= 4'b0010;

                    end

                  end // S2

                 //----------------------------
                 //   DEFAULT (RESET STATE)
                 //----------------------------
                 default : begin

                   gen_counter <= 0;

                   m_axis_0_tuser <= 0;
                   m_axis_0_tdata <= 0;
                   m_axis_0_tkeep <= 0;
                   m_axis_0_tvalid <= 0;
                   m_axis_0_tlast <= 0;

                   nf_sume_pktgen_cycles <= 0;
                   nf_sume_pktgen_pktsize <= 0;
                   nf_sume_pktgen_keep <= 0;
                   nf_sume_pktgen_burst <= 0;
                   nf_sume_pktgen_gap <= 0;

                   nf_sume_pktgen_state <= 4'b0000;

                 end // default

             endcase

     end

 end

 ////////////////////////////////////////////////////////////////////////////////
 //               REGISTERS LOGIC
 ////////////////////////////////////////////////////////////////////////////////

//registers logic, current logic is just a placeholder for initial compil, required to be changed by the user
always @(posedge axis_aclk)

  if (~resetn_sync) begin
    id_reg <= #1    `REG_ID_DEFAULT;
    version_reg <= #1    `REG_VERSION_DEFAULT;
    ip2cpu_flip_reg <= #1    `REG_FLIP_DEFAULT;
    ip2cpu_debug_reg <= #1    `REG_DEBUG_DEFAULT;
    pktin_reg <= #1    `REG_PKTIN_DEFAULT;
    pktout_reg <= #1    `REG_PKTOUT_DEFAULT;
    ip2cpu_size_reg <= #1    `REG_SIZE_DEFAULT;
    ip2cpu_numpkts_reg <= #1    `REG_NUMPKTS_DEFAULT;
    ip2cpu_gap_reg <= #1    `REG_GAP_DEFAULT;
    ip2cpu_keep_reg <= #1    `REG_KEEP_DEFAULT;

    ip2cpu_meta0_reg <= #1    `REG_META0_DEFAULT;
    ip2cpu_meta1_reg <= #1    `REG_META1_DEFAULT;
    ip2cpu_meta2_reg <= #1    `REG_META2_DEFAULT;
    ip2cpu_meta3_reg <= #1    `REG_META3_DEFAULT;
    ip2cpu_meta4_reg <= #1    `REG_META4_DEFAULT;
    ip2cpu_meta5_reg <= #1    `REG_META5_DEFAULT;
    ip2cpu_meta6_reg <= #1    `REG_META6_DEFAULT;
    ip2cpu_meta7_reg <= #1    `REG_META7_DEFAULT;
    ip2cpu_meta8_reg <= #1    `REG_META8_DEFAULT;
    ip2cpu_meta9_reg <= #1    `REG_META9_DEFAULT;
    ip2cpu_meta10_reg <= #1    `REG_META10_DEFAULT;
    ip2cpu_meta11_reg <= #1    `REG_META11_DEFAULT;
    ip2cpu_meta12_reg <= #1    `REG_META12_DEFAULT;
    ip2cpu_meta13_reg <= #1    `REG_META13_DEFAULT;
    ip2cpu_meta14_reg <= #1    `REG_META14_DEFAULT;
    ip2cpu_meta15_reg <= #1    `REG_META15_DEFAULT;
  end

  else if (reset_reg !=0) begin
    id_reg <= #1    `REG_ID_DEFAULT;
    version_reg <= #1    `REG_VERSION_DEFAULT;
    ip2cpu_flip_reg <= #1    `REG_FLIP_DEFAULT;
    ip2cpu_debug_reg <= #1    `REG_DEBUG_DEFAULT;
    // pktin_reg <= #1    `REG_PKTIN_DEFAULT;
    pktout_reg <= #1    `REG_PKTOUT_DEFAULT;
    ip2cpu_size_reg <= #1    `REG_SIZE_DEFAULT;
    ip2cpu_numpkts_reg <= #1    `REG_NUMPKTS_DEFAULT;
    ip2cpu_gap_reg <= #1    `REG_GAP_DEFAULT;
    ip2cpu_keep_reg <= #1    `REG_KEEP_DEFAULT;

    ip2cpu_meta0_reg <= #1    `REG_META0_DEFAULT;
    ip2cpu_meta1_reg <= #1    `REG_META1_DEFAULT;
    ip2cpu_meta2_reg <= #1    `REG_META2_DEFAULT;
    ip2cpu_meta3_reg <= #1    `REG_META3_DEFAULT;
    ip2cpu_meta4_reg <= #1    `REG_META4_DEFAULT;
    ip2cpu_meta5_reg <= #1    `REG_META5_DEFAULT;
    ip2cpu_meta6_reg <= #1    `REG_META6_DEFAULT;
    ip2cpu_meta7_reg <= #1    `REG_META7_DEFAULT;
    ip2cpu_meta8_reg <= #1    `REG_META8_DEFAULT;
    ip2cpu_meta9_reg <= #1    `REG_META9_DEFAULT;
    ip2cpu_meta10_reg <= #1    `REG_META10_DEFAULT;
    ip2cpu_meta11_reg <= #1    `REG_META11_DEFAULT;
    ip2cpu_meta12_reg <= #1    `REG_META12_DEFAULT;
    ip2cpu_meta13_reg <= #1    `REG_META13_DEFAULT;
    ip2cpu_meta14_reg <= #1    `REG_META14_DEFAULT;
    ip2cpu_meta15_reg <= #1    `REG_META15_DEFAULT;
  end

  else begin
    id_reg <= #1    `REG_ID_DEFAULT;
    version_reg <= #1    `REG_VERSION_DEFAULT;
    ip2cpu_flip_reg <= #1 cpu2ip_flip_reg;
    ip2cpu_debug_reg <= #1 cpu2ip_debug_reg;
    // pktin_reg <= #1 pktin_reg_clear ? 'h0  : `REG_PKTIN_DEFAULT;
    // pktout_reg <= #1 pktout_reg_clear ? 'h0  : `REG_PKTOUT_DEFAULT;
    ip2cpu_size_reg <= #1 cpu2ip_size_reg;
    ip2cpu_numpkts_reg <= #1 cpu2ip_numpkts_reg;
    ip2cpu_gap_reg <= #1 cpu2ip_gap_reg;
    ip2cpu_keep_reg <= #1 cpu2ip_keep_reg;

    ip2cpu_meta0_reg <= #1 cpu2ip_meta0_reg;
    ip2cpu_meta1_reg <= #1 cpu2ip_meta1_reg;
    ip2cpu_meta2_reg <= #1 cpu2ip_meta2_reg;
    ip2cpu_meta3_reg <= #1 cpu2ip_meta3_reg;
    ip2cpu_meta4_reg <= #1 cpu2ip_meta4_reg;
    ip2cpu_meta5_reg <= #1 cpu2ip_meta5_reg;
    ip2cpu_meta6_reg <= #1 cpu2ip_meta6_reg;
    ip2cpu_meta7_reg <= #1 cpu2ip_meta7_reg;
    ip2cpu_meta8_reg <= #1 cpu2ip_meta8_reg;
    ip2cpu_meta9_reg <= #1 cpu2ip_meta9_reg;
    ip2cpu_meta10_reg <= #1 cpu2ip_meta10_reg;
    ip2cpu_meta11_reg <= #1 cpu2ip_meta11_reg;
    ip2cpu_meta12_reg <= #1 cpu2ip_meta12_reg;
    ip2cpu_meta13_reg <= #1 cpu2ip_meta13_reg;
    ip2cpu_meta14_reg <= #1 cpu2ip_meta14_reg;
    ip2cpu_meta15_reg <= #1 cpu2ip_meta15_reg;

    pktout_reg <= #1 pktout_reg_clear ? 'h0  : gen_counter;
    pktin_reg <= #1 0;
  end

endmodule
