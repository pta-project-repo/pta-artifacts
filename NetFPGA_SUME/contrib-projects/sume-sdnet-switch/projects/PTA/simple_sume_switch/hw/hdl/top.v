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
//        top.v
//
//  Module:
//        top
//
//  Author: Noa Zilberman
//
//  Description:
//        reference switch top module
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

`timescale 1ps / 1ps

 module top # (  
  parameter          C_DATA_WIDTH                        = 256,         // RX/TX interface data width
  parameter          C_TUSER_WIDTH                       = 128         // RX/TX interface data width    
) (

//PCI Express
  input  [7:0]pcie_7x_mgt_rxn,
  input  [7:0]pcie_7x_mgt_rxp,
  output [7:0]pcie_7x_mgt_txn,
  output [7:0]pcie_7x_mgt_txp,
//10G Interface

  input  sfp0_rx_p,
  input  sfp0_rx_n,
  output sfp0_tx_p,
  output sfp0_tx_n,
  input  sfp0_tx_fault,  
  input  sfp0_tx_abs,   
  output sfp0_tx_disable,
  
  input sfp1_rx_p,
  input sfp1_rx_n,
  output sfp1_tx_p,
  output sfp1_tx_n,
  input  sfp1_tx_fault,  
  input  sfp1_tx_abs,   
  output sfp1_tx_disable,  
  
     
  input sfp2_rx_p,
  input sfp2_rx_n,
  output sfp2_tx_p,
  output sfp2_tx_n,
  input  sfp2_tx_fault,  
  input  sfp2_tx_abs,   
  output sfp2_tx_disable,
  
      
  input sfp3_rx_p,
  input sfp3_rx_n,
  output sfp3_tx_p,
  output sfp3_tx_n,
  input  sfp3_tx_fault,  
  input  sfp3_tx_abs,   
  output sfp3_tx_disable,  
  
  // 100MHz PCIe Clock
  input       sys_clkp,
  input       sys_clkn,
  
  //  200MHz FPGA Clock
  input       fpga_sysclk_p,
  input       fpga_sysclk_n,
  
  
  
  // 156.25MHz Si5324 clock 
  input                          xphy_refclk_p,
  input                          xphy_refclk_n,
 
 
 //debug features 
  output [1:0]         leds,   
  
  output sfp0_tx_led,
  output sfp1_tx_led,
  output sfp2_tx_led,
  output sfp3_tx_led,
           
  output sfp0_rx_led,
  output sfp1_rx_led,
  output sfp2_rx_led,
  output sfp3_rx_led,

  //-SI5324 I2C programming interface 
  inout i2c_clk,
  inout i2c_data,
  output [1:0] i2c_reset,

  //UART interface
  input  uart_rxd,
  output uart_txd,    

  input  sys_reset_n 
);

 
  //----------------------------------------------------------------------------------------------------------------//
  //    System(SYS) Interface                                                                                       //
  //----------------------------------------------------------------------------------------------------------------//

  wire                                       sys_clk;
  wire                                       clk_200;
  wire                                       sys_rst_n_c;
  wire                                       clk_200_locked;

    //-----------------------------------------------------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------------------------------------------//
  // axis interface                                                                                                 //
  //----------------------------------------------------------------------------------------------------------------//

  wire[C_DATA_WIDTH-1:0]      axis_i_0_tdata;
  wire            axis_i_0_tvalid;
  wire            axis_i_0_tlast;
  wire[C_TUSER_WIDTH-1:0]     axis_i_0_tuser;
 wire[(C_DATA_WIDTH/8)-1:0]       axis_i_0_tkeep;
 wire            axis_i_0_tready;

(* mark_debug = "true" *) wire[C_DATA_WIDTH-1:0]      axis_o_0_tdata;
(* mark_debug = "true" *) wire            axis_o_0_tvalid;
(* mark_debug = "true" *) wire            axis_o_0_tlast;
(* mark_debug = "true" *) wire [C_TUSER_WIDTH-1:0]         axis_o_0_tuser;
(* mark_debug = "true" *) wire[(C_DATA_WIDTH/8)-1:0]       axis_o_0_tkeep;
(* mark_debug = "true" *) wire            axis_o_0_tready;

  wire[C_DATA_WIDTH-1:0]      axis_i_1_tdata;
  wire            axis_i_1_tvalid;
  wire            axis_i_1_tlast;
  wire[C_TUSER_WIDTH-1:0]            axis_i_1_tuser;
  wire[C_DATA_WIDTH/8-1:0]       axis_i_1_tkeep;
  wire            axis_i_1_tready;

 (* mark_debug = "true" *)  wire[C_DATA_WIDTH-1:0]      axis_o_1_tdata;
 (* mark_debug = "true" *)  wire            axis_o_1_tvalid;
 (* mark_debug = "true" *)  wire            axis_o_1_tlast;
 (* mark_debug = "true" *)  wire [C_TUSER_WIDTH-1:0]           axis_o_1_tuser;
 (* mark_debug = "true" *)  wire[C_DATA_WIDTH/8-1:0]       axis_o_1_tkeep;
 (* mark_debug = "true" *)  wire            axis_o_1_tready;

  wire[C_DATA_WIDTH-1:0]      axis_i_2_tdata;
  wire            axis_i_2_tvalid;
  wire            axis_i_2_tlast;
  wire[C_TUSER_WIDTH-1:0]            axis_i_2_tuser;
  wire[C_DATA_WIDTH/8-1:0]       axis_i_2_tkeep;
  wire            axis_i_2_tready;

 (* mark_debug = "true" *)  wire[C_DATA_WIDTH-1:0]      axis_o_2_tdata;
 (* mark_debug = "true" *)  wire            axis_o_2_tvalid;
 (* mark_debug = "true" *)  wire            axis_o_2_tlast;
 (* mark_debug = "true" *)  wire [C_TUSER_WIDTH-1:0]         axis_o_2_tuser;
 (* mark_debug = "true" *)  wire[C_DATA_WIDTH/8-1:0]       axis_o_2_tkeep;
 (* mark_debug = "true" *)  wire            axis_o_2_tready;

  wire[C_DATA_WIDTH-1:0]      axis_i_3_tdata;
  wire            axis_i_3_tvalid;
  wire            axis_i_3_tlast;
  wire[C_TUSER_WIDTH-1:0]            axis_i_3_tuser;
  wire[C_DATA_WIDTH/8-1:0]       axis_i_3_tkeep;
  wire            axis_i_3_tready;

 (* mark_debug = "true" *)  wire[C_DATA_WIDTH-1:0]      axis_o_3_tdata;
 (* mark_debug = "true" *)  wire            axis_o_3_tvalid;
 (* mark_debug = "true" *)  wire            axis_o_3_tlast;
 (* mark_debug = "true" *)  wire [C_TUSER_WIDTH-1:0]         axis_o_3_tuser;
 (* mark_debug = "true" *)  wire[C_DATA_WIDTH/8-1:0]       axis_o_3_tkeep;
 (* mark_debug = "true" *)  wire            axis_o_3_tready;

  // AXIS DMA interfaces
  wire [255:0]   axis_dma_i_tdata ;
  wire [31:0]    axis_dma_i_tkeep ;
  wire           axis_dma_i_tlast ;
  wire           axis_dma_i_tready;
  wire [255:0]   axis_dma_i_tuser ;
  wire           axis_dma_i_tvalid;

  wire [255:0]  axis_dma_o_tdata;
  wire [31:0]   axis_dma_o_tkeep;
  wire          axis_dma_o_tlast;
  wire          axis_dma_o_tready;
  wire [127:0]  axis_dma_o_tuser;
  wire          axis_dma_o_tvalid;
  
 //----------------------------------------------------------------------------------------------------------------//
 // AXI Lite interface                                                                                                 //
 //----------------------------------------------------------------------------------------------------------------//
  wire [11:0]   M00_AXI_araddr;
  wire [2:0]    M00_AXI_arprot;
  wire [0:0]    M00_AXI_arready;
  wire [0:0]    M00_AXI_arvalid;
  wire [11:0]   M00_AXI_awaddr;
  wire [2:0]    M00_AXI_awprot;
  wire [0:0]    M00_AXI_awready;
  wire [0:0]    M00_AXI_awvalid;
  wire [0:0]    M00_AXI_bready;
  wire [1:0]    M00_AXI_bresp;
  wire [0:0]    M00_AXI_bvalid;
  wire [31:0]   M00_AXI_rdata;
  wire [0:0]    M00_AXI_rready;
  wire [1:0]    M00_AXI_rresp;
  wire [0:0]    M00_AXI_rvalid;
  wire [31:0]   M00_AXI_wdata;
  wire [0:0]    M00_AXI_wready;
  wire [3:0]    M00_AXI_wstrb;
  wire [0:0]    M00_AXI_wvalid;
  
  wire [11:0]   M01_AXI_araddr;
  wire [2:0]    M01_AXI_arprot;
  wire [0:0]    M01_AXI_arready;
  wire [0:0]    M01_AXI_arvalid;
  wire [11:0]   M01_AXI_awaddr;
  wire [2:0]    M01_AXI_awprot;
  wire [0:0]    M01_AXI_awready;
  wire [0:0]    M01_AXI_awvalid;
  wire [0:0]    M01_AXI_bready;
  wire [1:0]    M01_AXI_bresp;
  wire [0:0]    M01_AXI_bvalid;
  wire [31:0]   M01_AXI_rdata;
  wire [0:0]    M01_AXI_rready;
  wire [1:0]    M01_AXI_rresp;
  wire [0:0]    M01_AXI_rvalid;
  wire [31:0]   M01_AXI_wdata;
  wire [0:0]    M01_AXI_wready;
  wire [3:0]    M01_AXI_wstrb;
  wire [0:0]    M01_AXI_wvalid;

  wire [11:0]   M02_AXI_araddr;
  wire [2:0]    M02_AXI_arprot;
  wire [0:0]    M02_AXI_arready;
  wire [0:0]    M02_AXI_arvalid;
  wire [11:0]   M02_AXI_awaddr;
  wire [2:0]    M02_AXI_awprot;
  wire [0:0]    M02_AXI_awready;
  wire [0:0]    M02_AXI_awvalid;
  wire [0:0]    M02_AXI_bready;
  wire [1:0]    M02_AXI_bresp;
  wire [0:0]    M02_AXI_bvalid;
  wire [31:0]   M02_AXI_rdata;
  wire [0:0]    M02_AXI_rready;
  wire [1:0]    M02_AXI_rresp;
  wire [0:0]    M02_AXI_rvalid;
  wire [31:0]   M02_AXI_wdata;
  wire [0:0]    M02_AXI_wready;
  wire [3:0]    M02_AXI_wstrb;
  wire [0:0]    M02_AXI_wvalid;
  
  wire [11:0]   M03_AXI_araddr;
  wire [2:0]    M03_AXI_arprot;
  wire [0:0]    M03_AXI_arready;
  wire [0:0]    M03_AXI_arvalid;
  wire [11:0]   M03_AXI_awaddr;
  wire [2:0]    M03_AXI_awprot;
  wire [0:0]    M03_AXI_awready;
  wire [0:0]    M03_AXI_awvalid;
  wire [0:0]    M03_AXI_bready;
  wire [1:0]    M03_AXI_bresp;
  wire [0:0]    M03_AXI_bvalid;
  wire [31:0]   M03_AXI_rdata;
  wire [0:0]    M03_AXI_rready;
  wire [1:0]    M03_AXI_rresp;
  wire [0:0]    M03_AXI_rvalid;
  wire [31:0]   M03_AXI_wdata;
  wire [0:0]    M03_AXI_wready;
  wire [3:0]    M03_AXI_wstrb;
  wire [0:0]    M03_AXI_wvalid;
  
  wire [11:0]   M04_AXI_araddr;
  wire [2:0]    M04_AXI_arprot;
  wire [0:0]    M04_AXI_arready;
  wire [0:0]    M04_AXI_arvalid;
  wire [11:0]   M04_AXI_awaddr;
  wire [2:0]    M04_AXI_awprot;
  wire [0:0]    M04_AXI_awready;
  wire [0:0]    M04_AXI_awvalid;
  wire [0:0]    M04_AXI_bready;
  wire [1:0]    M04_AXI_bresp;
  wire [0:0]    M04_AXI_bvalid;
  wire [31:0]   M04_AXI_rdata;
  wire [0:0]    M04_AXI_rready;
  wire [1:0]    M04_AXI_rresp;
  wire [0:0]    M04_AXI_rvalid;
  wire [31:0]   M04_AXI_wdata;
  wire [0:0]    M04_AXI_wready;
  wire [3:0]    M04_AXI_wstrb;
  wire [0:0]    M04_AXI_wvalid;
  
  wire [11:0]   M05_AXI_araddr;
  wire [2:0]    M05_AXI_arprot;
  wire [0:0]    M05_AXI_arready;
  wire [0:0]    M05_AXI_arvalid;
  wire [11:0]   M05_AXI_awaddr;
  wire [2:0]    M05_AXI_awprot;
  wire [0:0]    M05_AXI_awready;
  wire [0:0]    M05_AXI_awvalid;
  wire [0:0]    M05_AXI_bready;
  wire [1:0]    M05_AXI_bresp;
  wire [0:0]    M05_AXI_bvalid;
  wire [31:0]   M05_AXI_rdata;
  wire [0:0]    M05_AXI_rready;
  wire [1:0]    M05_AXI_rresp;
  wire [0:0]    M05_AXI_rvalid;
  wire [31:0]   M05_AXI_wdata;
  wire [0:0]    M05_AXI_wready;
  wire [3:0]    M05_AXI_wstrb;
  wire [0:0]    M05_AXI_wvalid;
  
  wire [11:0]   M06_AXI_araddr;
  wire [2:0]    M06_AXI_arprot;
  wire [0:0]    M06_AXI_arready;
  wire [0:0]    M06_AXI_arvalid;
  wire [11:0]   M06_AXI_awaddr;
  wire [2:0]    M06_AXI_awprot;
  wire [0:0]    M06_AXI_awready;
  wire [0:0]    M06_AXI_awvalid;
  wire [0:0]    M06_AXI_bready;
  wire [1:0]    M06_AXI_bresp;
  wire [0:0]    M06_AXI_bvalid;
  wire [31:0]   M06_AXI_rdata;
  wire [0:0]    M06_AXI_rready;
  wire [1:0]    M06_AXI_rresp;
  wire [0:0]    M06_AXI_rvalid;
  wire [31:0]   M06_AXI_wdata;
  wire [0:0]    M06_AXI_wready;
  wire [3:0]    M06_AXI_wstrb;
  wire [0:0]    M06_AXI_wvalid;
  
  wire [11:0]   M07_AXI_araddr;
  wire [2:0]    M07_AXI_arprot;
  wire [0:0]    M07_AXI_arready;
  wire [0:0]    M07_AXI_arvalid;
  wire [11:0]   M07_AXI_awaddr;
  wire [2:0]    M07_AXI_awprot;
  wire [0:0]    M07_AXI_awready;
  wire [0:0]    M07_AXI_awvalid;
  wire [0:0]    M07_AXI_bready;
  wire [1:0]    M07_AXI_bresp;
  wire [0:0]    M07_AXI_bvalid;
  wire [31:0]   M07_AXI_rdata;
  wire [0:0]    M07_AXI_rready;
  wire [1:0]    M07_AXI_rresp;
  wire [0:0]    M07_AXI_rvalid;
  wire [31:0]   M07_AXI_wdata;
  wire [0:0]    M07_AXI_wready;
  wire [3:0]    M07_AXI_wstrb;
  wire [0:0]    M07_AXI_wvalid;

  wire [11:0]   M09_AXI_araddr;
  wire [2:0]    M09_AXI_arprot;
  wire [0:0]    M09_AXI_arready;
  wire [0:0]    M09_AXI_arvalid;
  wire [11:0]   M09_AXI_awaddr;
  wire [2:0]    M09_AXI_awprot;
  wire [0:0]    M09_AXI_awready;
  wire [0:0]    M09_AXI_awvalid;
  wire [0:0]    M09_AXI_bready;
  wire [1:0]    M09_AXI_bresp;
  wire [0:0]    M09_AXI_bvalid;
  wire [31:0]   M09_AXI_rdata;
  wire [0:0]    M09_AXI_rready;
  wire [1:0]    M09_AXI_rresp;
  wire [0:0]    M09_AXI_rvalid;
  wire [31:0]   M09_AXI_wdata;
  wire [0:0]    M09_AXI_wready;
  wire [3:0]    M09_AXI_wstrb;
  wire [0:0]    M09_AXI_wvalid;

  wire [11:0]   M10_AXI_araddr;
  wire [2:0]    M10_AXI_arprot;
  wire [0:0]    M10_AXI_arready;
  wire [0:0]    M10_AXI_arvalid;
  wire [11:0]   M10_AXI_awaddr;
  wire [2:0]    M10_AXI_awprot;
  wire [0:0]    M10_AXI_awready;
  wire [0:0]    M10_AXI_awvalid;
  wire [0:0]    M10_AXI_bready;
  wire [1:0]    M10_AXI_bresp;
  wire [0:0]    M10_AXI_bvalid;
  wire [31:0]   M10_AXI_rdata;
  wire [0:0]    M10_AXI_rready;
  wire [1:0]    M10_AXI_rresp;
  wire [0:0]    M10_AXI_rvalid;
  wire [31:0]   M10_AXI_wdata;
  wire [0:0]    M10_AXI_wready;
  wire [3:0]    M10_AXI_wstrb;
  wire [0:0]    M10_AXI_wvalid;

  wire [11:0]   M11_AXI_araddr;
  wire [2:0]    M11_AXI_arprot;
  wire [0:0]    M11_AXI_arready;
  wire [0:0]    M11_AXI_arvalid;
  wire [11:0]   M11_AXI_awaddr;
  wire [2:0]    M11_AXI_awprot;
  wire [0:0]    M11_AXI_awready;
  wire [0:0]    M11_AXI_awvalid;
  wire [0:0]    M11_AXI_bready;
  wire [1:0]    M11_AXI_bresp;
  wire [0:0]    M11_AXI_bvalid;
  wire [31:0]   M11_AXI_rdata;
  wire [0:0]    M11_AXI_rready;
  wire [1:0]    M11_AXI_rresp;
  wire [0:0]    M11_AXI_rvalid;
  wire [31:0]   M11_AXI_wdata;
  wire [0:0]    M11_AXI_wready;
  wire [3:0]    M11_AXI_wstrb;
  wire [0:0]    M11_AXI_wvalid;

  wire [11:0]   M12_AXI_araddr;
  wire [2:0]    M12_AXI_arprot;
  wire [0:0]    M12_AXI_arready;
  wire [0:0]    M12_AXI_arvalid;
  wire [11:0]   M12_AXI_awaddr;
  wire [2:0]    M12_AXI_awprot;
  wire [0:0]    M12_AXI_awready;
  wire [0:0]    M12_AXI_awvalid;
  wire [0:0]    M12_AXI_bready;
  wire [1:0]    M12_AXI_bresp;
  wire [0:0]    M12_AXI_bvalid;
  wire [31:0]   M12_AXI_rdata;
  wire [0:0]    M12_AXI_rready;
  wire [1:0]    M12_AXI_rresp;
  wire [0:0]    M12_AXI_rvalid;
  wire [31:0]   M12_AXI_wdata;
  wire [0:0]    M12_AXI_wready;
  wire [3:0]    M12_AXI_wstrb;
  wire [0:0]    M12_AXI_wvalid;

  wire [11:0]   M13_AXI_araddr;
  wire [2:0]    M13_AXI_arprot;
  wire [0:0]    M13_AXI_arready;
  wire [0:0]    M13_AXI_arvalid;
  wire [11:0]   M13_AXI_awaddr;
  wire [2:0]    M13_AXI_awprot;
  wire [0:0]    M13_AXI_awready;
  wire [0:0]    M13_AXI_awvalid;
  wire [0:0]    M13_AXI_bready;
  wire [1:0]    M13_AXI_bresp;
  wire [0:0]    M13_AXI_bvalid;
  wire [31:0]   M13_AXI_rdata;
  wire [0:0]    M13_AXI_rready;
  wire [1:0]    M13_AXI_rresp;
  wire [0:0]    M13_AXI_rvalid;
  wire [31:0]   M13_AXI_wdata;
  wire [0:0]    M13_AXI_wready;
  wire [3:0]    M13_AXI_wstrb;
  wire [0:0]    M13_AXI_wvalid;

  wire [11:0]   M14_AXI_araddr;
  wire [2:0]    M14_AXI_arprot;
  wire [0:0]    M14_AXI_arready;
  wire [0:0]    M14_AXI_arvalid;
  wire [11:0]   M14_AXI_awaddr;
  wire [2:0]    M14_AXI_awprot;
  wire [0:0]    M14_AXI_awready;
  wire [0:0]    M14_AXI_awvalid;
  wire [0:0]    M14_AXI_bready;
  wire [1:0]    M14_AXI_bresp;
  wire [0:0]    M14_AXI_bvalid;
  wire [31:0]   M14_AXI_rdata;
  wire [0:0]    M14_AXI_rready;
  wire [1:0]    M14_AXI_rresp;
  wire [0:0]    M14_AXI_rvalid;
  wire [31:0]   M14_AXI_wdata;
  wire [0:0]    M14_AXI_wready;
  wire [3:0]    M14_AXI_wstrb;
  wire [0:0]    M14_AXI_wvalid;

  wire [11:0]   M15_AXI_araddr;
  wire [2:0]    M15_AXI_arprot;
  wire [0:0]    M15_AXI_arready;
  wire [0:0]    M15_AXI_arvalid;
  wire [11:0]   M15_AXI_awaddr;
  wire [2:0]    M15_AXI_awprot;
  wire [0:0]    M15_AXI_awready;
  wire [0:0]    M15_AXI_awvalid;
  wire [0:0]    M15_AXI_bready;
  wire [1:0]    M15_AXI_bresp;
  wire [0:0]    M15_AXI_bvalid;
  wire [31:0]   M15_AXI_rdata;
  wire [0:0]    M15_AXI_rready;
  wire [1:0]    M15_AXI_rresp;
  wire [0:0]    M15_AXI_rvalid;
  wire [31:0]   M15_AXI_wdata;
  wire [0:0]    M15_AXI_wready;
  wire [3:0]    M15_AXI_wstrb;
  wire [0:0]    M15_AXI_wvalid;
  
  wire [11:0]   M16_AXI_araddr;
  wire [2:0]    M16_AXI_arprot;
  wire [0:0]    M16_AXI_arready;
  wire [0:0]    M16_AXI_arvalid;
  wire [11:0]   M16_AXI_awaddr;
  wire [2:0]    M16_AXI_awprot;
  wire [0:0]    M16_AXI_awready;
  wire [0:0]    M16_AXI_awvalid;
  wire [0:0]    M16_AXI_bready;
  wire [1:0]    M16_AXI_bresp;
  wire [0:0]    M16_AXI_bvalid;
  wire [31:0]   M16_AXI_rdata;
  wire [0:0]    M16_AXI_rready;
  wire [1:0]    M16_AXI_rresp;
  wire [0:0]    M16_AXI_rvalid;
  wire [31:0]   M16_AXI_wdata;
  wire [0:0]    M16_AXI_wready;
  wire [3:0]    M16_AXI_wstrb;
  wire [0:0]    M16_AXI_wvalid;
  
  wire [11:0]   M17_AXI_araddr;
  wire [2:0]    M17_AXI_arprot;
  wire [0:0]    M17_AXI_arready;
  wire [0:0]    M17_AXI_arvalid;
  wire [11:0]   M17_AXI_awaddr;
  wire [2:0]    M17_AXI_awprot;
  wire [0:0]    M17_AXI_awready;
  wire [0:0]    M17_AXI_awvalid;
  wire [0:0]    M17_AXI_bready;
  wire [1:0]    M17_AXI_bresp;
  wire [0:0]    M17_AXI_bvalid;
  wire [31:0]   M17_AXI_rdata;
  wire [0:0]    M17_AXI_rready;
  wire [1:0]    M17_AXI_rresp;
  wire [0:0]    M17_AXI_rvalid;
  wire [31:0]   M17_AXI_wdata;
  wire [0:0]    M17_AXI_wready;
  wire [3:0]    M17_AXI_wstrb;
  wire [0:0]    M17_AXI_wvalid;
  
  wire [11:0]   M18_AXI_araddr;
  wire [2:0]    M18_AXI_arprot;
  wire [0:0]    M18_AXI_arready;
  wire [0:0]    M18_AXI_arvalid;
  wire [11:0]   M18_AXI_awaddr;
  wire [2:0]    M18_AXI_awprot;
  wire [0:0]    M18_AXI_awready;
  wire [0:0]    M18_AXI_awvalid;
  wire [0:0]    M18_AXI_bready;
  wire [1:0]    M18_AXI_bresp;
  wire [0:0]    M18_AXI_bvalid;
  wire [31:0]   M18_AXI_rdata;
  wire [0:0]    M18_AXI_rready;
  wire [1:0]    M18_AXI_rresp;
  wire [0:0]    M18_AXI_rvalid;
  wire [31:0]   M18_AXI_wdata;
  wire [0:0]    M18_AXI_wready;
  wire [3:0]    M18_AXI_wstrb;
  wire [0:0]    M18_AXI_wvalid;
  
  wire [11:0]   M19_AXI_araddr;
  wire [2:0]    M19_AXI_arprot;
  wire [0:0]    M19_AXI_arready;
  wire [0:0]    M19_AXI_arvalid;
  wire [11:0]   M19_AXI_awaddr;
  wire [2:0]    M19_AXI_awprot;
  wire [0:0]    M19_AXI_awready;
  wire [0:0]    M19_AXI_awvalid;
  wire [0:0]    M19_AXI_bready;
  wire [1:0]    M19_AXI_bresp;
  wire [0:0]    M19_AXI_bvalid;
  wire [31:0]   M19_AXI_rdata;
  wire [0:0]    M19_AXI_rready;
  wire [1:0]    M19_AXI_rresp;
  wire [0:0]    M19_AXI_rvalid;
  wire [31:0]   M19_AXI_wdata;
  wire [0:0]    M19_AXI_wready;
  wire [3:0]    M19_AXI_wstrb;
  wire [0:0]    M19_AXI_wvalid;
  
  wire [11:0]   M20_AXI_araddr;
  wire [2:0]    M20_AXI_arprot;
  wire [0:0]    M20_AXI_arready;
  wire [0:0]    M20_AXI_arvalid;
  wire [11:0]   M20_AXI_awaddr;
  wire [2:0]    M20_AXI_awprot;
  wire [0:0]    M20_AXI_awready;
  wire [0:0]    M20_AXI_awvalid;
  wire [0:0]    M20_AXI_bready;
  wire [1:0]    M20_AXI_bresp;
  wire [0:0]    M20_AXI_bvalid;
  wire [31:0]   M20_AXI_rdata;
  wire [0:0]    M20_AXI_rready;
  wire [1:0]    M20_AXI_rresp;
  wire [0:0]    M20_AXI_rvalid;
  wire [31:0]   M20_AXI_wdata;
  wire [0:0]    M20_AXI_wready;
  wire [3:0]    M20_AXI_wstrb;
  wire [0:0]    M20_AXI_wvalid;

// 10G Interfaces
//Port 0
  wire sfp_qplllock     ;
  wire sfp_qplloutrefclk;
  wire sfp_qplloutclk   ;
  wire sfp_clk156;
  wire sfp_areset_clk156;      
  wire sfp_gttxreset;          
  wire sfp_gtrxreset;          
  wire sfp_txuserrdy;          
  wire sfp_txusrclk;           
  wire sfp_txusrclk2;          
  wire sfp_reset_counter_done; 
  wire sfp_tx_axis_areset;     
  wire sfp_tx_axis_aresetn;    
  wire sfp_rx_axis_aresetn; 

  wire port0_ready;
  wire block0_lock; 
  wire sfp0_resetdone;
  wire sfp0_txclk322;

  wire port1_ready;
  wire block1_lock; 
  wire sfp1_tx_resetdone;
  wire sfp1_rx_resetdone;
  wire sfp1_txclk322;

  wire port2_ready;
  wire block2_lock; 
  wire sfp2_tx_resetdone;
  wire sfp2_rx_resetdone;
  wire sfp2_txclk322;

  wire port3_ready;
  wire block3_lock; 
  wire sfp3_tx_resetdone;
  wire sfp3_rx_resetdone;
  wire sfp3_txclk322;
 
  wire i2c_scl_o;
  wire i2c_scl_i;
  wire i2c_scl_t;
  wire i2c_sda_o;
  wire i2c_sda_i;
  wire i2c_sda_t;
  
  wire axi_clk;
  wire axi_aresetn;
  wire sys_reset;
  
 (* ASYNC_REG = "TRUE" *) reg [3:0] core200_reset_sync_n;
  wire axis_resetn;
  wire axi_datapath_resetn;
  wire peripheral_reset;
  
  // // Assign interface numbers to ports
  // // Odd bits are ports and even bits are DMA
  // localparam IF_SFP0 = 8'b00000001;
  // localparam IF_SFP1 = 8'b00000100;
  // localparam IF_SFP2 = 8'b00010000;
  // localparam IF_SFP3 = 8'b01000000;

  // -
  // Assign interface numbers to ports
  // Odd bits are ports, even bits (1,3,5) are DMA, bit 7 is verifier module
  localparam IF_SFP0 = 8'b00000001;
  localparam IF_SFP1 = 8'b00000100;
  localparam IF_SFP2 = 8'b00010000;
  localparam IF_SFP3 = 8'b01000000;
  
  ///////////////////////////// DEBUG ONLY ///////////////////////////
  // system clk heartbeat 
  reg [27:0]                                 sfp_clk156_count;
  reg [27:0]                                 sfp_clk100_count;  
  reg [1:0]                                  led;
  
  
  
//---------------------------------------------------------------------
// Misc 
//---------------------------------------------------------------------
  
// Debug LEDs  
// 156MHz clk heartbeat ~ every second
OBUF led_0_obuf (
    .O                       (leds[0]), 
    .I                       (led[0])
   );

// 100MHz clk heartbeat ~ every 1.5 seconds  
OBUF led_1_obuf (
    .O                       (leds[1]), 
    .I                       (led[1])
   );

////////////////////////////////////////
// clock generation and buffers  
IBUF sys_reset_n_ibuf(  
   .O                        (sys_rst_n_c),   
   .I                        (sys_reset_n)
  );

IBUFDS_GTE2 #(
    .CLKCM_CFG               ("TRUE"),   
    .CLKRCV_TRST             ("TRUE"), 
    .CLKSWING_CFG            (2'b11)            // Refer to Transceiver User Guide
) IBUFDS_GTE2_inst (
    .O                       (sys_clk),         // 1-bit output: Refer to Transceiver User Guide
    .ODIV2                   (),                // 1-bit output: Refer to Transceiver User Guide
    .CEB                     (1'b0),            // 1-bit input: Refer to Transceiver User Guide
    .I                       (sys_clkp),        // 1-bit input: Refer to Transceiver User Guide
    .IB                      (sys_clkn)         // 1-bit input: Refer to Transceiver User Guide
  );  
  
IOBUF i2c_scl_iobuf (
    .I                       (i2c_scl_o),
    .IO                      (i2c_clk),
    .O                       (i2c_scl_i),
    .T                       (i2c_scl_t)
  );
          
IOBUF i2c_sda_iobuf (
    .I                       (i2c_sda_o),
    .IO                      (i2c_data),
    .O                       (i2c_sda_i),
    .T                       (i2c_sda_t)
  );      
  
axi_clocking axi_clocking_i (
    .clk_in_p               (fpga_sysclk_p),
    .clk_in_n               (fpga_sysclk_n),
    .clk_200                (clk_200),       // generates 200MHz clk
    .locked                 (clk_200_locked),
    .resetn                 (sys_rst_n_c)
  );
  
// axi_clk - 100MHz - assign through buffer
BUFG axi_lite_bufg0 (
  .I                        (sys_clk),
  .O                        (axi_clk)
);   
  

////////////////////////////////////////  
// main resets
proc_sys_reset_ip proc_sys_reset_i (
  .slowest_sync_clk(clk_200),          // input wire slowest_sync_clk
  .ext_reset_in(sys_rst_n_c),                  // input wire ext_reset_in
  .aux_reset_in(1'b1),                  // input wire aux_reset_in
  .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
  .dcm_locked(clk_200_locked),                      // input wire dcm_locked
  .mb_reset(),                          // output wire mb_reset
  .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset(peripheral_reset),          // output wire [0 : 3] peripheral_reset
  .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn(axis_resetn)      // output wire [0 : 7] peripheral_aresetn
);


assign sys_reset    = !sys_rst_n_c;
//assign axi_aresetn  = sys_rst_n_c;

always @ (posedge clk_200) begin
    if (!sys_rst_n_c)  
        core200_reset_sync_n <= 4'h0; 
    else
        core200_reset_sync_n <= #1 {core200_reset_sync_n[2:0],sys_rst_n_c};
end

  
assign axi_aresetn  = axis_resetn;
assign axi_datapath_resetn = axis_resetn;
    
  


//-----------------------------------------------------------------------------------------------//
// Network modules                                                                               //
//-----------------------------------------------------------------------------------------------//

nf_datapath 
#(
    // Master AXI Stream Data Width
    .C_M_AXIS_DATA_WIDTH (C_DATA_WIDTH),
    .C_S_AXIS_DATA_WIDTH (C_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH (12),
    .C_M_AXIS_TUSER_WIDTH (128),
    .C_S_AXIS_TUSER_WIDTH (128),
    .NUM_QUEUES (5)
)
nf_datapath_0 
(
    .axis_aclk                        (clk_200),
    .axis_resetn                      (axis_resetn),
    .axi_aclk                        (clk_200),
    .axi_resetn                      (axi_datapath_resetn),
    
    // Slave Stream Ports (interface from Rx queues)
    .s_axis_0_tdata                 (axis_i_0_tdata),  
    .s_axis_0_tkeep                 (axis_i_0_tkeep),  
    .s_axis_0_tuser                 (axis_i_0_tuser),  
    .s_axis_0_tvalid                (axis_i_0_tvalid), 
    .s_axis_0_tready                (axis_i_0_tready), 
    .s_axis_0_tlast                 (axis_i_0_tlast),  
    .s_axis_1_tdata                 (axis_i_1_tdata),  
    .s_axis_1_tkeep                 (axis_i_1_tkeep),  
    .s_axis_1_tuser                 (axis_i_1_tuser),  
    .s_axis_1_tvalid                (axis_i_1_tvalid), 
    .s_axis_1_tready                (axis_i_1_tready), 
    .s_axis_1_tlast                 (axis_i_1_tlast),  
    .s_axis_2_tdata                 (axis_i_2_tdata),  
    .s_axis_2_tkeep                 (axis_i_2_tkeep),  
    .s_axis_2_tuser                 (axis_i_2_tuser),  
    .s_axis_2_tvalid                (axis_i_2_tvalid), 
    .s_axis_2_tready                (axis_i_2_tready), 
    .s_axis_2_tlast                 (axis_i_2_tlast),  
    .s_axis_3_tdata                 (axis_i_3_tdata),  
    .s_axis_3_tkeep                 (axis_i_3_tkeep),  
    .s_axis_3_tuser                 (axis_i_3_tuser),  
    .s_axis_3_tvalid                (axis_i_3_tvalid), 
    .s_axis_3_tready                (axis_i_3_tready), 
    .s_axis_3_tlast                 (axis_i_3_tlast),  
    .s_axis_4_tdata                 (axis_dma_i_tdata ), 
    .s_axis_4_tkeep                 (axis_dma_i_tkeep ), 
    .s_axis_4_tuser                 (axis_dma_i_tuser[127:0] ), 
    .s_axis_4_tvalid                (axis_dma_i_tvalid), 
    .s_axis_4_tready                (axis_dma_i_tready ), 
    .s_axis_4_tlast                 (axis_dma_i_tlast),  


    // Master Stream Ports (interface to TX queues)
    .m_axis_0_tdata                (axis_o_0_tdata),
    .m_axis_0_tkeep                (axis_o_0_tkeep),
    .m_axis_0_tuser                (axis_o_0_tuser),
    .m_axis_0_tvalid               (axis_o_0_tvalid),
    .m_axis_0_tready               (axis_o_0_tready),
    .m_axis_0_tlast                (axis_o_0_tlast),
    .m_axis_1_tdata                (axis_o_1_tdata), 
    .m_axis_1_tkeep                (axis_o_1_tkeep), 
    .m_axis_1_tuser                (axis_o_1_tuser), 
    .m_axis_1_tvalid               (axis_o_1_tvalid),
    .m_axis_1_tready               (axis_o_1_tready),
    .m_axis_1_tlast                (axis_o_1_tlast), 
    .m_axis_2_tdata                (axis_o_2_tdata), 
    .m_axis_2_tkeep                (axis_o_2_tkeep), 
    .m_axis_2_tuser                (axis_o_2_tuser), 
    .m_axis_2_tvalid               (axis_o_2_tvalid),
    .m_axis_2_tready               (axis_o_2_tready),
    .m_axis_2_tlast                (axis_o_2_tlast), 
    .m_axis_3_tdata                (axis_o_3_tdata ), 
    .m_axis_3_tkeep                (axis_o_3_tkeep ), 
    .m_axis_3_tuser                (axis_o_3_tuser ), 
    .m_axis_3_tvalid               (axis_o_3_tvalid),
    .m_axis_3_tready               (axis_o_3_tready),
    .m_axis_3_tlast                (axis_o_3_tlast ), 
    .m_axis_4_tdata                (axis_dma_o_tdata ),
    .m_axis_4_tkeep                (axis_dma_o_tkeep ),
    .m_axis_4_tuser                (axis_dma_o_tuser ),
    .m_axis_4_tvalid               (axis_dma_o_tvalid),
    .m_axis_4_tready               (axis_dma_o_tready ),
    .m_axis_4_tlast                (axis_dma_o_tlast),
   
   //AXI-Lite interface  
 
    .S0_AXI_AWADDR                    (M01_AXI_awaddr), 
    .S0_AXI_AWVALID                   (M01_AXI_awvalid),
    .S0_AXI_WDATA                     (M01_AXI_wdata),  
    .S0_AXI_WSTRB                     (M01_AXI_wstrb),  
    .S0_AXI_WVALID                    (M01_AXI_wvalid), 
    .S0_AXI_BREADY                    (M01_AXI_bready), 
    .S0_AXI_ARADDR                    (M01_AXI_araddr), 
    .S0_AXI_ARVALID                   (M01_AXI_arvalid),
    .S0_AXI_RREADY                    (M01_AXI_rready), 
    .S0_AXI_ARREADY                   (M01_AXI_arready),
    .S0_AXI_RDATA                     (M01_AXI_rdata),  
    .S0_AXI_RRESP                     (M01_AXI_rresp),  
    .S0_AXI_RVALID                    (M01_AXI_rvalid), 
    .S0_AXI_WREADY                    (M01_AXI_wready), 
    .S0_AXI_BRESP                     (M01_AXI_bresp),  
    .S0_AXI_BVALID                    (M01_AXI_bvalid), 
    .S0_AXI_AWREADY                   (M01_AXI_awready),
     
     .S1_AXI_AWADDR                    (M02_AXI_awaddr), 
     .S1_AXI_AWVALID                   (M02_AXI_awvalid),
     .S1_AXI_WDATA                     (M02_AXI_wdata),  
     .S1_AXI_WSTRB                     (M02_AXI_wstrb),  
     .S1_AXI_WVALID                    (M02_AXI_wvalid), 
     .S1_AXI_BREADY                    (M02_AXI_bready), 
     .S1_AXI_ARADDR                    (M02_AXI_araddr), 
     .S1_AXI_ARVALID                   (M02_AXI_arvalid),
     .S1_AXI_RREADY                    (M02_AXI_rready), 
     .S1_AXI_ARREADY                   (M02_AXI_arready),
     .S1_AXI_RDATA                     (M02_AXI_rdata),  
     .S1_AXI_RRESP                     (M02_AXI_rresp),  
     .S1_AXI_RVALID                    (M02_AXI_rvalid), 
     .S1_AXI_WREADY                    (M02_AXI_wready), 
     .S1_AXI_BRESP                     (M02_AXI_bresp),  
     .S1_AXI_BVALID                    (M02_AXI_bvalid), 
     .S1_AXI_AWREADY                   (M02_AXI_awready),

     .S2_AXI_AWADDR                    (M03_AXI_awaddr), 
     .S2_AXI_AWVALID                   (M03_AXI_awvalid),
     .S2_AXI_WDATA                     (M03_AXI_wdata),  
     .S2_AXI_WSTRB                     (M03_AXI_wstrb),  
     .S2_AXI_WVALID                    (M03_AXI_wvalid), 
     .S2_AXI_BREADY                    (M03_AXI_bready), 
     .S2_AXI_ARADDR                    (M03_AXI_araddr), 
     .S2_AXI_ARVALID                   (M03_AXI_arvalid),
     .S2_AXI_RREADY                    (M03_AXI_rready), 
     .S2_AXI_ARREADY                   (M03_AXI_arready),
     .S2_AXI_RDATA                     (M03_AXI_rdata),  
     .S2_AXI_RRESP                     (M03_AXI_rresp),  
     .S2_AXI_RVALID                    (M03_AXI_rvalid), 
     .S2_AXI_WREADY                    (M03_AXI_wready), 
     .S2_AXI_BRESP                     (M03_AXI_bresp),  
     .S2_AXI_BVALID                    (M03_AXI_bvalid), 
     .S2_AXI_AWREADY                   (M03_AXI_awready),

     .S3_AXI_AWADDR                    (M09_AXI_awaddr), 
     .S3_AXI_AWVALID                   (M09_AXI_awvalid),
     .S3_AXI_WDATA                     (M09_AXI_wdata),  
     .S3_AXI_WSTRB                     (M09_AXI_wstrb),  
     .S3_AXI_WVALID                    (M09_AXI_wvalid), 
     .S3_AXI_BREADY                    (M09_AXI_bready), 
     .S3_AXI_ARADDR                    (M09_AXI_araddr), 
     .S3_AXI_ARVALID                   (M09_AXI_arvalid),
     .S3_AXI_RREADY                    (M09_AXI_rready), 
     .S3_AXI_ARREADY                   (M09_AXI_arready),
     .S3_AXI_RDATA                     (M09_AXI_rdata),  
     .S3_AXI_RRESP                     (M09_AXI_rresp),  
     .S3_AXI_RVALID                    (M09_AXI_rvalid), 
     .S3_AXI_WREADY                    (M09_AXI_wready), 
     .S3_AXI_BRESP                     (M09_AXI_bresp),  
     .S3_AXI_BVALID                    (M09_AXI_bvalid), 
     .S3_AXI_AWREADY                   (M09_AXI_awready),

     .S4_AXI_AWADDR                    (M10_AXI_awaddr), 
     .S4_AXI_AWVALID                   (M10_AXI_awvalid),
     .S4_AXI_WDATA                     (M10_AXI_wdata),  
     .S4_AXI_WSTRB                     (M10_AXI_wstrb),  
     .S4_AXI_WVALID                    (M10_AXI_wvalid), 
     .S4_AXI_BREADY                    (M10_AXI_bready), 
     .S4_AXI_ARADDR                    (M10_AXI_araddr), 
     .S4_AXI_ARVALID                   (M10_AXI_arvalid),
     .S4_AXI_RREADY                    (M10_AXI_rready), 
     .S4_AXI_ARREADY                   (M10_AXI_arready),
     .S4_AXI_RDATA                     (M10_AXI_rdata),  
     .S4_AXI_RRESP                     (M10_AXI_rresp),  
     .S4_AXI_RVALID                    (M10_AXI_rvalid), 
     .S4_AXI_WREADY                    (M10_AXI_wready), 
     .S4_AXI_BRESP                     (M10_AXI_bresp),  
     .S4_AXI_BVALID                    (M10_AXI_bvalid), 
     .S4_AXI_AWREADY                   (M10_AXI_awready),

     .S5_AXI_AWADDR                    (M11_AXI_awaddr), 
     .S5_AXI_AWVALID                   (M11_AXI_awvalid),
     .S5_AXI_WDATA                     (M11_AXI_wdata),  
     .S5_AXI_WSTRB                     (M11_AXI_wstrb),  
     .S5_AXI_WVALID                    (M11_AXI_wvalid), 
     .S5_AXI_BREADY                    (M11_AXI_bready), 
     .S5_AXI_ARADDR                    (M11_AXI_araddr), 
     .S5_AXI_ARVALID                   (M11_AXI_arvalid),
     .S5_AXI_RREADY                    (M11_AXI_rready), 
     .S5_AXI_ARREADY                   (M11_AXI_arready),
     .S5_AXI_RDATA                     (M11_AXI_rdata),  
     .S5_AXI_RRESP                     (M11_AXI_rresp),  
     .S5_AXI_RVALID                    (M11_AXI_rvalid), 
     .S5_AXI_WREADY                    (M11_AXI_wready), 
     .S5_AXI_BRESP                     (M11_AXI_bresp),  
     .S5_AXI_BVALID                    (M11_AXI_bvalid), 
     .S5_AXI_AWREADY                   (M11_AXI_awready),

     .S6_AXI_AWADDR                    (M12_AXI_awaddr), 
     .S6_AXI_AWVALID                   (M12_AXI_awvalid),
     .S6_AXI_WDATA                     (M12_AXI_wdata),  
     .S6_AXI_WSTRB                     (M12_AXI_wstrb),  
     .S6_AXI_WVALID                    (M12_AXI_wvalid), 
     .S6_AXI_BREADY                    (M12_AXI_bready), 
     .S6_AXI_ARADDR                    (M12_AXI_araddr), 
     .S6_AXI_ARVALID                   (M12_AXI_arvalid),
     .S6_AXI_RREADY                    (M12_AXI_rready), 
     .S6_AXI_ARREADY                   (M12_AXI_arready),
     .S6_AXI_RDATA                     (M12_AXI_rdata),  
     .S6_AXI_RRESP                     (M12_AXI_rresp),  
     .S6_AXI_RVALID                    (M12_AXI_rvalid), 
     .S6_AXI_WREADY                    (M12_AXI_wready), 
     .S6_AXI_BRESP                     (M12_AXI_bresp),  
     .S6_AXI_BVALID                    (M12_AXI_bvalid), 
     .S6_AXI_AWREADY                   (M12_AXI_awready),

     .S7_AXI_AWADDR                    (M13_AXI_awaddr), 
     .S7_AXI_AWVALID                   (M13_AXI_awvalid),
     .S7_AXI_WDATA                     (M13_AXI_wdata),  
     .S7_AXI_WSTRB                     (M13_AXI_wstrb),  
     .S7_AXI_WVALID                    (M13_AXI_wvalid), 
     .S7_AXI_BREADY                    (M13_AXI_bready), 
     .S7_AXI_ARADDR                    (M13_AXI_araddr), 
     .S7_AXI_ARVALID                   (M13_AXI_arvalid),
     .S7_AXI_RREADY                    (M13_AXI_rready), 
     .S7_AXI_ARREADY                   (M13_AXI_arready),
     .S7_AXI_RDATA                     (M13_AXI_rdata),  
     .S7_AXI_RRESP                     (M13_AXI_rresp),  
     .S7_AXI_RVALID                    (M13_AXI_rvalid), 
     .S7_AXI_WREADY                    (M13_AXI_wready), 
     .S7_AXI_BRESP                     (M13_AXI_bresp),  
     .S7_AXI_BVALID                    (M13_AXI_bvalid), 
     .S7_AXI_AWREADY                   (M13_AXI_awready),

     .S8_AXI_AWADDR                    (M14_AXI_awaddr), 
     .S8_AXI_AWVALID                   (M14_AXI_awvalid),
     .S8_AXI_WDATA                     (M14_AXI_wdata),  
     .S8_AXI_WSTRB                     (M14_AXI_wstrb),  
     .S8_AXI_WVALID                    (M14_AXI_wvalid), 
     .S8_AXI_BREADY                    (M14_AXI_bready), 
     .S8_AXI_ARADDR                    (M14_AXI_araddr), 
     .S8_AXI_ARVALID                   (M14_AXI_arvalid),
     .S8_AXI_RREADY                    (M14_AXI_rready), 
     .S8_AXI_ARREADY                   (M14_AXI_arready),
     .S8_AXI_RDATA                     (M14_AXI_rdata),  
     .S8_AXI_RRESP                     (M14_AXI_rresp),  
     .S8_AXI_RVALID                    (M14_AXI_rvalid), 
     .S8_AXI_WREADY                    (M14_AXI_wready), 
     .S8_AXI_BRESP                     (M14_AXI_bresp),  
     .S8_AXI_BVALID                    (M14_AXI_bvalid), 
     .S8_AXI_AWREADY                   (M14_AXI_awready),
     
     .S9_AXI_AWADDR                    (M15_AXI_awaddr), 
     .S9_AXI_AWVALID                   (M15_AXI_awvalid),
     .S9_AXI_WDATA                     (M15_AXI_wdata),  
     .S9_AXI_WSTRB                     (M15_AXI_wstrb),  
     .S9_AXI_WVALID                    (M15_AXI_wvalid), 
     .S9_AXI_BREADY                    (M15_AXI_bready), 
     .S9_AXI_ARADDR                    (M15_AXI_araddr), 
     .S9_AXI_ARVALID                   (M15_AXI_arvalid),
     .S9_AXI_RREADY                    (M15_AXI_rready), 
     .S9_AXI_ARREADY                   (M15_AXI_arready),
     .S9_AXI_RDATA                     (M15_AXI_rdata),  
     .S9_AXI_RRESP                     (M15_AXI_rresp),  
     .S9_AXI_RVALID                    (M15_AXI_rvalid), 
     .S9_AXI_WREADY                    (M15_AXI_wready), 
     .S9_AXI_BRESP                     (M15_AXI_bresp),  
     .S9_AXI_BVALID                    (M15_AXI_bvalid), 
     .S9_AXI_AWREADY                   (M15_AXI_awready),
     
     .S10_AXI_AWADDR                    (M16_AXI_awaddr), 
     .S10_AXI_AWVALID                   (M16_AXI_awvalid),
     .S10_AXI_WDATA                     (M16_AXI_wdata),  
     .S10_AXI_WSTRB                     (M16_AXI_wstrb),  
     .S10_AXI_WVALID                    (M16_AXI_wvalid), 
     .S10_AXI_BREADY                    (M16_AXI_bready), 
     .S10_AXI_ARADDR                    (M16_AXI_araddr), 
     .S10_AXI_ARVALID                   (M16_AXI_arvalid),
     .S10_AXI_RREADY                    (M16_AXI_rready), 
     .S10_AXI_ARREADY                   (M16_AXI_arready),
     .S10_AXI_RDATA                     (M16_AXI_rdata),  
     .S10_AXI_RRESP                     (M16_AXI_rresp),  
     .S10_AXI_RVALID                    (M16_AXI_rvalid), 
     .S10_AXI_WREADY                    (M16_AXI_wready), 
     .S10_AXI_BRESP                     (M16_AXI_bresp),  
     .S10_AXI_BVALID                    (M16_AXI_bvalid), 
     .S10_AXI_AWREADY                   (M16_AXI_awready),
     
     .S11_AXI_AWADDR                    (M17_AXI_awaddr), 
     .S11_AXI_AWVALID                   (M17_AXI_awvalid),
     .S11_AXI_WDATA                     (M17_AXI_wdata),  
     .S11_AXI_WSTRB                     (M17_AXI_wstrb),  
     .S11_AXI_WVALID                    (M17_AXI_wvalid), 
     .S11_AXI_BREADY                    (M17_AXI_bready), 
     .S11_AXI_ARADDR                    (M17_AXI_araddr), 
     .S11_AXI_ARVALID                   (M17_AXI_arvalid),
     .S11_AXI_RREADY                    (M17_AXI_rready), 
     .S11_AXI_ARREADY                   (M17_AXI_arready),
     .S11_AXI_RDATA                     (M17_AXI_rdata),  
     .S11_AXI_RRESP                     (M17_AXI_rresp),  
     .S11_AXI_RVALID                    (M17_AXI_rvalid), 
     .S11_AXI_WREADY                    (M17_AXI_wready), 
     .S11_AXI_BRESP                     (M17_AXI_bresp),  
     .S11_AXI_BVALID                    (M17_AXI_bvalid), 
     .S11_AXI_AWREADY                   (M17_AXI_awready),
     
     .S12_AXI_AWADDR                    (M18_AXI_awaddr), 
     .S12_AXI_AWVALID                   (M18_AXI_awvalid),
     .S12_AXI_WDATA                     (M18_AXI_wdata),  
     .S12_AXI_WSTRB                     (M18_AXI_wstrb),  
     .S12_AXI_WVALID                    (M18_AXI_wvalid), 
     .S12_AXI_BREADY                    (M18_AXI_bready), 
     .S12_AXI_ARADDR                    (M18_AXI_araddr), 
     .S12_AXI_ARVALID                   (M18_AXI_arvalid),
     .S12_AXI_RREADY                    (M18_AXI_rready), 
     .S12_AXI_ARREADY                   (M18_AXI_arready),
     .S12_AXI_RDATA                     (M18_AXI_rdata),  
     .S12_AXI_RRESP                     (M18_AXI_rresp),  
     .S12_AXI_RVALID                    (M18_AXI_rvalid), 
     .S12_AXI_WREADY                    (M18_AXI_wready), 
     .S12_AXI_BRESP                     (M18_AXI_bresp),  
     .S12_AXI_BVALID                    (M18_AXI_bvalid), 
     .S12_AXI_AWREADY                   (M18_AXI_awready),
     
     .S13_AXI_AWADDR                    (M19_AXI_awaddr), 
     .S13_AXI_AWVALID                   (M19_AXI_awvalid),
     .S13_AXI_WDATA                     (M19_AXI_wdata),  
     .S13_AXI_WSTRB                     (M19_AXI_wstrb),  
     .S13_AXI_WVALID                    (M19_AXI_wvalid), 
     .S13_AXI_BREADY                    (M19_AXI_bready), 
     .S13_AXI_ARADDR                    (M19_AXI_araddr), 
     .S13_AXI_ARVALID                   (M19_AXI_arvalid),
     .S13_AXI_RREADY                    (M19_AXI_rready), 
     .S13_AXI_ARREADY                   (M19_AXI_arready),
     .S13_AXI_RDATA                     (M19_AXI_rdata),  
     .S13_AXI_RRESP                     (M19_AXI_rresp),  
     .S13_AXI_RVALID                    (M19_AXI_rvalid), 
     .S13_AXI_WREADY                    (M19_AXI_wready), 
     .S13_AXI_BRESP                     (M19_AXI_bresp),  
     .S13_AXI_BVALID                    (M19_AXI_bvalid), 
     .S13_AXI_AWREADY                   (M19_AXI_awready),
     
     .S14_AXI_AWADDR                    (M20_AXI_awaddr), 
     .S14_AXI_AWVALID                   (M20_AXI_awvalid),
     .S14_AXI_WDATA                     (M20_AXI_wdata),  
     .S14_AXI_WSTRB                     (M20_AXI_wstrb),  
     .S14_AXI_WVALID                    (M20_AXI_wvalid), 
     .S14_AXI_BREADY                    (M20_AXI_bready), 
     .S14_AXI_ARADDR                    (M20_AXI_araddr), 
     .S14_AXI_ARVALID                   (M20_AXI_arvalid),
     .S14_AXI_RREADY                    (M20_AXI_rready), 
     .S14_AXI_ARREADY                   (M20_AXI_arready),
     .S14_AXI_RDATA                     (M20_AXI_rdata),  
     .S14_AXI_RRESP                     (M20_AXI_rresp),  
     .S14_AXI_RVALID                    (M20_AXI_rvalid), 
     .S14_AXI_WREADY                    (M20_AXI_wready), 
     .S14_AXI_BRESP                     (M20_AXI_bresp),  
     .S14_AXI_BVALID                    (M20_AXI_bvalid), 
     .S14_AXI_AWREADY                   (M20_AXI_awready)
         
    );

  
// PCIe to {AXI_Lite, AXIS} bridge
control_sub control_sub_i
       (
           .M00_AXI_araddr  (M00_AXI_araddr  ),
           .M00_AXI_arprot  (M00_AXI_arprot  ),
           .M00_AXI_arready (M00_AXI_arready ),
           .M00_AXI_arvalid (M00_AXI_arvalid ),
           .M00_AXI_awaddr  (M00_AXI_awaddr  ),
           .M00_AXI_awprot  (M00_AXI_awprot  ),
           .M00_AXI_awready (M00_AXI_awready ),
           .M00_AXI_awvalid (M00_AXI_awvalid ),
           .M00_AXI_bready  (M00_AXI_bready  ),
           .M00_AXI_bresp   (M00_AXI_bresp   ),
           .M00_AXI_bvalid  (M00_AXI_bvalid  ),
           .M00_AXI_rdata   (M00_AXI_rdata   ),
           .M00_AXI_rready  (M00_AXI_rready  ),
           .M00_AXI_rresp   (M00_AXI_rresp   ),
           .M00_AXI_rvalid  (M00_AXI_rvalid  ),
           .M00_AXI_wdata   (M00_AXI_wdata   ),
           .M00_AXI_wready  (M00_AXI_wready  ),
           .M00_AXI_wstrb   (M00_AXI_wstrb   ),
           .M00_AXI_wvalid  (M00_AXI_wvalid  ),
           
           .M01_AXI_araddr  (M01_AXI_araddr  ),
           .M01_AXI_arprot  (M01_AXI_arprot  ),
           .M01_AXI_arready (M01_AXI_arready ),
           .M01_AXI_arvalid (M01_AXI_arvalid ),
           .M01_AXI_awaddr  (M01_AXI_awaddr  ),
           .M01_AXI_awprot  (M01_AXI_awprot  ),
           .M01_AXI_awready (M01_AXI_awready ),
           .M01_AXI_awvalid (M01_AXI_awvalid ),
           .M01_AXI_bready  (M01_AXI_bready  ),
           .M01_AXI_bresp   (M01_AXI_bresp   ),
           .M01_AXI_bvalid  (M01_AXI_bvalid  ),
           .M01_AXI_rdata   (M01_AXI_rdata   ),
           .M01_AXI_rready  (M01_AXI_rready  ),
           .M01_AXI_rresp   (M01_AXI_rresp   ),
           .M01_AXI_rvalid  (M01_AXI_rvalid  ),
           .M01_AXI_wdata   (M01_AXI_wdata   ),
           .M01_AXI_wready  (M01_AXI_wready  ),
           .M01_AXI_wstrb   (M01_AXI_wstrb   ),
           .M01_AXI_wvalid  (M01_AXI_wvalid  ),           

           .M02_AXI_araddr  (M02_AXI_araddr  ),
           .M02_AXI_arprot  (M02_AXI_arprot  ),
           .M02_AXI_arready (M02_AXI_arready ),
           .M02_AXI_arvalid (M02_AXI_arvalid ),
           .M02_AXI_awaddr  (M02_AXI_awaddr  ),
           .M02_AXI_awprot  (M02_AXI_awprot  ),
           .M02_AXI_awready (M02_AXI_awready ),
           .M02_AXI_awvalid (M02_AXI_awvalid ),
           .M02_AXI_bready  (M02_AXI_bready  ),
           .M02_AXI_bresp   (M02_AXI_bresp   ),
           .M02_AXI_bvalid  (M02_AXI_bvalid  ),
           .M02_AXI_rdata   (M02_AXI_rdata   ),
           .M02_AXI_rready  (M02_AXI_rready  ),
           .M02_AXI_rresp   (M02_AXI_rresp   ),
           .M02_AXI_rvalid  (M02_AXI_rvalid  ),
           .M02_AXI_wdata   (M02_AXI_wdata   ),
           .M02_AXI_wready  (M02_AXI_wready  ),
           .M02_AXI_wstrb   (M02_AXI_wstrb   ),
           .M02_AXI_wvalid  (M02_AXI_wvalid  ),   

           .M03_AXI_araddr  (M03_AXI_araddr ),
           .M03_AXI_arprot  (M03_AXI_arprot ),
           .M03_AXI_arready (M03_AXI_arready),
           .M03_AXI_arvalid (M03_AXI_arvalid),
           .M03_AXI_awaddr  (M03_AXI_awaddr ),
           .M03_AXI_awprot  (M03_AXI_awprot ),
           .M03_AXI_awready (M03_AXI_awready),
           .M03_AXI_awvalid (M03_AXI_awvalid),
           .M03_AXI_bready  (M03_AXI_bready ),
           .M03_AXI_bresp   (M03_AXI_bresp  ),
           .M03_AXI_bvalid  (M03_AXI_bvalid ),
           .M03_AXI_rdata   (M03_AXI_rdata  ),
           .M03_AXI_rready  (M03_AXI_rready ),
           .M03_AXI_rresp   (M03_AXI_rresp  ),
           .M03_AXI_rvalid  (M03_AXI_rvalid ),
           .M03_AXI_wdata   (M03_AXI_wdata  ),
           .M03_AXI_wready  (M03_AXI_wready ),
           .M03_AXI_wstrb   (M03_AXI_wstrb  ),
           .M03_AXI_wvalid  (M03_AXI_wvalid ), 

           .M04_AXI_araddr  (M04_AXI_araddr ),
           .M04_AXI_arprot  (M04_AXI_arprot ),
           .M04_AXI_arready (M04_AXI_arready),
           .M04_AXI_arvalid (M04_AXI_arvalid),
           .M04_AXI_awaddr  (M04_AXI_awaddr ),
           .M04_AXI_awprot  (M04_AXI_awprot ),
           .M04_AXI_awready (M04_AXI_awready),
           .M04_AXI_awvalid (M04_AXI_awvalid),
           .M04_AXI_bready  (M04_AXI_bready ),
           .M04_AXI_bresp   (M04_AXI_bresp  ),
           .M04_AXI_bvalid  (M04_AXI_bvalid ),
           .M04_AXI_rdata   (M04_AXI_rdata  ),
           .M04_AXI_rready  (M04_AXI_rready ),
           .M04_AXI_rresp   (M04_AXI_rresp  ),
           .M04_AXI_rvalid  (M04_AXI_rvalid ),
           .M04_AXI_wdata   (M04_AXI_wdata  ),
           .M04_AXI_wready  (M04_AXI_wready ),
           .M04_AXI_wstrb   (M04_AXI_wstrb  ),
           .M04_AXI_wvalid  (M04_AXI_wvalid ),

           .M05_AXI_araddr  (M05_AXI_araddr ),
           .M05_AXI_arprot  (M05_AXI_arprot ),
           .M05_AXI_arready (M05_AXI_arready),
           .M05_AXI_arvalid (M05_AXI_arvalid),
           .M05_AXI_awaddr  (M05_AXI_awaddr ),
           .M05_AXI_awprot  (M05_AXI_awprot ),
           .M05_AXI_awready (M05_AXI_awready),
           .M05_AXI_awvalid (M05_AXI_awvalid),
           .M05_AXI_bready  (M05_AXI_bready ),
           .M05_AXI_bresp   (M05_AXI_bresp  ),
           .M05_AXI_bvalid  (M05_AXI_bvalid ),
           .M05_AXI_rdata   (M05_AXI_rdata  ),
           .M05_AXI_rready  (M05_AXI_rready ),
           .M05_AXI_rresp   (M05_AXI_rresp  ),
           .M05_AXI_rvalid  (M05_AXI_rvalid ),
           .M05_AXI_wdata   (M05_AXI_wdata  ),
           .M05_AXI_wready  (M05_AXI_wready ),
           .M05_AXI_wstrb   (M05_AXI_wstrb  ),
           .M05_AXI_wvalid  (M05_AXI_wvalid ),  

           .M06_AXI_araddr  (M06_AXI_araddr ),
           .M06_AXI_arprot  (M06_AXI_arprot ),
           .M06_AXI_arready (M06_AXI_arready),
           .M06_AXI_arvalid (M06_AXI_arvalid),
           .M06_AXI_awaddr  (M06_AXI_awaddr ),
           .M06_AXI_awprot  (M06_AXI_awprot ),
           .M06_AXI_awready (M06_AXI_awready),
           .M06_AXI_awvalid (M06_AXI_awvalid),
           .M06_AXI_bready  (M06_AXI_bready ),
           .M06_AXI_bresp   (M06_AXI_bresp  ),
           .M06_AXI_bvalid  (M06_AXI_bvalid ),
           .M06_AXI_rdata   (M06_AXI_rdata  ),
           .M06_AXI_rready  (M06_AXI_rready ),
           .M06_AXI_rresp   (M06_AXI_rresp  ),
           .M06_AXI_rvalid  (M06_AXI_rvalid ),
           .M06_AXI_wdata   (M06_AXI_wdata  ),
           .M06_AXI_wready  (M06_AXI_wready ),
           .M06_AXI_wstrb   (M06_AXI_wstrb  ),
           .M06_AXI_wvalid  (M06_AXI_wvalid ),  

           .M07_AXI_araddr  (M07_AXI_araddr ),
           .M07_AXI_arprot  (M07_AXI_arprot ),
           .M07_AXI_arready (M07_AXI_arready),
           .M07_AXI_arvalid (M07_AXI_arvalid),
           .M07_AXI_awaddr  (M07_AXI_awaddr ),
           .M07_AXI_awprot  (M07_AXI_awprot ),
           .M07_AXI_awready (M07_AXI_awready),
           .M07_AXI_awvalid (M07_AXI_awvalid),
           .M07_AXI_bready  (M07_AXI_bready ),
           .M07_AXI_bresp   (M07_AXI_bresp  ),
           .M07_AXI_bvalid  (M07_AXI_bvalid ),
           .M07_AXI_rdata   (M07_AXI_rdata  ),
           .M07_AXI_rready  (M07_AXI_rready ),
           .M07_AXI_rresp   (M07_AXI_rresp  ),
           .M07_AXI_rvalid  (M07_AXI_rvalid ),
           .M07_AXI_wdata   (M07_AXI_wdata  ),
           .M07_AXI_wready  (M07_AXI_wready ),
           .M07_AXI_wstrb   (M07_AXI_wstrb  ),
           .M07_AXI_wvalid  (M07_AXI_wvalid ),

           .M09_AXI_araddr  (M09_AXI_araddr ),
           .M09_AXI_arprot  (M09_AXI_arprot ),
           .M09_AXI_arready (M09_AXI_arready),
           .M09_AXI_arvalid (M09_AXI_arvalid),
           .M09_AXI_awaddr  (M09_AXI_awaddr ),
           .M09_AXI_awprot  (M09_AXI_awprot ),
           .M09_AXI_awready (M09_AXI_awready),
           .M09_AXI_awvalid (M09_AXI_awvalid),
           .M09_AXI_bready  (M09_AXI_bready ),
           .M09_AXI_bresp   (M09_AXI_bresp  ),
           .M09_AXI_bvalid  (M09_AXI_bvalid ),
           .M09_AXI_rdata   (M09_AXI_rdata  ),
           .M09_AXI_rready  (M09_AXI_rready ),
           .M09_AXI_rresp   (M09_AXI_rresp  ),
           .M09_AXI_rvalid  (M09_AXI_rvalid ),
           .M09_AXI_wdata   (M09_AXI_wdata  ),
           .M09_AXI_wready  (M09_AXI_wready ),
           .M09_AXI_wstrb   (M09_AXI_wstrb  ),
           .M09_AXI_wvalid  (M09_AXI_wvalid ), 

           .M10_AXI_araddr  (M10_AXI_araddr ),
           .M10_AXI_arprot  (M10_AXI_arprot ),
           .M10_AXI_arready (M10_AXI_arready),
           .M10_AXI_arvalid (M10_AXI_arvalid),
           .M10_AXI_awaddr  (M10_AXI_awaddr ),
           .M10_AXI_awprot  (M10_AXI_awprot ),
           .M10_AXI_awready (M10_AXI_awready),
           .M10_AXI_awvalid (M10_AXI_awvalid),
           .M10_AXI_bready  (M10_AXI_bready ),
           .M10_AXI_bresp   (M10_AXI_bresp  ),
           .M10_AXI_bvalid  (M10_AXI_bvalid ),
           .M10_AXI_rdata   (M10_AXI_rdata  ),
           .M10_AXI_rready  (M10_AXI_rready ),
           .M10_AXI_rresp   (M10_AXI_rresp  ),
           .M10_AXI_rvalid  (M10_AXI_rvalid ),
           .M10_AXI_wdata   (M10_AXI_wdata  ),
           .M10_AXI_wready  (M10_AXI_wready ),
           .M10_AXI_wstrb   (M10_AXI_wstrb  ),
           .M10_AXI_wvalid  (M10_AXI_wvalid ), 

           .M11_AXI_araddr  (M11_AXI_araddr ),
           .M11_AXI_arprot  (M11_AXI_arprot ),
           .M11_AXI_arready (M11_AXI_arready),
           .M11_AXI_arvalid (M11_AXI_arvalid),
           .M11_AXI_awaddr  (M11_AXI_awaddr ),
           .M11_AXI_awprot  (M11_AXI_awprot ),
           .M11_AXI_awready (M11_AXI_awready),
           .M11_AXI_awvalid (M11_AXI_awvalid),
           .M11_AXI_bready  (M11_AXI_bready ),
           .M11_AXI_bresp   (M11_AXI_bresp  ),
           .M11_AXI_bvalid  (M11_AXI_bvalid ),
           .M11_AXI_rdata   (M11_AXI_rdata  ),
           .M11_AXI_rready  (M11_AXI_rready ),
           .M11_AXI_rresp   (M11_AXI_rresp  ),
           .M11_AXI_rvalid  (M11_AXI_rvalid ),
           .M11_AXI_wdata   (M11_AXI_wdata  ),
           .M11_AXI_wready  (M11_AXI_wready ),
           .M11_AXI_wstrb   (M11_AXI_wstrb  ),
           .M11_AXI_wvalid  (M11_AXI_wvalid ), 

           .M12_AXI_araddr  (M12_AXI_araddr ),
           .M12_AXI_arprot  (M12_AXI_arprot ),
           .M12_AXI_arready (M12_AXI_arready),
           .M12_AXI_arvalid (M12_AXI_arvalid),
           .M12_AXI_awaddr  (M12_AXI_awaddr ),
           .M12_AXI_awprot  (M12_AXI_awprot ),
           .M12_AXI_awready (M12_AXI_awready),
           .M12_AXI_awvalid (M12_AXI_awvalid),
           .M12_AXI_bready  (M12_AXI_bready ),
           .M12_AXI_bresp   (M12_AXI_bresp  ),
           .M12_AXI_bvalid  (M12_AXI_bvalid ),
           .M12_AXI_rdata   (M12_AXI_rdata  ),
           .M12_AXI_rready  (M12_AXI_rready ),
           .M12_AXI_rresp   (M12_AXI_rresp  ),
           .M12_AXI_rvalid  (M12_AXI_rvalid ),
           .M12_AXI_wdata   (M12_AXI_wdata  ),
           .M12_AXI_wready  (M12_AXI_wready ),
           .M12_AXI_wstrb   (M12_AXI_wstrb  ),
           .M12_AXI_wvalid  (M12_AXI_wvalid ),  

           .M13_AXI_araddr  (M13_AXI_araddr ),
           .M13_AXI_arprot  (M13_AXI_arprot ),
           .M13_AXI_arready (M13_AXI_arready),
           .M13_AXI_arvalid (M13_AXI_arvalid),
           .M13_AXI_awaddr  (M13_AXI_awaddr ),
           .M13_AXI_awprot  (M13_AXI_awprot ),
           .M13_AXI_awready (M13_AXI_awready),
           .M13_AXI_awvalid (M13_AXI_awvalid),
           .M13_AXI_bready  (M13_AXI_bready ),
           .M13_AXI_bresp   (M13_AXI_bresp  ),
           .M13_AXI_bvalid  (M13_AXI_bvalid ),
           .M13_AXI_rdata   (M13_AXI_rdata  ),
           .M13_AXI_rready  (M13_AXI_rready ),
           .M13_AXI_rresp   (M13_AXI_rresp  ),
           .M13_AXI_rvalid  (M13_AXI_rvalid ),
           .M13_AXI_wdata   (M13_AXI_wdata  ),
           .M13_AXI_wready  (M13_AXI_wready ),
           .M13_AXI_wstrb   (M13_AXI_wstrb  ),
           .M13_AXI_wvalid  (M13_AXI_wvalid ),   

           .M14_AXI_araddr  (M14_AXI_araddr ),
           .M14_AXI_arprot  (M14_AXI_arprot ),
           .M14_AXI_arready (M14_AXI_arready),
           .M14_AXI_arvalid (M14_AXI_arvalid),
           .M14_AXI_awaddr  (M14_AXI_awaddr ),
           .M14_AXI_awprot  (M14_AXI_awprot ),
           .M14_AXI_awready (M14_AXI_awready),
           .M14_AXI_awvalid (M14_AXI_awvalid),
           .M14_AXI_bready  (M14_AXI_bready ),
           .M14_AXI_bresp   (M14_AXI_bresp  ),
           .M14_AXI_bvalid  (M14_AXI_bvalid ),
           .M14_AXI_rdata   (M14_AXI_rdata  ),
           .M14_AXI_rready  (M14_AXI_rready ),
           .M14_AXI_rresp   (M14_AXI_rresp  ),
           .M14_AXI_rvalid  (M14_AXI_rvalid ),
           .M14_AXI_wdata   (M14_AXI_wdata  ),
           .M14_AXI_wready  (M14_AXI_wready ),
           .M14_AXI_wstrb   (M14_AXI_wstrb  ),
           .M14_AXI_wvalid  (M14_AXI_wvalid ),   

           .M15_AXI_araddr  (M15_AXI_araddr ),
           .M15_AXI_arprot  (M15_AXI_arprot ),
           .M15_AXI_arready (M15_AXI_arready),
           .M15_AXI_arvalid (M15_AXI_arvalid),
           .M15_AXI_awaddr  (M15_AXI_awaddr ),
           .M15_AXI_awprot  (M15_AXI_awprot ),
           .M15_AXI_awready (M15_AXI_awready),
           .M15_AXI_awvalid (M15_AXI_awvalid),
           .M15_AXI_bready  (M15_AXI_bready ),
           .M15_AXI_bresp   (M15_AXI_bresp  ),
           .M15_AXI_bvalid  (M15_AXI_bvalid ),
           .M15_AXI_rdata   (M15_AXI_rdata  ),
           .M15_AXI_rready  (M15_AXI_rready ),
           .M15_AXI_rresp   (M15_AXI_rresp  ),
           .M15_AXI_rvalid  (M15_AXI_rvalid ),
           .M15_AXI_wdata   (M15_AXI_wdata  ),
           .M15_AXI_wready  (M15_AXI_wready ),
           .M15_AXI_wstrb   (M15_AXI_wstrb  ),
           .M15_AXI_wvalid  (M15_AXI_wvalid ),   

           .M16_AXI_araddr  (M16_AXI_araddr ),
           .M16_AXI_arprot  (M16_AXI_arprot ),
           .M16_AXI_arready (M16_AXI_arready),
           .M16_AXI_arvalid (M16_AXI_arvalid),
           .M16_AXI_awaddr  (M16_AXI_awaddr ),
           .M16_AXI_awprot  (M16_AXI_awprot ),
           .M16_AXI_awready (M16_AXI_awready),
           .M16_AXI_awvalid (M16_AXI_awvalid),
           .M16_AXI_bready  (M16_AXI_bready ),
           .M16_AXI_bresp   (M16_AXI_bresp  ),
           .M16_AXI_bvalid  (M16_AXI_bvalid ),
           .M16_AXI_rdata   (M16_AXI_rdata  ),
           .M16_AXI_rready  (M16_AXI_rready ),
           .M16_AXI_rresp   (M16_AXI_rresp  ),
           .M16_AXI_rvalid  (M16_AXI_rvalid ),
           .M16_AXI_wdata   (M16_AXI_wdata  ),
           .M16_AXI_wready  (M16_AXI_wready ),
           .M16_AXI_wstrb   (M16_AXI_wstrb  ),
           .M16_AXI_wvalid  (M16_AXI_wvalid ),   

           .M17_AXI_araddr  (M17_AXI_araddr ),
           .M17_AXI_arprot  (M17_AXI_arprot ),
           .M17_AXI_arready (M17_AXI_arready),
           .M17_AXI_arvalid (M17_AXI_arvalid),
           .M17_AXI_awaddr  (M17_AXI_awaddr ),
           .M17_AXI_awprot  (M17_AXI_awprot ),
           .M17_AXI_awready (M17_AXI_awready),
           .M17_AXI_awvalid (M17_AXI_awvalid),
           .M17_AXI_bready  (M17_AXI_bready ),
           .M17_AXI_bresp   (M17_AXI_bresp  ),
           .M17_AXI_bvalid  (M17_AXI_bvalid ),
           .M17_AXI_rdata   (M17_AXI_rdata  ),
           .M17_AXI_rready  (M17_AXI_rready ),
           .M17_AXI_rresp   (M17_AXI_rresp  ),
           .M17_AXI_rvalid  (M17_AXI_rvalid ),
           .M17_AXI_wdata   (M17_AXI_wdata  ),
           .M17_AXI_wready  (M17_AXI_wready ),
           .M17_AXI_wstrb   (M17_AXI_wstrb  ),
           .M17_AXI_wvalid  (M17_AXI_wvalid ),   

           .M18_AXI_araddr  (M18_AXI_araddr ),
           .M18_AXI_arprot  (M18_AXI_arprot ),
           .M18_AXI_arready (M18_AXI_arready),
           .M18_AXI_arvalid (M18_AXI_arvalid),
           .M18_AXI_awaddr  (M18_AXI_awaddr ),
           .M18_AXI_awprot  (M18_AXI_awprot ),
           .M18_AXI_awready (M18_AXI_awready),
           .M18_AXI_awvalid (M18_AXI_awvalid),
           .M18_AXI_bready  (M18_AXI_bready ),
           .M18_AXI_bresp   (M18_AXI_bresp  ),
           .M18_AXI_bvalid  (M18_AXI_bvalid ),
           .M18_AXI_rdata   (M18_AXI_rdata  ),
           .M18_AXI_rready  (M18_AXI_rready ),
           .M18_AXI_rresp   (M18_AXI_rresp  ),
           .M18_AXI_rvalid  (M18_AXI_rvalid ),
           .M18_AXI_wdata   (M18_AXI_wdata  ),
           .M18_AXI_wready  (M18_AXI_wready ),
           .M18_AXI_wstrb   (M18_AXI_wstrb  ),
           .M18_AXI_wvalid  (M18_AXI_wvalid ),   

           .M19_AXI_araddr  (M19_AXI_araddr ),
           .M19_AXI_arprot  (M19_AXI_arprot ),
           .M19_AXI_arready (M19_AXI_arready),
           .M19_AXI_arvalid (M19_AXI_arvalid),
           .M19_AXI_awaddr  (M19_AXI_awaddr ),
           .M19_AXI_awprot  (M19_AXI_awprot ),
           .M19_AXI_awready (M19_AXI_awready),
           .M19_AXI_awvalid (M19_AXI_awvalid),
           .M19_AXI_bready  (M19_AXI_bready ),
           .M19_AXI_bresp   (M19_AXI_bresp  ),
           .M19_AXI_bvalid  (M19_AXI_bvalid ),
           .M19_AXI_rdata   (M19_AXI_rdata  ),
           .M19_AXI_rready  (M19_AXI_rready ),
           .M19_AXI_rresp   (M19_AXI_rresp  ),
           .M19_AXI_rvalid  (M19_AXI_rvalid ),
           .M19_AXI_wdata   (M19_AXI_wdata  ),
           .M19_AXI_wready  (M19_AXI_wready ),
           .M19_AXI_wstrb   (M19_AXI_wstrb  ),
           .M19_AXI_wvalid  (M19_AXI_wvalid ),   

           .M20_AXI_araddr  (M20_AXI_araddr ),
           .M20_AXI_arprot  (M20_AXI_arprot ),
           .M20_AXI_arready (M20_AXI_arready),
           .M20_AXI_arvalid (M20_AXI_arvalid),
           .M20_AXI_awaddr  (M20_AXI_awaddr ),
           .M20_AXI_awprot  (M20_AXI_awprot ),
           .M20_AXI_awready (M20_AXI_awready),
           .M20_AXI_awvalid (M20_AXI_awvalid),
           .M20_AXI_bready  (M20_AXI_bready ),
           .M20_AXI_bresp   (M20_AXI_bresp  ),
           .M20_AXI_bvalid  (M20_AXI_bvalid ),
           .M20_AXI_rdata   (M20_AXI_rdata  ),
           .M20_AXI_rready  (M20_AXI_rready ),
           .M20_AXI_rresp   (M20_AXI_rresp  ),
           .M20_AXI_rvalid  (M20_AXI_rvalid ),
           .M20_AXI_wdata   (M20_AXI_wdata  ),
           .M20_AXI_wready  (M20_AXI_wready ),
           .M20_AXI_wstrb   (M20_AXI_wstrb  ),
           .M20_AXI_wvalid  (M20_AXI_wvalid ),   
           
           //I2C and UART to microblaze
           .iic_fpga_scl_i(i2c_scl_i),
           .iic_fpga_scl_o(i2c_scl_o),
           .iic_fpga_scl_t(i2c_scl_t),
           .iic_fpga_sda_i(i2c_sda_i),
           .iic_fpga_sda_o(i2c_sda_o),
           .iic_fpga_sda_t(i2c_sda_t),
           .iic_reset     (i2c_reset),
           .uart_txd      (uart_txd),
           .uart_rxd      (uart_rxd),
                     
           // axi-lite clk&rst
           // NOTE: (INPUTS now)
           .axi_lite_aclk   (axi_clk),
           .axi_lite_aresetn (axi_aresetn),
          
           // axis clk & rst
           // ref pipe clk
           .axis_datapath_aclk   (clk_200),
           .axis_datapath_aresetn (axis_resetn),
      
           // axis dma tx data
           .m_axis_dma_tx_tdata  (axis_dma_i_tdata),
           .m_axis_dma_tx_tkeep  (axis_dma_i_tkeep),
           .m_axis_dma_tx_tlast  (axis_dma_i_tlast),
           .m_axis_dma_tx_tready (axis_dma_i_tready),
           .m_axis_dma_tx_tuser  (axis_dma_i_tuser),
           .m_axis_dma_tx_tvalid (axis_dma_i_tvalid),

           // axis dma rx data
           .s_axis_dma_rx_tdata  (axis_dma_o_tdata),
           .s_axis_dma_rx_tkeep  (axis_dma_o_tkeep),
           .s_axis_dma_rx_tlast  (axis_dma_o_tlast),
           .s_axis_dma_rx_tready (axis_dma_o_tready),
           .s_axis_dma_rx_tuser  ({128'h0,axis_dma_o_tuser}),
           .s_axis_dma_rx_tvalid (axis_dma_o_tvalid),
         
           // pcie clk, rst, mgt
           .pcie_7x_mgt_rxn (pcie_7x_mgt_rxn),
           .pcie_7x_mgt_rxp (pcie_7x_mgt_rxp),
           .pcie_7x_mgt_txn (pcie_7x_mgt_txn),
           .pcie_7x_mgt_txp (pcie_7x_mgt_txp),
           .sys_clk         (sys_clk),
           .sys_reset       (sys_reset)
        );
        
 

//SFP Port 0

nf_10g_interface_shared_ip nf_10g_interface_0
       (
        
        //Clocks and resets
        .core_clk                    (clk_200      ),
        .refclk_n                    (xphy_refclk_n),
        .refclk_p                    (xphy_refclk_p),
        .rst                         (peripheral_reset    ), 
        .core_resetn                 (axis_resetn), 

        
        //Shared logic 
        .clk156_out                  (sfp_clk156            ),
        .gtrxreset_out               (sfp_gtrxreset         ),
        .gttxreset_out               (sfp_gttxreset         ),
        .qplllock_out                (sfp_qplllock          ),
        .qplloutclk_out              (sfp_qplloutclk        ),
        .qplloutrefclk_out           (sfp_qplloutrefclk     ),
        .txuserrdy_out               (sfp_txuserrdy         ),
        .txusrclk_out                (sfp_txusrclk          ),
        .txusrclk2_out               (sfp_txusrclk2         ),
        .areset_clk156_out           (sfp_areset_clk156     ),
        .reset_counter_done_out      (sfp_reset_counter_done),

        
        //SFP Controls and indications
        .resetdone                   (sfp0_resetdone        ), 
        .tx_fault                    (sfp0_tx_fault         ),    
        .tx_abs                      (sfp0_tx_abs           ), 
        .tx_disable                  (sfp0_tx_disable       ),          

        //AXI Interface
        .m_axis_tdata                (axis_i_0_tdata        ),
        .m_axis_tkeep                (axis_i_0_tkeep        ),
        .m_axis_tuser                (axis_i_0_tuser        ), 
        .m_axis_tvalid               (axis_i_0_tvalid       ),
        .m_axis_tready               (axis_i_0_tready       ),
        .m_axis_tlast                (axis_i_0_tlast        ),
                                     
        .s_axis_tdata                (axis_o_0_tdata        ),
        .s_axis_tkeep                (axis_o_0_tkeep        ),
        .s_axis_tuser                (axis_o_0_tuser        ),
        .s_axis_tvalid               (axis_o_0_tvalid       ),
        .s_axis_tready               (axis_o_0_tready       ),
        .s_axis_tlast                (axis_o_0_tlast        ),
        
        .S_AXI_ACLK           (clk_200     ),
        .S_AXI_ARESETN        (axi_datapath_resetn),
        .S_AXI_AWADDR               (M04_AXI_awaddr),        
        .S_AXI_AWVALID              (M04_AXI_awvalid),       
        .S_AXI_WDATA                (M04_AXI_wdata),         
        .S_AXI_WSTRB                (M04_AXI_wstrb),         
        .S_AXI_WVALID               (M04_AXI_wvalid),        
        .S_AXI_BREADY               (M04_AXI_bready),        
        .S_AXI_ARADDR               (M04_AXI_araddr),        
        .S_AXI_ARVALID              (M04_AXI_arvalid),       
        .S_AXI_RREADY               (M04_AXI_rready),        
        .S_AXI_ARREADY              (M04_AXI_arready),       
        .S_AXI_RDATA                (M04_AXI_rdata),         
        .S_AXI_RRESP                (M04_AXI_rresp),         
        .S_AXI_RVALID               (M04_AXI_rvalid),        
        .S_AXI_WREADY               (M04_AXI_wready),        
        .S_AXI_BRESP                (M04_AXI_bresp),         
        .S_AXI_BVALID               (M04_AXI_bvalid),        
        .S_AXI_AWREADY              (M04_AXI_awready),       
          
        //Serial I/O from/to transceiver
        .rxn                         (sfp0_rx_n             ),
        .rxp                         (sfp0_rx_p             ),
        .txn                         (sfp0_tx_n             ),
        .txp                         (sfp0_tx_p             ),
        
        //Interface number
        .interface_number            (IF_SFP0                )        

  );
  
  assign sfp0_tx_led = sfp0_resetdone ;
  assign sfp0_rx_led = sfp0_resetdone ;

//SFP Port 1

nf_10g_interface_ip nf_10g_interface_1
       (
       //Clocks and resets
       .core_clk                      (clk_200),
       .core_resetn                   (axis_resetn), 
       
       //Shared logic 
        .clk156                       (sfp_clk156        ),       
        .qplllock                     (sfp_qplllock      ),
        .qplloutclk                   (sfp_qplloutclk    ),
        .qplloutrefclk                (sfp_qplloutrefclk ),
        .txuserrdy                    (sfp_txuserrdy     ),
        .txusrclk                     (sfp_txusrclk      ),
        .txusrclk2                    (sfp_txusrclk2     ),
        .areset_clk156                (sfp_areset_clk156 ), 
        .reset_counter_done           (sfp_reset_counter_done),  
      
       //SFP Controls and indications
        .tx_abs                       (sfp1_tx_abs       ),
        .tx_disable                   (sfp1_tx_disable   ),
        .tx_fault                     (sfp1_tx_fault     ),
        .tx_resetdone                 (sfp1_tx_resetdone ),
        .rx_resetdone                 (sfp1_rx_resetdone ),        
        .gtrxreset                    (sfp_gtrxreset     ),
        .gttxreset                    (sfp_gttxreset     ), 
              
      
        //AXI Interface    
        .m_axis_tdata         (axis_i_1_tdata ),
        .m_axis_tkeep         (axis_i_1_tkeep ),
        .m_axis_tuser         (axis_i_1_tuser ),
        .m_axis_tvalid        (axis_i_1_tvalid),
        .m_axis_tready        (axis_i_1_tready),
        .m_axis_tlast         (axis_i_1_tlast ),
                                                
        .s_axis_tdata         (axis_o_1_tdata ),
        .s_axis_tkeep         (axis_o_1_tkeep ),
        .s_axis_tuser         (axis_o_1_tuser ),
        .s_axis_tvalid        (axis_o_1_tvalid),
        .s_axis_tready        (axis_o_1_tready),
        .s_axis_tlast         (axis_o_1_tlast ),
        
        .S_AXI_ACLK           (clk_200     ),
        .S_AXI_ARESETN        (axi_datapath_resetn),
        .S_AXI_AWADDR         (M05_AXI_awaddr),        
        .S_AXI_AWVALID        (M05_AXI_awvalid),       
        .S_AXI_WDATA          (M05_AXI_wdata),         
        .S_AXI_WSTRB          (M05_AXI_wstrb),         
        .S_AXI_WVALID         (M05_AXI_wvalid),        
        .S_AXI_BREADY         (M05_AXI_bready),        
        .S_AXI_ARADDR         (M05_AXI_araddr),        
        .S_AXI_ARVALID        (M05_AXI_arvalid),       
        .S_AXI_RREADY         (M05_AXI_rready),        
        .S_AXI_ARREADY        (M05_AXI_arready),       
        .S_AXI_RDATA          (M05_AXI_rdata),         
        .S_AXI_RRESP          (M05_AXI_rresp),         
        .S_AXI_RVALID         (M05_AXI_rvalid),        
        .S_AXI_WREADY         (M05_AXI_wready),        
        .S_AXI_BRESP          (M05_AXI_bresp),         
        .S_AXI_BVALID         (M05_AXI_bvalid),        
        .S_AXI_AWREADY        (M05_AXI_awready),           
        
        //Serial I/O from/to transceiver  
        .txp              (sfp1_tx_p),
        .txn              (sfp1_tx_n),               
        .rxp              (sfp1_rx_p),
        .rxn              (sfp1_rx_n),
        
                        
        //Interface number
        .interface_number (IF_SFP1)                       
        );

  assign sfp1_tx_led = sfp1_tx_resetdone ;
  assign sfp1_rx_led = sfp1_rx_resetdone ;
  
//SFP Port 2

nf_10g_interface_ip nf_10g_interface_2
       (
       //Clocks and resets
       .core_clk                      (clk_200),
       .core_resetn                   (axis_resetn),  
       
       //Shared logic 
        .clk156                       (sfp_clk156        ),       
        .qplllock                     (sfp_qplllock      ),
        .qplloutclk                   (sfp_qplloutclk    ),
        .qplloutrefclk                (sfp_qplloutrefclk ),
        .txuserrdy                    (sfp_txuserrdy     ),
        .txusrclk                     (sfp_txusrclk      ),
        .txusrclk2                    (sfp_txusrclk2     ),
        .areset_clk156                (sfp_areset_clk156 ), 
        .reset_counter_done           (sfp_reset_counter_done),  
        .gtrxreset                    (sfp_gtrxreset     ),
        .gttxreset                    (sfp_gttxreset     ),        
      
       //SFP Controls and indications
        .tx_abs                       (sfp2_tx_abs       ),
        .tx_disable                   (sfp2_tx_disable   ),
        .tx_fault                     (sfp2_tx_fault     ),
        .tx_resetdone                 (sfp2_tx_resetdone ),
        .rx_resetdone                 (sfp2_rx_resetdone ),        
 
              
      
        //AXI Interface    
        .m_axis_tdata         (axis_i_2_tdata ),
        .m_axis_tkeep         (axis_i_2_tkeep ),
        .m_axis_tuser         (axis_i_2_tuser ),
        .m_axis_tvalid        (axis_i_2_tvalid),
        .m_axis_tready        (axis_i_2_tready),
        .m_axis_tlast         (axis_i_2_tlast ),
                                                
        .s_axis_tdata         (axis_o_2_tdata ),
        .s_axis_tkeep         (axis_o_2_tkeep ),
        .s_axis_tuser         (axis_o_2_tuser ),
        .s_axis_tvalid        (axis_o_2_tvalid),
        .s_axis_tready        (axis_o_2_tready),
        .s_axis_tlast         (axis_o_2_tlast ),
        
        .S_AXI_ACLK           (clk_200     ),
        .S_AXI_ARESETN        (axi_datapath_resetn),
        .S_AXI_AWADDR         (M06_AXI_awaddr),        
        .S_AXI_AWVALID        (M06_AXI_awvalid),       
        .S_AXI_WDATA          (M06_AXI_wdata),         
        .S_AXI_WSTRB          (M06_AXI_wstrb),         
        .S_AXI_WVALID         (M06_AXI_wvalid),        
        .S_AXI_BREADY         (M06_AXI_bready),        
        .S_AXI_ARADDR         (M06_AXI_araddr),        
        .S_AXI_ARVALID        (M06_AXI_arvalid),       
        .S_AXI_RREADY         (M06_AXI_rready),        
        .S_AXI_ARREADY        (M06_AXI_arready),       
        .S_AXI_RDATA          (M06_AXI_rdata),         
        .S_AXI_RRESP          (M06_AXI_rresp),         
        .S_AXI_RVALID         (M06_AXI_rvalid),        
        .S_AXI_WREADY         (M06_AXI_wready),        
        .S_AXI_BRESP          (M06_AXI_bresp),         
        .S_AXI_BVALID         (M06_AXI_bvalid),        
        .S_AXI_AWREADY        (M06_AXI_awready),           
        
        //Serial I/O from/to transceiver  
        .txp              (sfp2_tx_p),
        .txn              (sfp2_tx_n),               
        .rxp              (sfp2_rx_p),
        .rxn              (sfp2_rx_n),
        
                        
        //Interface number
        .interface_number (IF_SFP2)                       
        );

  assign sfp2_tx_led = sfp2_tx_resetdone ;
  assign sfp2_rx_led = sfp2_rx_resetdone ;
  
  
//SFP Port 3

nf_10g_interface_ip nf_10g_interface_3
       (
       //Clocks and resets
       .core_clk                      (clk_200),
       .core_resetn                   (axis_resetn),  
       
       //Shared logic 
        .clk156                       (sfp_clk156        ),       
        .qplllock                     (sfp_qplllock      ),
        .qplloutclk                   (sfp_qplloutclk    ),
        .qplloutrefclk                (sfp_qplloutrefclk ),
        .txuserrdy                    (sfp_txuserrdy     ),
        .txusrclk                     (sfp_txusrclk      ),
        .txusrclk2                    (sfp_txusrclk2     ),
        .areset_clk156                (sfp_areset_clk156 ), 
        .reset_counter_done           (sfp_reset_counter_done),  
        .gtrxreset                    (sfp_gtrxreset     ),
        .gttxreset                    (sfp_gttxreset     ),        
      
       //SFP Controls and indications
        .tx_abs                       (sfp3_tx_abs       ),
        .tx_disable                   (sfp3_tx_disable   ),
        .tx_fault                     (sfp3_tx_fault     ),
        .tx_resetdone                 (sfp3_tx_resetdone ),
        .rx_resetdone                 (sfp3_rx_resetdone ),        
 
              
      
        //AXI Interface    
        .m_axis_tdata         (axis_i_3_tdata ),
        .m_axis_tkeep         (axis_i_3_tkeep ),
        .m_axis_tuser         (axis_i_3_tuser ),
        .m_axis_tvalid        (axis_i_3_tvalid),
        .m_axis_tready        (axis_i_3_tready),
        .m_axis_tlast         (axis_i_3_tlast ),
                                                
        .s_axis_tdata         (axis_o_3_tdata ),
        .s_axis_tkeep         (axis_o_3_tkeep ),
        .s_axis_tuser         (axis_o_3_tuser ),
        .s_axis_tvalid        (axis_o_3_tvalid),
        .s_axis_tready        (axis_o_3_tready),
        .s_axis_tlast         (axis_o_3_tlast ),
        
        .S_AXI_ACLK           (clk_200     ),
        .S_AXI_ARESETN        (axi_datapath_resetn),
        .S_AXI_AWADDR         (M07_AXI_awaddr),        
        .S_AXI_AWVALID        (M07_AXI_awvalid),       
        .S_AXI_WDATA          (M07_AXI_wdata),         
        .S_AXI_WSTRB          (M07_AXI_wstrb),         
        .S_AXI_WVALID         (M07_AXI_wvalid),        
        .S_AXI_BREADY         (M07_AXI_bready),        
        .S_AXI_ARADDR         (M07_AXI_araddr),        
        .S_AXI_ARVALID        (M07_AXI_arvalid),       
        .S_AXI_RREADY         (M07_AXI_rready),        
        .S_AXI_ARREADY        (M07_AXI_arready),       
        .S_AXI_RDATA          (M07_AXI_rdata),         
        .S_AXI_RRESP          (M07_AXI_rresp),         
        .S_AXI_RVALID         (M07_AXI_rvalid),        
        .S_AXI_WREADY         (M07_AXI_wready),        
        .S_AXI_BRESP          (M07_AXI_bresp),         
        .S_AXI_BVALID         (M07_AXI_bvalid),        
        .S_AXI_AWREADY        (M07_AXI_awready),           
        
        //Serial I/O from/to transceiver  
        .txp              (sfp3_tx_p),
        .txn              (sfp3_tx_n),               
        .rxp              (sfp3_rx_p),
        .rxn              (sfp3_rx_n),
        
                        
        //Interface number
        .interface_number (IF_SFP3)                       
        );

  assign sfp3_tx_led = sfp3_tx_resetdone ;
  assign sfp3_rx_led = sfp3_rx_resetdone ;

//Identifier Block
identifier_ip identifier (
  .s_aclk       (clk_200),                
  .s_aresetn    (axi_datapath_resetn),          
  .s_axi_awaddr (M00_AXI_awaddr),    
  .s_axi_awvalid(M00_AXI_awvalid),  
  .s_axi_awready(M00_AXI_awready),  
  .s_axi_wdata  (M00_AXI_wdata),      
  .s_axi_wstrb  (M00_AXI_wstrb),      
  .s_axi_wvalid (M00_AXI_wvalid),    
  .s_axi_wready (M00_AXI_wready),    
  .s_axi_bresp  (M00_AXI_bresp),      
  .s_axi_bvalid (M00_AXI_bvalid),    
  .s_axi_bready (M00_AXI_bready),    
  .s_axi_araddr (M00_AXI_araddr ),   
  .s_axi_arvalid(M00_AXI_arvalid),  
  .s_axi_arready(M00_AXI_arready),  
  .s_axi_rdata  (M00_AXI_rdata),      
  .s_axi_rresp  (M00_AXI_rresp),      
  .s_axi_rvalid (M00_AXI_rvalid),    
  .s_axi_rready (M00_AXI_rready)    
);

 


//////////////////////// DEBUG ONLY ////////////////////////////////
// 100MHz PCIe clk heartbeat ~ every 1.5 seconds
always @ (posedge axi_clk) begin
       sfp_clk100_count <= sfp_clk100_count + 1'b1;
       if (!sfp_clk100_count) begin
            led[1] <= ~led[1];
       end  
end
  
// 156MHz sfp clock heartbeat ~ every second
always @ (posedge sfp_clk156) begin
       sfp_clk156_count <= sfp_clk156_count + 1'b1;
       if (!sfp_clk156_count) begin
            led[0] <= ~led[0];
       end  
end

endmodule
