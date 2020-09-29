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


/*
 * File: @MODULE_NAME@.v 
 * Author: Stephen Ibanez
 * 
 * Auto-generated file.
 *
 * Generate timestamp
 *
 * Description: implements a timer that counts every clock cycle (5 ns)
 *   and then wraps after the max value has been reached. The max value
 *   of the time is dictated by the TIMER_WIDTH parameter. 
 */



`timescale 1 ps / 1 ps

module @MODULE_NAME@ 
#(
    parameter TIMER_WIDTH = @TIMER_WIDTH@
)
(
    // Data Path I/O
    input                                   clk_lookup,
    input                                   rst, 
    input                                   tuple_in_@EXTERN_NAME@_input_VALID,
    input   [1:0]                           tuple_in_@EXTERN_NAME@_input_DATA,
    output                                  tuple_out_@EXTERN_NAME@_output_VALID,
    output  [TIMER_WIDTH-1:0]               tuple_out_@EXTERN_NAME@_output_DATA

);


/* Tuple format for input: tuple_in_tin_timestamp_input
        [1:1]   : statefulValid_in
        [0:0]   : valid

*/

/* Tuple format for output: tuple_out_tin_timestamp_output
        [TIMER_WIDTH-1:0]  : result

*/

    // convert the input data to readable wires
    wire    statefulValid_in = tuple_in_@EXTERN_NAME@_input_DATA[1];
    wire    valid_in         = tuple_in_@EXTERN_NAME@_input_VALID;

    // registers to hold statefulness
    reg                               valid_r;
    reg     [TIMER_WIDTH-1:0]         time_r;

    // drive the registers
    always @(posedge clk_lookup)
    begin
        if (rst) begin
            valid_r <= 1'd0;
            time_r <= 'd0;

        end else begin
            valid_r <= valid_in;
            time_r <= time_r + 'd1;
        end
    end

    // Read the new value from the register
    wire [TIMER_WIDTH-1:0] result_out = time_r;

    assign tuple_out_@EXTERN_NAME@_output_VALID = valid_r;
    assign tuple_out_@EXTERN_NAME@_output_DATA  = {result_out};

endmodule


