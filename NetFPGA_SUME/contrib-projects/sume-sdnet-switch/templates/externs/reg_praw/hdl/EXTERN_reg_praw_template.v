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
 * reg_raw
 *
 * This version attempts to set the requested read data on the same 
 * clock cycle as when it is requested. 
 *
 * Designed to take NUM_CYCLES clock cycles to complete
 */



`timescale 1 ps / 1 ps

`define READ_OP    8'd0
`define WRITE_OP   8'd1
`define ADD_OP     8'd2

`define EQ_RELOP    8'd0
`define NEQ_RELOP   8'd1
`define GT_RELOP    8'd2
`define LT_RELOP    8'd3

`include "@PREFIX_NAME@_cpu_regs_defines.v"
module @MODULE_NAME@ 
#(
    parameter NUM_CYCLES = 1,
    parameter INDEX_WIDTH = @INDEX_WIDTH@,
    parameter REG_WIDTH = @REG_WIDTH@,
    parameter OP_WIDTH = 8,
    parameter C_S_AXI_ADDR_WIDTH = @ADDR_WIDTH@,
    parameter C_S_AXI_DATA_WIDTH = 32
)
(
    // Data Path I/O
    input                                            clk_lookup,
    input                                            clk_lookup_rst_high, 
    input                                            tuple_in_@EXTERN_NAME@_input_VALID,
    input   [3*REG_WIDTH+INDEX_WIDTH+2*OP_WIDTH:0]   tuple_in_@EXTERN_NAME@_input_DATA,
    output                                          tuple_out_@EXTERN_NAME@_output_VALID,
    output  [REG_WIDTH:0]                         tuple_out_@EXTERN_NAME@_output_DATA,

    // Control Path I/O
    input                                     clk_control,
    input                                     clk_control_rst_low,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     control_S_AXI_AWADDR,
    input                                     control_S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     control_S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   control_S_AXI_WSTRB,
    input                                     control_S_AXI_WVALID,
    input                                     control_S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     control_S_AXI_ARADDR,
    input                                     control_S_AXI_ARVALID,
    input                                     control_S_AXI_RREADY,
    output                                    control_S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     control_S_AXI_RDATA,
    output     [1 : 0]                        control_S_AXI_RRESP,
    output                                    control_S_AXI_RVALID,
    output                                    control_S_AXI_WREADY,
    output     [1 :0]                         control_S_AXI_BRESP,
    output                                    control_S_AXI_BVALID,
    output                                    control_S_AXI_AWREADY

);


/* Tuple format for input: 
        [3*REG_WIDTH+2*OP_WIDTH+INDEX_WIDTH   : 3*REG_WIDTH+2*OP_WIDTH+INDEX_WIDTH] : statefulValid_in
        [3*REG_WIDTH+2*OP_WIDTH-1+INDEX_WIDTH : 2*OP_WIDTH+3*REG_WIDTH            ] : index_in
        [3*REG_WIDTH+2*OP_WIDTH-1             : 2*OP_WIDTH+2*REG_WIDTH            ] : newVal_in
        [2*REG_WIDTH+2*OP_WIDTH-1             : 2*OP_WIDTH+REG_WIDTH              ] : incVal_in
        [REG_WIDTH+2*OP_WIDTH-1               : OP_WIDTH+REG_WIDTH                ] : opCode_in
        [REG_WIDTH+OP_WIDTH-1                 : OP_WIDTH                          ] : compVal_in
        [OP_WIDTH-1                           : 0                                 ] : relOp_in

*/

    // convert the input data to readable wires
    wire                              statefulValid_in = tuple_in_@EXTERN_NAME@_input_DATA[3*REG_WIDTH+2*OP_WIDTH+INDEX_WIDTH];
    wire                                    valid_in   = tuple_in_@EXTERN_NAME@_input_VALID;
    wire    [INDEX_WIDTH-1:0]               index_in   = tuple_in_@EXTERN_NAME@_input_DATA[3*REG_WIDTH+2*OP_WIDTH-1+INDEX_WIDTH : 2*OP_WIDTH+3*REG_WIDTH];
    wire    [REG_WIDTH-1:0]                 newVal_in  = tuple_in_@EXTERN_NAME@_input_DATA[3*REG_WIDTH+2*OP_WIDTH-1 : 2*OP_WIDTH+2*REG_WIDTH];
    wire    [REG_WIDTH-1:0]                 incVal_in  = tuple_in_@EXTERN_NAME@_input_DATA[2*REG_WIDTH+2*OP_WIDTH-1 : 2*OP_WIDTH+REG_WIDTH];
    wire    [OP_WIDTH-1:0]                  opCode_in  = tuple_in_@EXTERN_NAME@_input_DATA[REG_WIDTH+2*OP_WIDTH-1 : OP_WIDTH+REG_WIDTH];
    wire    [REG_WIDTH-1:0]                 compVal_in = tuple_in_@EXTERN_NAME@_input_DATA[REG_WIDTH+OP_WIDTH-1 : OP_WIDTH];
    wire    [OP_WIDTH-1:0]                  relOp_in   = tuple_in_@EXTERN_NAME@_input_DATA[OP_WIDTH-1:0];


    // final registers
    reg  valid_final_r;
    reg [INDEX_WIDTH-1:0]  index_final_r;
    reg predicate_result_r;

    localparam REG_DEPTH = 2**INDEX_WIDTH;

    // registers to hold statefulness
    integer             i;
    reg     [REG_WIDTH-1:0]      @PREFIX_NAME@_r[REG_DEPTH-1:0];

    // control signals
    // CPU reads IP interface
    wire      [C_S_AXI_DATA_WIDTH-1:0]         ip2cpu_@PREFIX_NAME@_reg_data;
    reg       [REG_WIDTH-1:0]                  ip2cpu_@PREFIX_NAME@_reg_data_adj;
    reg       [INDEX_WIDTH-1:0]                ip2cpu_@PREFIX_NAME@_reg_index;
    reg                                        ip2cpu_@PREFIX_NAME@_reg_valid;
    wire      [INDEX_WIDTH-1:0]                ipReadReq_@PREFIX_NAME@_reg_index;
    wire                                       ipReadReq_@PREFIX_NAME@_reg_valid;

    // CPU writes IP interface
    wire     [C_S_AXI_DATA_WIDTH-1:0]          cpu2ip_@PREFIX_NAME@_reg_data;
    wire     [REG_WIDTH-1:0]                   cpu2ip_@PREFIX_NAME@_reg_data_adj;
    wire     [INDEX_WIDTH-1:0]                 cpu2ip_@PREFIX_NAME@_reg_index;
    wire                                       cpu2ip_@PREFIX_NAME@_reg_valid;
    wire                                       cpu2ip_@PREFIX_NAME@_reg_reset;

    wire resetn_sync;

    // end of pipeline signals
    wire                              statefulValid_end;
    wire                                    valid_end;
    wire    [INDEX_WIDTH-1:0]               index_end;
    wire    [REG_WIDTH-1:0]        newVal_end;
    wire    [REG_WIDTH-1:0]        incVal_end;
    wire    [OP_WIDTH-1:0]                           opCode_end;
    wire    [REG_WIDTH-1:0]        compVal_end;
    wire    [OP_WIDTH-1:0]                           relOp_end;

    // create pipeline registers if required
    generate 
    if (NUM_CYCLES > 1) begin: PIPELINE 
        reg [NUM_CYCLES-2:0]          statefulValid_pipe_r;
        reg [NUM_CYCLES-2:0]          valid_pipe_r;
        reg [INDEX_WIDTH-1:0]         index_pipe_r[NUM_CYCLES-2:0];
        reg [REG_WIDTH-1:0]  newVal_pipe_r[NUM_CYCLES-2:0];
        reg [REG_WIDTH-1:0]  incVal_pipe_r[NUM_CYCLES-2:0];
        reg [OP_WIDTH-1:0] opCode_pipe_r[NUM_CYCLES-2:0];
        reg [REG_WIDTH-1:0]  compVal_pipe_r[NUM_CYCLES-2:0];
        reg [OP_WIDTH-1:0] relOp_pipe_r[NUM_CYCLES-2:0];

        integer j;
        integer k;
    
        // Make pipeline stages to help with timing
        always @ (posedge clk_lookup) begin
            if(~resetn_sync | cpu2ip_@PREFIX_NAME@_reg_reset) begin
                for (j=0; j < NUM_CYCLES-1; j=j+1) begin
                    statefulValid_pipe_r[j] <= 'd0;
                    valid_pipe_r[j] <= 'd0;
                    index_pipe_r[j] <= 'd0;
                    newVal_pipe_r[j] <= 'd0;
                    incVal_pipe_r[j] <= 'd0;
                    opCode_pipe_r[j] <= 'd0;
                    compVal_pipe_r[j] <= 'd0;
                    relOp_pipe_r[j] <= 'd0;
                end
            end
            else begin
                for (k=0; k < NUM_CYCLES-1; k=k+1) begin
                    if (k == 0) begin
                        statefulValid_pipe_r[k] <= statefulValid_in;
                        valid_pipe_r[k] <= valid_in;
                        index_pipe_r[k] <= index_in;
                        newVal_pipe_r[k] <= newVal_in;
                        incVal_pipe_r[k] <= incVal_in;
                        opCode_pipe_r[k] <= opCode_in;
                        compVal_pipe_r[k] <= compVal_in;
                        relOp_pipe_r[k] <= relOp_in;
                    end
                    else begin
                        statefulValid_pipe_r[k] <= statefulValid_pipe_r[k-1];
                        valid_pipe_r[k] <= valid_pipe_r[k-1];
                        index_pipe_r[k] <= index_pipe_r[k-1];
                        newVal_pipe_r[k] <= newVal_pipe_r[k-1];
                        incVal_pipe_r[k] <= incVal_pipe_r[k-1];
                        opCode_pipe_r[k] <= opCode_pipe_r[k-1];
                        compVal_pipe_r[k] <= compVal_pipe_r[k-1];
                        relOp_pipe_r[k] <= relOp_pipe_r[k-1];
                    end
                end
            end
        end

        assign statefulValid_end = statefulValid_pipe_r[NUM_CYCLES-2];
        assign valid_end = valid_pipe_r[NUM_CYCLES-2];
        assign index_end = index_pipe_r[NUM_CYCLES-2];
        assign newVal_end = newVal_pipe_r[NUM_CYCLES-2];
        assign incVal_end = incVal_pipe_r[NUM_CYCLES-2];
        assign opCode_end = opCode_pipe_r[NUM_CYCLES-2];
        assign compVal_end = compVal_pipe_r[NUM_CYCLES-2];
        assign relOp_end = relOp_pipe_r[NUM_CYCLES-2];

    end
    else begin: NO_PIPELINE
        assign statefulValid_end = statefulValid_in;
        assign valid_end = valid_in;
        assign index_end = index_in;
        assign newVal_end = newVal_in;
        assign incVal_end = incVal_in;
        assign opCode_end = opCode_in;
        assign compVal_end = compVal_in;
        assign relOp_end = relOp_in;
    end
    endgenerate

    //// CPU REGS START ////
    @PREFIX_NAME@_cpu_regs
    #(
        .C_BASE_ADDRESS        (0),
        .C_S_AXI_DATA_WIDTH    (C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH    (C_S_AXI_ADDR_WIDTH)
    ) @PREFIX_NAME@_cpu_regs_inst
    (
      // General ports
       .clk                    ( clk_lookup),
       .resetn                 (~clk_lookup_rst_high),
      // AXI Lite ports
       .S_AXI_ACLK             (clk_control),
       .S_AXI_ARESETN          (clk_control_rst_low),
       .S_AXI_AWADDR           (control_S_AXI_AWADDR),
       .S_AXI_AWVALID          (control_S_AXI_AWVALID),
       .S_AXI_WDATA            (control_S_AXI_WDATA),
       .S_AXI_WSTRB            (control_S_AXI_WSTRB),
       .S_AXI_WVALID           (control_S_AXI_WVALID),
       .S_AXI_BREADY           (control_S_AXI_BREADY),
       .S_AXI_ARADDR           (control_S_AXI_ARADDR),
       .S_AXI_ARVALID          (control_S_AXI_ARVALID),
       .S_AXI_RREADY           (control_S_AXI_RREADY),
       .S_AXI_ARREADY          (control_S_AXI_ARREADY),
       .S_AXI_RDATA            (control_S_AXI_RDATA),
       .S_AXI_RRESP            (control_S_AXI_RRESP),
       .S_AXI_RVALID           (control_S_AXI_RVALID),
       .S_AXI_WREADY           (control_S_AXI_WREADY),
       .S_AXI_BRESP            (control_S_AXI_BRESP),
       .S_AXI_BVALID           (control_S_AXI_BVALID),
       .S_AXI_AWREADY          (control_S_AXI_AWREADY),
    
      // Register ports
      // CPU reads IP interface
      .ip2cpu_@PREFIX_NAME@_reg_data          (ip2cpu_@PREFIX_NAME@_reg_data),
      .ip2cpu_@PREFIX_NAME@_reg_index         (ip2cpu_@PREFIX_NAME@_reg_index),
      .ip2cpu_@PREFIX_NAME@_reg_valid         (ip2cpu_@PREFIX_NAME@_reg_valid),
      .ipReadReq_@PREFIX_NAME@_reg_index       (ipReadReq_@PREFIX_NAME@_reg_index),
      .ipReadReq_@PREFIX_NAME@_reg_valid      (ipReadReq_@PREFIX_NAME@_reg_valid),
      // CPU writes IP interface
      .cpu2ip_@PREFIX_NAME@_reg_data          (cpu2ip_@PREFIX_NAME@_reg_data),
      .cpu2ip_@PREFIX_NAME@_reg_index         (cpu2ip_@PREFIX_NAME@_reg_index),
      .cpu2ip_@PREFIX_NAME@_reg_valid         (cpu2ip_@PREFIX_NAME@_reg_valid),
      .cpu2ip_@PREFIX_NAME@_reg_reset         (cpu2ip_@PREFIX_NAME@_reg_reset),
      // Global Registers - user can select if to use
      .cpu_resetn_soft(),//software reset, after cpu module
      .resetn_soft    (),//software reset to cpu module (from central reset management)
      .resetn_sync    (resetn_sync)//synchronized reset, use for better timing
    );
    //// CPU REGS END ////

    generate
    if (C_S_AXI_DATA_WIDTH > REG_WIDTH) begin: SMALL_REG
        assign ip2cpu_@PREFIX_NAME@_reg_data = {'d0, ip2cpu_@PREFIX_NAME@_reg_data_adj};
        assign cpu2ip_@PREFIX_NAME@_reg_data_adj = cpu2ip_@PREFIX_NAME@_reg_data[C_S_AXI_DATA_WIDTH-1:0];
    end
    else if (C_S_AXI_DATA_WIDTH < REG_WIDTH) begin: LARGE_REG
        assign ip2cpu_@PREFIX_NAME@_reg_data = ip2cpu_@PREFIX_NAME@_reg_data_adj[C_S_AXI_DATA_WIDTH-1:0];
        assign cpu2ip_@PREFIX_NAME@_reg_data_adj = {'d0, cpu2ip_@PREFIX_NAME@_reg_data};
    end
    else begin: NORMAL_REG
        assign ip2cpu_@PREFIX_NAME@_reg_data = ip2cpu_@PREFIX_NAME@_reg_data_adj;
        assign cpu2ip_@PREFIX_NAME@_reg_data_adj = cpu2ip_@PREFIX_NAME@_reg_data;
    end
    endgenerate



    // compute predicate  
    wire updateReg = ((relOp_end == `EQ_RELOP)  && (compVal_end == @PREFIX_NAME@_r[index_end])) ? 1'b1 :
                       ((relOp_end == `NEQ_RELOP) && (compVal_end != @PREFIX_NAME@_r[index_end])) ? 1'b1 :
                       ((relOp_end == `GT_RELOP)  && (compVal_end > @PREFIX_NAME@_r[index_end]))  ? 1'b1 :
                       ((relOp_end == `LT_RELOP)  && (compVal_end < @PREFIX_NAME@_r[index_end]))  ? 1'b1 :
                       1'b0;
    
    // drive the registers
    always @(posedge clk_lookup)
    begin
        if (~resetn_sync | cpu2ip_@PREFIX_NAME@_reg_reset) begin
            valid_final_r <= 'd0;
            index_final_r <= 'd0;
            predicate_result_r <= 'd0;
            
            for (i = 0; i < REG_DEPTH; i = i+1) begin
                @PREFIX_NAME@_r[i]     <= `REG_@PREFIX_NAME@_DEFAULT;
            end
        end 
        else begin
            valid_final_r <= valid_end;
            index_final_r <= index_end;
            predicate_result_r <= updateReg;

            if (cpu2ip_@PREFIX_NAME@_reg_valid && cpu2ip_@PREFIX_NAME@_reg_index < REG_DEPTH) begin
                @PREFIX_NAME@_r[cpu2ip_@PREFIX_NAME@_reg_index] <= cpu2ip_@PREFIX_NAME@_reg_data_adj;
            end
            else if (valid_end && statefulValid_end && index_end < REG_DEPTH && updateReg) begin
                if (opCode_end == `WRITE_OP)
                    @PREFIX_NAME@_r[index_end] <= newVal_end;
                else if (opCode_end == `ADD_OP)
                    @PREFIX_NAME@_r[index_end] <= @PREFIX_NAME@_r[index_end] + incVal_end;
            end
        end
    end

    // Read the new value from the register
    wire [REG_WIDTH-1:0] result_out = (index_final_r < REG_DEPTH)? @PREFIX_NAME@_r[index_final_r] : `REG_@PREFIX_NAME@_DEFAULT;
    wire predicate_result = predicate_result_r;

    assign tuple_out_@EXTERN_NAME@_output_VALID = valid_final_r;
    assign tuple_out_@EXTERN_NAME@_output_DATA  = {result_out, predicate_result};

    // control path output
    always @(*) begin
        if (ipReadReq_@PREFIX_NAME@_reg_valid && ipReadReq_@PREFIX_NAME@_reg_index < REG_DEPTH) begin
            ip2cpu_@PREFIX_NAME@_reg_data_adj = @PREFIX_NAME@_r[ipReadReq_@PREFIX_NAME@_reg_index];
            ip2cpu_@PREFIX_NAME@_reg_index = ipReadReq_@PREFIX_NAME@_reg_index; 
            ip2cpu_@PREFIX_NAME@_reg_valid = 'b1; 
        end
        else begin
            ip2cpu_@PREFIX_NAME@_reg_data_adj = @PREFIX_NAME@_r[0];
            ip2cpu_@PREFIX_NAME@_reg_index = 'd0; 
            ip2cpu_@PREFIX_NAME@_reg_valid = 'b0;     
        end
    end

endmodule

