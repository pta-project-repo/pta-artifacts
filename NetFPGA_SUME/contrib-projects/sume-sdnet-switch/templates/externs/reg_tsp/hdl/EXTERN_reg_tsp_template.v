// Copyright (c) 2018 -,
// -
// -
// All rights reserved.

// @NETFPGA_LICENSE_HEADER_START@

// Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  NetFPGA licenses this
// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:

// http://www.netfpga-cic.org

// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.

// @NETFPGA_LICENSE_HEADER_END@

/*
 * File: @MODULE_NAME@.v 
 * Author: -
 * 
 * Auto-generated file.
 *
 * reg_rw
 *
 * Timestamp generator
 *
 * Designed to take NUM_CYCLES clock cycles to complete
 */

`timescale 1 ps / 1 ps

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
    input                                   clk_lookup,
    input                                   clk_lookup_rst_high, 
    input                                     tuple_in_@EXTERN_NAME@_input_VALID,
    input   [REG_WIDTH+INDEX_WIDTH+8:0]       tuple_in_@EXTERN_NAME@_input_DATA,
    output                                    tuple_out_@EXTERN_NAME@_output_VALID,
    output  [REG_WIDTH-1:0]                   tuple_out_@EXTERN_NAME@_output_DATA,

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
        [REG_WIDTH+INDEX_WIDTH+8   : REG_WIDTH+INDEX_WIDTH+8] : statefulValid
        [REG_WIDTH+INDEX_WIDTH+7   : REG_WIDTH+8            ] : index_in
        [REG_WIDTH+7               : 8                        ] : newVal_in
        [7                         : 0                        ] : opCode_in
    */

    // convert the input data to readable wires
    wire                                 statefulValid_in = tuple_in_@EXTERN_NAME@_input_DATA[REG_WIDTH+INDEX_WIDTH+8];
    wire                                       valid_in   = tuple_in_@EXTERN_NAME@_input_VALID;
    wire    [INDEX_WIDTH-1:0]                  index_in   = tuple_in_@EXTERN_NAME@_input_DATA[REG_WIDTH+INDEX_WIDTH+7 : REG_WIDTH+8];
    wire    [REG_WIDTH-1:0]                    newVal_in  = tuple_in_@EXTERN_NAME@_input_DATA[REG_WIDTH+7 : 8];
    wire    [OP_WIDTH-1:0]                     opCode_in  = tuple_in_@EXTERN_NAME@_input_DATA[7:0];

    // final registers
    reg  valid_final_r;
    reg [INDEX_WIDTH-1:0]  index_final_r;

    localparam REG_DEPTH = 2**INDEX_WIDTH;

    // registers to hold statefulness
    integer             i;
//    reg     [REG_WIDTH-1:0]      @PREFIX_NAME@_r[REG_DEPTH-1:0];
    reg     [REG_WIDTH-1:0] internal_reg;

    // control signals
    // CPU reads IP interface
    wire      [C_S_AXI_DATA_WIDTH-1:0]         ip2cpu_@PREFIX_NAME@_reg_data;
    reg       [REG_WIDTH-1:0]                  ip2cpu_@PREFIX_NAME@_reg_data_adj;
    reg       [INDEX_WIDTH-1:0]                ip2cpu_@PREFIX_NAME@_reg_index;
    reg                                        ip2cpu_@PREFIX_NAME@_reg_valid;
    wire      [INDEX_WIDTH-1:0]             ipReadReq_@PREFIX_NAME@_reg_index;
    wire                                    ipReadReq_@PREFIX_NAME@_reg_valid;

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
    //wire    [INDEX_WIDTH-1:0]               index_end;
    //wire    [REG_WIDTH-1:0]                   newVal_end;
    //wire    [OP_WIDTH-1:0]                  opCode_end;

    // create pipeline registers if required
    generate 
    if (NUM_CYCLES > 1) begin: PIPELINE 
        reg [NUM_CYCLES-2:0]          statefulValid_pipe_r;
        reg [NUM_CYCLES-2:0]          valid_pipe_r;
        //reg [INDEX_WIDTH-1:0]         index_pipe_r[NUM_CYCLES-2:0];
        //reg [REG_WIDTH-1:0]           newVal_pipe_r[NUM_CYCLES-2:0];
        //reg [OP_WIDTH-1:0]            opCode_pipe_r[NUM_CYCLES-2:0];

        integer j;
        integer k;
    
        // Make pipeline stages to help with timing
        always @ (posedge clk_lookup) begin
            if(~resetn_sync | cpu2ip_@PREFIX_NAME@_reg_reset) begin
                for (j=0; j < NUM_CYCLES-1; j=j+1) begin
                    statefulValid_pipe_r[j] <= 'd0;
                    valid_pipe_r[j] <= 'd0;
                    //index_pipe_r[j] <= 'd0;
                    //newVal_pipe_r[j] <= 'd0;
                    //opCode_pipe_r[j] <= 'd0;
                end
            end
            else begin
                for (k=0; k < NUM_CYCLES-1; k=k+1) begin
                    if (k == 0) begin
                        statefulValid_pipe_r[k] <= statefulValid_in;
                        valid_pipe_r[k] <= valid_in;
                        //index_pipe_r[k] <= index_in;
                        //newVal_pipe_r[k] <= newVal_in;
                        //opCode_pipe_r[k] <= opCode_in;
                    end
                    else begin
                        statefulValid_pipe_r[k] <= statefulValid_pipe_r[k-1];
                        valid_pipe_r[k] <= valid_pipe_r[k-1];
                        //index_pipe_r[k] <= index_pipe_r[k-1];
                        //newVal_pipe_r[k] <= newVal_pipe_r[k-1];
                        //opCode_pipe_r[k] <= opCode_pipe_r[k-1];
                    end
                end
            end
        end

        assign statefulValid_end = statefulValid_pipe_r[NUM_CYCLES-2];
        assign valid_end = valid_pipe_r[NUM_CYCLES-2];
        //assign index_end = index_pipe_r[NUM_CYCLES-2];
        //assign newVal_end = newVal_pipe_r[NUM_CYCLES-2];
        //assign opCode_end = opCode_pipe_r[NUM_CYCLES-2];

    end
    else begin: NO_PIPELINE
        assign statefulValid_end = statefulValid_in;
        assign valid_end = valid_in;
        //assign index_end = index_in;
        //assign newVal_end = newVal_in;
        //assign opCode_end = opCode_in;
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
      .ip2cpu_@PREFIX_NAME@_reg_data              (ip2cpu_@PREFIX_NAME@_reg_data),
      .ip2cpu_@PREFIX_NAME@_reg_index             (ip2cpu_@PREFIX_NAME@_reg_index),
      .ip2cpu_@PREFIX_NAME@_reg_valid             (ip2cpu_@PREFIX_NAME@_reg_valid),
      .ipReadReq_@PREFIX_NAME@_reg_index       (ipReadReq_@PREFIX_NAME@_reg_index),
      .ipReadReq_@PREFIX_NAME@_reg_valid       (ipReadReq_@PREFIX_NAME@_reg_valid),
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

    
    // drive the registers
    always @(posedge clk_lookup)
    begin
        if (~resetn_sync | cpu2ip_@PREFIX_NAME@_reg_reset) begin
            valid_final_r <= 'd0;
            internal_reg    <= `REG_@PREFIX_NAME@_DEFAULT;
        end
        else begin
            valid_final_r <= valid_end;

            if (cpu2ip_@PREFIX_NAME@_reg_valid) begin
                internal_reg <= cpu2ip_@PREFIX_NAME@_reg_data_adj;
            end
            else begin

		// ******************************************
		//     -: Increment internal_reg
		// ******************************************
               	internal_reg  <= internal_reg + 1;

            end

        end //else
    end //always

    // Read the new value from the register
    wire [REG_WIDTH-1:0] result_out = internal_reg;

    assign tuple_out_@EXTERN_NAME@_output_VALID = valid_final_r;
    assign tuple_out_@EXTERN_NAME@_output_DATA  = {result_out};

    // control path output
    always @(*) begin
        if (ipReadReq_@PREFIX_NAME@_reg_valid) begin
            ip2cpu_@PREFIX_NAME@_reg_data_adj = internal_reg;
            ip2cpu_@PREFIX_NAME@_reg_index = ipReadReq_@PREFIX_NAME@_reg_index;
            ip2cpu_@PREFIX_NAME@_reg_valid = 'b1;
        end
        else begin
            ip2cpu_@PREFIX_NAME@_reg_data_adj = internal_reg;
            ip2cpu_@PREFIX_NAME@_reg_index = 'd0;
            ip2cpu_@PREFIX_NAME@_reg_valid = 'b0;
        end
    end

endmodule

