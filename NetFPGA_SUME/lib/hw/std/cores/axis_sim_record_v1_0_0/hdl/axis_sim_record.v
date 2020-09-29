//-
// Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
//                          Junior University
// Copyright (c) 2010, 2011 James Hongyi Zeng
// Copyright (c) 2015 David J. Miller, Georgina Kalogeridou
// All rights reserved.
//
// This software was developed by
// Stanford University and the University of Cambridge Computer Laboratory
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
/*******************************************************************************
 *  File:
 *        axis_sim_record.v
 *
 *  Library:
 *        hw/std/cores/axis_sim_record_v1_0_0
 *
 *  Module:
 *        axis_sim_record
 *
 *  Author:
 *        James Hongyi Zeng, David J. Miller, Georgina Kalogeridou,
 *        modified by Stephen Ibanez
 *
 *  Description:
 *        Records traffic received from an AXI Stream master to an
 *        AXI grammar formatted text file.
 *
 *        Added backpressure to limit the rate at which this module can
 *        receive traffic. Count READY_COUNT cycles of receiving data
 *        followed by NOT_READY_COUNT cycles of not receiving data. 
 */


`timescale 1ns/1ps

module axis_sim_record
#(
    // Master AXI Stream Data Width
    parameter C_S_AXIS_DATA_WIDTH = 256,
    parameter C_S_AXIS_TUSER_WIDTH = 128,
    parameter OUTPUT_FILE = "../../stream_data_out.axi",
    parameter READY_COUNT = 2,
    parameter NOT_READY_COUNT = 8
)
(
    // Part 1: System side signals
    // Global Ports
    input axi_aclk,

    // Slave Stream Ports (interface to data path)
    input [C_S_AXIS_DATA_WIDTH - 1:0] s_axis_tdata,
    input [((C_S_AXIS_DATA_WIDTH / 8)) - 1:0] s_axis_tkeep,
    input [C_S_AXIS_TUSER_WIDTH-1:0] s_axis_tuser,
    input s_axis_tvalid,
    output reg s_axis_tready,
    input s_axis_tlast,

    output reg [10:0] counter,
    output reg activity_rec
);

    integer f;
    integer bubble_count = 0;
    reg [8*2-1:0] terminal_flag;
    
    initial begin
        f = $fopen(OUTPUT_FILE, "w");
        counter = 0;

        state = READY;
        ready_count = 0;
        not_ready_count = 0;
    end

    reg [1:0] state;
    reg [1:0] state_next;
    // states
    localparam READY = 0;
    localparam NOT_READY = 1;

    reg [31:0] ready_count;
    reg [31:0] ready_count_next;
    reg [31:0] not_ready_count;
    reg [31:0] not_ready_count_next;
     
    always@(*) begin
        state_next = state;
        s_axis_tready = 0;
        ready_count_next = ready_count;
        not_ready_count_next = not_ready_count;

        case(state)
            READY: begin
                s_axis_tready = 1;
                if (ready_count == READY_COUNT-1) begin
                    state_next = NOT_READY;
                    ready_count_next = 0;
                end
                else if (s_axis_tvalid) begin
                    ready_count_next = ready_count + 1;
                end
            end

            NOT_READY: begin
                s_axis_tready = 0;
                if (not_ready_count == NOT_READY_COUNT-1) begin
                    state_next = READY;
                    not_ready_count_next = 0;
                end
                else begin
                    not_ready_count_next = not_ready_count + 1;
                end
            end
        endcase

    end

    always @(posedge axi_aclk) begin
        state <= state_next;
        ready_count <= ready_count_next;
        not_ready_count <= not_ready_count_next;
    end


    always @(posedge axi_aclk) begin
        if (s_axis_tvalid == 1'b1) begin
            if (s_axis_tready == 1'b1) begin
                if (bubble_count != 0) begin
                    $fwrite(f, "*%0d\n", bubble_count);
                    bubble_count <= 0;
                end
                if (s_axis_tlast == 1'b1) begin
                    terminal_flag = ".";
	            counter <= counter + 1;
	            activity_rec <= 1;
                end
                else begin
                    terminal_flag = ",";
	            activity_rec <= 1;
                end
                
                $fwrite(f, "%x, %x, %x%0s # %0d ns\n",
                                  s_axis_tdata,
                                  s_axis_tkeep,
                                  s_axis_tuser,
                                  terminal_flag,
                                  $time
                                  ); 
            end
        end
        else begin
            bubble_count <= bubble_count + 1;
	    activity_rec <= 0;
        end
    end
endmodule
