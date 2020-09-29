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
 * Logitudinal Redundancy Check (LRC) module
 *
 * Description: split input data into RESULT_WIDTH size words and XOR all the words
 * together to form the result. Essentially a very very simple hash function
 */



`timescale 1 ps / 1 ps

module @MODULE_NAME@ 
#(
    parameter DATA_WIDTH = @DATA_WIDTH@,
    parameter RESULT_WIDTH = @RESULT_WIDTH@
)
(
    // Data Path I/O
    input                                   clk_lookup,
    input                                   rst, 
    input                                   tuple_in_@EXTERN_NAME@_input_VALID,
    input   [DATA_WIDTH:0]                  tuple_in_@EXTERN_NAME@_input_DATA,
    output                                  tuple_out_@EXTERN_NAME@_output_VALID,
    output  [RESULT_WIDTH-1:0]              tuple_out_@EXTERN_NAME@_output_DATA

);


/* Tuple format for input: 
        [DATA_WIDTH                : DATA_WIDTH               ] : statefulValid_in
        [DATA_WIDTH-1              : 0                        ] : data_in

*/

    // convert the input data to readable wires
    wire                    statefulValid_in = tuple_in_@EXTERN_NAME@_input_DATA[DATA_WIDTH];
    wire                          valid_in   = tuple_in_@EXTERN_NAME@_input_VALID;
    wire    [DATA_WIDTH-1:0]      data_in    = tuple_in_@EXTERN_NAME@_input_DATA[DATA_WIDTH-1:0];

    // registers to hold statefulness
    integer                       i;
    reg                           valid_r;
    reg     [RESULT_WIDTH-1:0]    lrc_r;

    // pad the input data to a multiple of RESULT_WIDTH
    localparam PAD_WIDTH = ((DATA_WIDTH % RESULT_WIDTH) == 0) ? 0 : RESULT_WIDTH-(DATA_WIDTH % RESULT_WIDTH);
    wire [DATA_WIDTH + PAD_WIDTH - 1 : 0] pad_data_in = {{PAD_WIDTH{1'b0}}, data_in};

    // combine data into RESULT_WIDTH different words
    localparam WORD_WIDTH = (DATA_WIDTH + PAD_WIDTH)/RESULT_WIDTH;
    reg [WORD_WIDTH-1:0]  mix_data[RESULT_WIDTH-1:0];

    integer ii;
    integer jj;
    always @ (*) begin
        for (ii = 0; ii < WORD_WIDTH; ii=ii+1) begin
            for (jj = 0; jj < RESULT_WIDTH; jj=jj+1) begin
                mix_data[jj][ii] = pad_data_in[ii*RESULT_WIDTH + jj];
            end
        end
    end

    // drive the registers
    always @(posedge clk_lookup)
    begin
        if (rst) begin
            valid_r <= 1'd0;
            lrc_r   <= 'd0;

        end else begin
            valid_r <= valid_in;

            for (i = 0; i < RESULT_WIDTH; i=i+1) begin
                lrc_r[i] <= ^mix_data[i]; // xor bits together
            end
        end
    end

    // Read the new value from the register
    wire [RESULT_WIDTH-1:0] result_out = lrc_r;

    assign tuple_out_@EXTERN_NAME@_output_VALID = valid_r;
    assign tuple_out_@EXTERN_NAME@_output_DATA  = {result_out};

endmodule

