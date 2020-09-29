
`timescale 1ns / 1ps

//
// Copyright (c) 2017 Stephen Ibanez
// All rights reserved.
//
// This software was developed by Stanford University and the University of Cambridge Computer Laboratory 
// under National Science Foundation under Grant No. CNS-0855268,
// the University of Cambridge Computer Laboratory under EPSRC INTERNET Project EP/H040536/1 and
// by the University of Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-11-C-0249 ("MRC2"), 
// as part of the DARPA MRC research programme.
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


//////////////////////////////////////////////////////////////////////////////////
// Affiliation: Stanford University
// Engineer: Stephen Ibanez
// 
// Create Date: 03/23/2017
// Module Name: sume_to_sdnet
//////////////////////////////////////////////////////////////////////////////////

module sume_to_sdnet (

// clk/rst input
input                               axi_clk,
input                               axi_resetn,

// input SUME axi signals
input                               SUME_axi_tvalid,
input                               SUME_axi_tlast,
input                               SUME_axi_tready,

// output SDNet signals
output                              SDNet_tuple_VALID,
output                              SDNet_axi_TLAST

);


// registers to hold the value of tvalid and tlast on the previous clock cycle
reg SUME_axi_tvalid_prev;
reg SUME_axi_tlast_prev;
reg SUME_axi_tready_prev;

// register to remember if tvalid has already gone high for this packet
reg tvalid_has_gone_high;

always @(posedge axi_clk) begin
    if (~axi_resetn) begin
        SUME_axi_tvalid_prev <= 1'b0;
        SUME_axi_tlast_prev <= 1'b0;
        SUME_axi_tready_prev <= 1'b0;
        tvalid_has_gone_high <= 1'b0;
    end
    else begin
        SUME_axi_tvalid_prev <= SUME_axi_tvalid;
        SUME_axi_tlast_prev <= SUME_axi_tlast;
        SUME_axi_tready_prev <= SUME_axi_tready;
        if (SUME_axi_tlast)
            tvalid_has_gone_high <= 1'b0;
        else if (SUME_axi_tvalid)
            tvalid_has_gone_high <= 1'b1;
        else
            tvalid_has_gone_high <= tvalid_has_gone_high;
    end
end

// tuple_in_VALID should be high whenever (tvalid goes high AND
// it is the first time tvalid has gone high since tlast went high)
// OR (tvalid stays high AND tlast was high on the previous cycle AND
// tready was high on the previous cycle).
// This lines up with the first word of each packet
assign SDNet_tuple_VALID = (SUME_axi_tvalid & ~SUME_axi_tvalid_prev & ~tvalid_has_gone_high) | (SUME_axi_tvalid & SUME_axi_tvalid_prev & SUME_axi_tlast_prev & SUME_axi_tready_prev);


// the SDNet_TLAST signal should only go high when TVALID is high
assign SDNet_axi_TLAST = SUME_axi_tvalid & SUME_axi_tlast;

endmodule // sume_to_sdnet

