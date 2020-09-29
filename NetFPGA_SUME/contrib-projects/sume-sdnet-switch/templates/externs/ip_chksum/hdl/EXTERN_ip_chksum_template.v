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
 * IP checksum module
 *
 * Description: Treat the input as an IP header and compute the
 * IP checksum. Compute the one's complement of the one's complement
 * sum of the 16-bit words that compose the IP header.
 *
 * Completes in 3 cycles.
 * Does not support IP options
 */



`timescale 1 ps / 1 ps

module @MODULE_NAME@ 
#(
    parameter DATA_WIDTH = 160,
    parameter RESULT_WIDTH = 16
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

    localparam NUM_CYCLES = 3;
    // registers to hold statefulness
    reg     [NUM_CYCLES-1:0]      valid_r;
    reg     [RESULT_WIDTH+3:0]    temp1_r[3:0]; // 20 bits wide
    reg     [RESULT_WIDTH+3:0]    temp2_r;  // 20 bits wide
    reg     [RESULT_WIDTH+3:0]    temp3_r;  // 20 bits wide

    // wire to hold the split up data_in
    localparam NUM_WORDS = DATA_WIDTH/RESULT_WIDTH;
    reg  [RESULT_WIDTH-1:0] ip_data[NUM_WORDS-1:0];

    // split the input data into 10 different 16 bit words
    integer ii;
    always @ (*) begin
        for (ii = 0; ii < NUM_WORDS; ii=ii+1) begin
            if (ii == 4) begin
                ip_data[ii] = 16'b0; // set the checksum field to zero
            end
            else begin
                ip_data[ii] = data_in[RESULT_WIDTH*(ii+1)-1 -: RESULT_WIDTH]; 
            end
        end
    end
    
    // perform the IP header checksum:
    always @ (posedge clk_lookup) begin
        if (rst) begin
            valid_r[0] <= 'd0;
            valid_r[1] <= 'd0;
            valid_r[2] <= 'd0;

            temp1_r[0] <= 'd0;
            temp1_r[1] <= 'd0;
            temp1_r[2] <= 'd0;
            temp1_r[3] <= 'd0;

            temp2_r <=    'd0;

            temp3_r <=    'd0;
        end
        else begin
            valid_r[0] <= valid_in;
            valid_r[1] <= valid_r[0];
            valid_r[2] <= valid_r[1];

            temp1_r[0] <= ip_data[0] + ip_data[1] + ip_data[2];
            temp1_r[1] <= ip_data[3] + ip_data[4] + ip_data[5];
            temp1_r[2] <= ip_data[6] + ip_data[7];
            temp1_r[3] <= ip_data[8] + ip_data[9];
        
            temp2_r <= temp1_r[0] + temp1_r[1] + temp1_r[2] + temp1_r[3];
        
            temp3_r <= {12'b0, temp2_r[19:16]} + temp2_r[15:0];
        end
    end


    // Read the new value from the register
    wire [RESULT_WIDTH-1:0] result_out = ~temp3_r[15:0];
    wire valid_out = valid_r[NUM_CYCLES-1];

    assign tuple_out_@EXTERN_NAME@_output_VALID = valid_out;
    assign tuple_out_@EXTERN_NAME@_output_DATA  = {result_out};

//    // synthesis translate_off
//    // If we have any carry left in top 4 bits then algorithm is wrong
//    if (valid_out && (temp3_r[19:16] != 4'h0)) begin
//       $display("%t %m ERROR: top 4 bits of IP checksum not zero - algo wrong???");
//       #100 $stop;
//    end
//    // synthesis translate_on


endmodule


