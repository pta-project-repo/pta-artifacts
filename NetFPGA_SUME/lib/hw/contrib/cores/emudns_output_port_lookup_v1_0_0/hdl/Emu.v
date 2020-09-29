//
//// This software was developed by
//// Stanford University and the University of Cambridge Computer Laboratory
//// under National Science Foundation under Grant No. CNS-0855268,
//// the University of Cambridge Computer Laboratory under EPSRC INTERNET
//Project EP/H040536/1 and
//// by the University of Cambridge Computer Laboratory under DARPA/AFRL
//contract FA8750-11-C-0249 ("MRC2"), 
//// as part of the DARPA MRC research programme.
////
//// @NETFPGA_LICENSE_HEADER_START@
////
//// Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
//// license agreements.  See the NOTICE file distributed with this work for
//// additional information regarding copyright ownership.  NetFPGA licenses
//this
//// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
//// "License"); you may not use this file except in compliance with the
//// License.  You may obtain a copy of the License at:
////
////   http://www.netfpga-cic.org
////
//// Unless required by applicable law or agreed to in writing, Work
//distributed
//// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
//OR
//// CONDITIONS OF ANY KIND, either express or implied.  See the License for
//the
//// specific language governing permissions and limitations under the
//License.
////
//// @NETFPGA_LICENSE_HEADER_END@
////

// CBG Orangepath HPR L/S System

// Verilog output file generated at 20/09/2018 09:53:02
// Kiwi Scientific Acceleration (KiwiC .net/CIL/C# to Verilog/SystemC compiler): Version Alpha 0.3.1x : 11th-May-2017 Unix 3.19.0.65
//  /root/kiwi/kiwipro/kiwic/distro/lib/kiwic.exe emu_DNS_server.dll -bevelab-default-pause-mode=hard -vnl-resets=synchronous -vnl-roundtrip=disable -res2-loadstore-port-count=0 -restructure2=disable -conerefine=enable -compose=disable -vnl emu_DNS_server.v
`timescale 1ns/1ns


module Emu(    output reg [63:0] m_axis_tuser_low,
    output reg [63:0] m_axis_tuser_hi,
    input m_axis_tready,
    output reg m_axis_tlast,
    output reg [7:0] m_axis_tkeep,
    output reg [63:0] m_axis_tdata,
    input [63:0] s_axis_tuser_low,
    input [63:0] s_axis_tuser_hi,
    input s_axis_tvalid,
    input s_axis_tlast,
    input [7:0] s_axis_tkeep,
    input [63:0] s_axis_tdata,
    output reg [31:0] debug_reg,
    output reg m_axis_tvalid,
    output reg s_axis_tready,
    
/* portgroup=net batch2 abstractionName=nokind */input clk,
    
/* portgroup=directorate abstractionName=nokind */input reset);

function  rtl_unsigned_bitextract7;
   input [31:0] arg;
   rtl_unsigned_bitextract7 = $unsigned(arg[0:0]);
   endfunction


function [7:0] rtl_unsigned_bitextract4;
   input [31:0] arg;
   rtl_unsigned_bitextract4 = $unsigned(arg[7:0]);
   endfunction


function  rtl_unsigned_bitextract1;
   input [31:0] arg;
   rtl_unsigned_bitextract1 = $unsigned(arg[0:0]);
   endfunction


function [31:0] rtl_unsigned_bitextract0;
   input [63:0] arg;
   rtl_unsigned_bitextract0 = $unsigned(arg[31:0]);
   endfunction


function signed [31:0] rtl_sign_extend5;
   input [7:0] arg;
   rtl_sign_extend5 = { {24{arg[7]}}, arg[7:0] };
   endfunction


function signed [31:0] rtl_sign_extend2;
   input argbit;
   rtl_sign_extend2 = { {32{argbit}} };
   endfunction


function [31:0] rtl_unsigned_extend6;
   input [7:0] arg;
   rtl_unsigned_extend6 = { 24'b0, arg[7:0] };
   endfunction


function [63:0] rtl_unsigned_extend3;
   input [31:0] arg;
   rtl_unsigned_extend3 = { 32'b0, arg[31:0] };
   endfunction

//
  reg [31:0] T403_Emu_SendFrame_34_3_V_1;
  reg [31:0] T403_Emu_SendFrame_34_3_V_0;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_20_V_7;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_20_V_5;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_20_V_4;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_17_V_7;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_17_V_5;
  reg [63:0] T403_Emu_calc_UDP_checksum_33_17_V_4;
  reg [63:0] T403_Emu_calc_UDP_checksum_31_5_V_7;
  reg [63:0] T403_Emu_calc_UDP_checksum_31_5_V_5;
  reg [63:0] T403_Emu_calc_UDP_checksum_31_5_V_4;
  reg [63:0] T403_Emu_calc_IP_checksum_27_14_V_12;
  reg [63:0] T403_Emu_calc_IP_checksum_27_14_V_7;
  reg [63:0] T403_Emu_calc_IP_checksum_27_14_V_6;
  reg [63:0] T403_Emu_calc_IP_checksum_27_14_V_1;
  reg [7:0] T403_Emu_calc_IP_checksum_27_14_V_0;
  reg [63:0] T403_Emu_calc_IP_checksum_27_14_SPILL_256;
  reg T403_Emu_swap_multiple_fields_9_10_V_2;
  reg T403_Emu_swap_multiple_fields_9_10_V_1;
  reg [63:0] T403_Emu_swap_multiple_fields_9_10_V_0;
  reg [63:0] T403_Emu_calc_IP_checksum_6_0_V_12;
  reg [63:0] T403_Emu_calc_IP_checksum_6_0_V_7;
  reg [63:0] T403_Emu_calc_IP_checksum_6_0_V_6;
  reg [63:0] T403_Emu_calc_IP_checksum_6_0_V_1;
  reg [7:0] T403_Emu_calc_IP_checksum_6_0_V_0;
  reg [63:0] T403_Emu_calc_IP_checksum_6_0_SPILL_256;
  integer T403_Emu_Extract_headers_2_9_SPILL_256;
  reg [7:0] T403_Emu_ReceiveFrame_1_1_V_7;
  reg [63:0] T403_Emu_ReceiveFrame_1_1_V_6;
  reg [63:0] T403_Emu_ReceiveFrame_1_1_V_5;
  reg T403_Emu_ReceiveFrame_1_1_V_3;
  reg [31:0] T403_Emu_ReceiveFrame_1_1_V_1;
  reg [31:0] T403_Emu_ReceiveFrame_1_1_V_0;
  integer T403_Emu_ReceiveFrame_1_1_SPILL_258;
  integer T403_Emu_ReceiveFrame_1_1_SPILL_257;
  reg T403_Emu_DNS_logic_1_1_V_11;
  reg T403_Emu_DNS_logic_1_1_V_10;
  reg T403_Emu_DNS_logic_1_1_V_9;
  reg [31:0] T403_Emu_DNS_logic_1_1_V_8;
  reg [31:0] T403_Emu_DNS_logic_1_1_V_7;
  reg [31:0] T403_Emu_DNS_logic_1_1_V_3;
  reg [31:0] T403_Emu_DNS_logic_1_1_V_2;
  reg [63:0] T403_Emu_DNS_logic_1_1_SPILL_256;
  reg [63:0] Emu_tmp5;
  reg [63:0] Emu_tmp4;
  reg [63:0] Emu_tmp1;
  reg [63:0] Emu_tmp2;
  reg [63:0] Emu_tmp3;
  reg [63:0] Emu_tmp;
  reg Emu_start_parsing;
  reg Emu_one_question;
  reg Emu_std_query;
  reg [63:0] Emu_app_dst_port;
  reg [63:0] Emu_app_src_port;
  reg [63:0] Emu_UDP_total_length;
  reg [63:0] Emu_IP_total_length;
  reg [63:0] Emu_dst_ip;
  reg [63:0] Emu_src_ip;
  reg [63:0] Emu_src_port;
  reg [63:0] Emu_src_mac;
  reg [63:0] Emu_dst_mac;
  reg [63:0] Emu_chksumIP;
  reg [63:0] Emu_chksum_UDP;
  reg Emu_exist_rest;
  reg [7:0] Emu_last_tkeep;
  reg Emu_proto_ICMP;
  reg Emu_proto_UDP;
  reg Emu_IPv4;
//
  reg [63:0] A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[79:0];
  reg [63:0] A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[79:0];
  reg [63:0] A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[6:0];
  reg [63:0] A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[6:0];
  reg [63:0] A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[6:0];
  reg [31:0] A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[6:0];
  reg [7:0] A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[79:0];
//
  reg [5:0] bevelab10;
//share-nets
  wire [63:0] hprpin501503x10;
  wire [63:0] hprpin501507x10;
  wire [63:0] hprpin501517x10;
  wire [63:0] hprpin501679x10;
  wire [63:0] hprpin501683x10;
  wire [63:0] hprpin501693x10;
  wire [63:0] hprpin501747x10;
  wire [63:0] hprpin501751x10;
  wire [63:0] hprpin501761x10;
  wire [63:0] hprpin501768x10;
  wire [63:0] hprpin501772x10;
  wire [63:0] hprpin502226x10;
 always   @(posedge clk )  begin 
      //Start structure HPR anontop/1.0
      if (reset)  begin 
               debug_reg <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd6] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd5] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd4] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd3] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd2] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd1] <= 32'd0;
               A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd0] <= 32'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd6] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd5] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd4] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd3] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd2] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd1] <= 64'd0;
               A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd0] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd6] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd5] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd4] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd3] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd2] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd1] <= 64'd0;
               A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd0] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd6] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd5] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd4] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd3] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd2] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd1] <= 64'd0;
               A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd0] <= 64'd0;
               A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[32'h0] <= 64'd0;
               A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[32'h0] <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[32'h0] <= 64'd0;
               T403_Emu_ReceiveFrame_1_1_SPILL_258 <= 32'd0;
               T403_Emu_ReceiveFrame_1_1_V_3 <= 32'd0;
               T403_Emu_ReceiveFrame_1_1_SPILL_257 <= 32'd0;
               T403_Emu_ReceiveFrame_1_1_V_1 <= 32'd0;
               A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[T403_Emu_ReceiveFrame_1_1_V_0] <= 64'd0;
               A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_ReceiveFrame_1_1_V_0] <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_0] <= 64'd0;
               T403_Emu_ReceiveFrame_1_1_V_7 <= 32'd0;
               T403_Emu_ReceiveFrame_1_1_V_5 <= 64'd0;
               Emu_last_tkeep <= 32'd0;
               T403_Emu_ReceiveFrame_1_1_V_6 <= 64'd0;
               T403_Emu_ReceiveFrame_1_1_V_0 <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_1] <= 64'd0;
               T403_Emu_Extract_headers_2_9_SPILL_256 <= 32'd0;
               Emu_src_port <= 64'd0;
               Emu_src_mac <= 64'd0;
               Emu_dst_mac <= 64'd0;
               Emu_dst_ip <= 64'd0;
               Emu_src_ip <= 64'd0;
               Emu_app_dst_port <= 64'd0;
               Emu_app_src_port <= 64'd0;
               T403_Emu_DNS_logic_1_1_V_11 <= 32'd0;
               T403_Emu_DNS_logic_1_1_V_10 <= 32'd0;
               T403_Emu_DNS_logic_1_1_V_9 <= 32'd0;
               T403_Emu_calc_IP_checksum_6_0_V_7 <= 64'd0;
               T403_Emu_calc_IP_checksum_6_0_V_6 <= 64'd0;
               T403_Emu_calc_IP_checksum_6_0_V_1 <= 64'd0;
               T403_Emu_calc_IP_checksum_6_0_SPILL_256 <= 64'd0;
               T403_Emu_swap_multiple_fields_9_10_V_2 <= 32'd0;
               T403_Emu_swap_multiple_fields_9_10_V_1 <= 32'd0;
               T403_Emu_calc_IP_checksum_6_0_V_12 <= 64'd0;
               T403_Emu_calc_IP_checksum_6_0_V_0 <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd0] <= 64'd0;
               T403_Emu_SendFrame_34_3_V_1 <= 32'd0;
               T403_Emu_SendFrame_34_3_V_0 <= 32'd0;
               s_axis_tready <= 32'd0;
               m_axis_tuser_low <= 64'd0;
               m_axis_tuser_hi <= 64'd0;
               m_axis_tvalid <= 32'd0;
               m_axis_tlast <= 32'd0;
               m_axis_tkeep <= 32'd0;
               m_axis_tdata <= 64'd0;
               Emu_proto_ICMP <= 32'd0;
               Emu_proto_UDP <= 32'd0;
               Emu_IPv4 <= 32'd0;
               Emu_start_parsing <= 32'd0;
               Emu_std_query <= 32'd0;
               Emu_one_question <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1] <= 64'd0;
               T403_Emu_swap_multiple_fields_9_10_V_0 <= 64'd0;
               Emu_tmp4 <= 64'd0;
               Emu_tmp5 <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_V_7 <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_V_6 <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_V_1 <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_SPILL_256 <= 64'd0;
               Emu_chksumIP <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_V_12 <= 64'd0;
               T403_Emu_calc_IP_checksum_27_14_V_0 <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3] <= 64'd0;
               T403_Emu_calc_UDP_checksum_31_5_V_5 <= 64'd0;
               T403_Emu_calc_UDP_checksum_31_5_V_4 <= 64'd0;
               T403_Emu_calc_UDP_checksum_31_5_V_7 <= 64'd0;
               T403_Emu_DNS_logic_1_1_SPILL_256 <= 64'd0;
               T403_Emu_DNS_logic_1_1_V_2 <= 32'd0;
               T403_Emu_calc_UDP_checksum_33_17_V_5 <= 64'd0;
               T403_Emu_calc_UDP_checksum_33_17_V_4 <= 64'd0;
               T403_Emu_calc_UDP_checksum_33_17_V_7 <= 64'd0;
               T403_Emu_calc_UDP_checksum_33_20_V_5 <= 64'd0;
               T403_Emu_calc_UDP_checksum_33_20_V_4 <= 64'd0;
               T403_Emu_calc_UDP_checksum_33_20_V_7 <= 64'd0;
               Emu_chksum_UDP <= 64'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5] <= 64'd0;
               Emu_tmp1 <= 64'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd6] <= 64'd0;
               Emu_tmp3 <= 64'd0;
               A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_DNS_logic_1_1_V_7] <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_DNS_logic_1_1_V_7] <= 64'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= 64'd0;
               Emu_IP_total_length <= 64'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd2] <= 64'd0;
               T403_Emu_DNS_logic_1_1_V_7 <= 32'd0;
               Emu_UDP_total_length <= 64'd0;
               A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0] <= 64'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4] <= 64'd0;
               A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= 32'd0;
               A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= 64'd0;
               Emu_tmp2 <= 64'd0;
               A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= 32'd0;
               bevelab10 <= 32'd0;
               Emu_tmp <= 64'd0;
               T403_Emu_DNS_logic_1_1_V_8 <= 32'd0;
               T403_Emu_DNS_logic_1_1_V_3 <= 32'd0;
               Emu_exist_rest <= 32'd0;
               end 
               else 
          case (bevelab10)
              32'h32/*50:bevelab10*/:  begin 
                   bevelab10 <= 32'h16/*22:bevelab10*/;
                   Emu_tmp <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5];
                   T403_Emu_DNS_logic_1_1_V_8 <= rtl_unsigned_bitextract0(64'sh_ffff&A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0
                  [64'd0]);

                   T403_Emu_DNS_logic_1_1_V_3 <= T403_Emu_DNS_logic_1_1_V_2;
                   Emu_exist_rest <= rtl_unsigned_bitextract1(((Emu_tmp2==Emu_tmp4)? rtl_sign_extend2((Emu_tmp3==Emu_tmp5)): 1'd0));
                   end 
                  
              32'h31/*49:bevelab10*/:  begin 
                   bevelab10 <= 32'h2e/*46:bevelab10*/;
                   Emu_tmp2 <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd2];
                   Emu_tmp <= (Emu_IP_total_length>>32'sd8)|((64'shff&Emu_IP_total_length)<<32'sd8);
                   A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= 8'hff;
                   end 
                  
              32'h30/*48:bevelab10*/:  begin 
                   bevelab10 <= 32'h31/*49:bevelab10*/;
                   A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= 8'hff;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= Emu_tmp2;
                   end 
                  
              32'h2f/*47:bevelab10*/:  begin 
                   bevelab10 <= 32'h19/*25:bevelab10*/;
                   Emu_tmp <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3];
                   T403_Emu_DNS_logic_1_1_V_7 <= $unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7);
                   Emu_UDP_total_length <= 64'sh10+Emu_tmp;
                   A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0] <= rtl_unsigned_extend3(rtl_unsigned_extend3(32'sd16
                  )+rtl_unsigned_extend3(T403_Emu_DNS_logic_1_1_V_8))|(Emu_src_port<<32'sd24)|(Emu_src_port<<32'sd16);

                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4] <= Emu_tmp2|(((64'sh10+Emu_tmp>>32'sd8)|((64'shff&64'sh10+Emu_tmp
                  )<<32'sd8))<<32'sd48);

                   end 
                  
              32'h2e/*46:bevelab10*/:  begin 
                   bevelab10 <= 32'h2f/*47:bevelab10*/;
                   Emu_tmp2 <= 64'sh_ffff_ffff_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4];
                   Emu_tmp <= (Emu_UDP_total_length>>32'sd8)|((64'shff&Emu_UDP_total_length)<<32'sd8);
                   Emu_IP_total_length <= 64'sh10+Emu_tmp;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd2] <= Emu_tmp2|(64'sh10+Emu_tmp>>32'sd8)|((64'shff&64'sh10+Emu_tmp)<<
                  32'sd8);

                   end 
                  
              32'h2d/*45:bevelab10*/:  begin 
                   bevelab10 <= 32'h2e/*46:bevelab10*/;
                   Emu_tmp2 <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd2];
                   Emu_tmp <= (Emu_IP_total_length>>32'sd8)|((64'shff&Emu_IP_total_length)<<32'sd8);
                   end 
                  
              32'h2c/*44:bevelab10*/:  begin 
                   bevelab10 <= 32'h2d/*45:bevelab10*/;
                   A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= rtl_unsigned_bitextract4((32'sd255
                  >>(32'sd31&32'sd8+(0-Emu_last_tkeep))));

                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'sd2+T403_Emu_DNS_logic_1_1_V_7)] <= (Emu_tmp2>>(32'sd63&32'sd8
                  *(32'sd8+(0-Emu_last_tkeep))));

                   end 
                  
              32'h2b/*43:bevelab10*/:  begin 
                   bevelab10 <= 32'h2c/*44:bevelab10*/;
                   A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= 8'hff;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= (64'h100_0100_0cc0>>(32'sd63
                  &32'sd8*(32'sd8+(0-Emu_last_tkeep))))|(Emu_tmp2<<(32'sd63&32'sd8*rtl_sign_extend5(Emu_last_tkeep)));

                   end 
                  
              32'h2a/*42:bevelab10*/:  begin 
                   bevelab10 <= 32'h2b/*43:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_DNS_logic_1_1_V_7] <= Emu_tmp3;
                   end 
                  
              32'h29/*41:bevelab10*/: if (!(!Emu_last_tkeep))  begin 
                       bevelab10 <= 32'h2a/*42:bevelab10*/;
                       Emu_tmp3 <= A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_DNS_logic_1_1_V_7]|(64'h100_0100_0cc0<<(32'sd63
                      &32'sd8*rtl_sign_extend5(Emu_last_tkeep)));

                       A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_DNS_logic_1_1_V_7] <= 8'hff;
                       end 
                       else  begin 
                       bevelab10 <= 32'h30/*48:bevelab10*/;
                       A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_7)] <= 64'h100_0100_0cc0;
                       end 
                      
              32'h28/*40:bevelab10*/:  begin 
                   bevelab10 <= 32'h29/*41:bevelab10*/;
                   Emu_tmp2 <= 64'sh400_100e|(rtl_unsigned_extend3(A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[T403_Emu_DNS_logic_1_1_V_3])<<
                  32'sd32);

                   Emu_tmp1 <= 64'h100_0100_0cc0;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd6] <= 64'sh100|Emu_tmp;
                   end 
                  
              32'h27/*39:bevelab10*/:  begin 
                   bevelab10 <= 32'h9/*9:bevelab10*/;
                   Emu_tmp3 <= ((64'shff&Emu_tmp2)<<32'sd8)|(Emu_tmp2>>32'sd8);
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5] <= Emu_tmp|((64'shff&Emu_tmp2)<<32'sd8)|(Emu_tmp2>>32'sd8);
                   end 
                  
              32'h26/*38:bevelab10*/:  begin 
                   bevelab10 <= 32'h27/*39:bevelab10*/;
                   Emu_tmp2 <= 64'sh_ffff&-64'sh1^Emu_chksum_UDP;
                   end 
                  
              32'h25/*37:bevelab10*/:  begin 
                   bevelab10 <= 32'h26/*38:bevelab10*/;
                   Emu_chksum_UDP <= (64'sh_ffff&T403_Emu_calc_UDP_checksum_33_20_V_7+(64'sh_ffff&T403_Emu_calc_UDP_checksum_33_20_V_4
                  +T403_Emu_calc_UDP_checksum_33_20_V_5)+(T403_Emu_calc_UDP_checksum_33_20_V_4+T403_Emu_calc_UDP_checksum_33_20_V_5>>
                  32'sd16))+(T403_Emu_calc_UDP_checksum_33_20_V_7+(64'sh_ffff&T403_Emu_calc_UDP_checksum_33_20_V_4+T403_Emu_calc_UDP_checksum_33_20_V_5
                  )+(T403_Emu_calc_UDP_checksum_33_20_V_4+T403_Emu_calc_UDP_checksum_33_20_V_5>>32'sd16)>>32'sd16);

                   end 
                  
              32'h24/*36:bevelab10*/:  begin 
                   bevelab10 <= 32'h25/*37:bevelab10*/;
                   T403_Emu_calc_UDP_checksum_33_20_V_5 <= (64'sh_ffff&hprpin501751x10)+(hprpin501751x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_33_20_V_4 <= (64'sh_ffff&hprpin501747x10)+(hprpin501747x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_33_20_V_7 <= Emu_chksum_UDP;
                   end 
                  
              32'h23/*35:bevelab10*/:  begin 
                   bevelab10 <= 32'h24/*36:bevelab10*/;
                   Emu_chksum_UDP <= (64'sh_ffff&T403_Emu_calc_UDP_checksum_33_17_V_7+(64'sh_ffff&T403_Emu_calc_UDP_checksum_33_17_V_4
                  +T403_Emu_calc_UDP_checksum_33_17_V_5)+(T403_Emu_calc_UDP_checksum_33_17_V_4+T403_Emu_calc_UDP_checksum_33_17_V_5>>
                  32'sd16))+(T403_Emu_calc_UDP_checksum_33_17_V_7+(64'sh_ffff&T403_Emu_calc_UDP_checksum_33_17_V_4+T403_Emu_calc_UDP_checksum_33_17_V_5
                  )+(T403_Emu_calc_UDP_checksum_33_17_V_4+T403_Emu_calc_UDP_checksum_33_17_V_5>>32'sd16)>>32'sd16);

                   end 
                  
              32'h22/*34:bevelab10*/:  begin 
                   bevelab10 <= 32'h23/*35:bevelab10*/;
                   T403_Emu_calc_UDP_checksum_33_17_V_5 <= (64'sh_ffff&hprpin501772x10)+(hprpin501772x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_33_17_V_4 <= (64'sh_ffff&hprpin501768x10)+(hprpin501768x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_33_17_V_7 <= Emu_chksum_UDP;
                   end 
                  
              32'h21/*33:bevelab10*/: if ((T403_Emu_DNS_logic_1_1_V_7<$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                       bevelab10 <= 32'h22/*34:bevelab10*/;
                       Emu_tmp2 <= Emu_dst_ip|(Emu_src_ip<<32'sd32);
                       Emu_tmp3 <= 64'sh_1100|-64'sh1_0000_0000_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4];
                       T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                       Emu_chksum_UDP <= hprpin501761x10;
                       end 
                       else  begin 
                       bevelab10 <= 32'h20/*32:bevelab10*/;
                       Emu_tmp2 <= $unsigned(((T403_Emu_DNS_logic_1_1_V_7<$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))? T403_Emu_DNS_logic_1_1_SPILL_256
                      : hprpin502226x10));

                       T403_Emu_DNS_logic_1_1_SPILL_256 <= hprpin502226x10;
                       T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                       Emu_chksum_UDP <= hprpin501761x10;
                       end 
                      
              32'h20/*32:bevelab10*/:  begin 
                   bevelab10 <= 32'h21/*33:bevelab10*/;
                   T403_Emu_calc_UDP_checksum_31_5_V_5 <= (64'sh_ffff&hprpin501751x10)+(hprpin501751x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_31_5_V_4 <= (64'sh_ffff&hprpin501747x10)+(hprpin501747x10>>32'sd16);
                   T403_Emu_calc_UDP_checksum_31_5_V_7 <= Emu_chksum_UDP;
                   end 
                  
              32'h1f/*31:bevelab10*/: if ((T403_Emu_DNS_logic_1_1_V_7<32'h4))  begin 
                       bevelab10 <= 32'h22/*34:bevelab10*/;
                       Emu_tmp2 <= Emu_dst_ip|(Emu_src_ip<<32'sd32);
                       Emu_tmp3 <= 64'sh_1100|-64'sh1_0000_0000_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4];
                       T403_Emu_DNS_logic_1_1_V_2 <= 32'h4;
                       end 
                       else  begin 
                       bevelab10 <= 32'h20/*32:bevelab10*/;
                       Emu_tmp2 <= $unsigned((A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[32'h4]>>32'sd16));
                       T403_Emu_DNS_logic_1_1_SPILL_256 <= (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[32'h4]>>32'sd16);
                       T403_Emu_DNS_logic_1_1_V_2 <= 32'h4;
                       end 
                      
              32'h1e/*30:bevelab10*/:  begin 
                   bevelab10 <= 32'h1f/*31:bevelab10*/;
                   Emu_tmp <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5]);
                   end 
                  
              32'h1d/*29:bevelab10*/:  begin 
                   bevelab10 <= 32'h1e/*30:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3] <= Emu_tmp|(Emu_chksumIP>>32'sd8)|((64'shff&Emu_chksumIP)<<32'sd8
                  );

                   end 
                  
              32'h1c/*28:bevelab10*/:  begin 
                  if ((32'h3/*3:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))) || 
                  (32'h2/*2:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))))  begin 
                          if ((32'h3/*3:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) || (32'h2/*2:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))))  begin 
                                   T403_Emu_calc_IP_checksum_27_14_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  ));

                                   T403_Emu_calc_IP_checksum_27_14_V_12 <= hprpin501693x10;
                                   end 
                                   bevelab10 <= 32'h1b/*27:bevelab10*/;
                           T403_Emu_calc_IP_checksum_27_14_V_1 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[((32'h3/*3:USA68*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))) || (32'h2/*2:USA68*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))? rtl_unsigned_bitextract4(32'd1
                          +rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)): T403_Emu_calc_IP_checksum_27_14_V_0)]);

                           T403_Emu_calc_IP_checksum_27_14_SPILL_256 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[((32'h3/*3:USA68*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))) || (32'h2/*2:USA68*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))? rtl_unsigned_bitextract4(32'd1
                          +rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)): T403_Emu_calc_IP_checksum_27_14_V_0)]);

                           end 
                          if (((32'h1/*1:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                  )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))<32'sd5
                  ) && (32'h2/*2:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))) && 
                  (32'h3/*3:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))) && (32'h4
                  /*4:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))) || (32'h4/*4:USA68*/==
                  rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0))))  begin 
                          if (((32'h1/*1:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))<32'sd5) && (32'h2/*2:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h3/*3:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h4/*4:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))) || (32'h4/*4:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))))  begin 
                                   T403_Emu_calc_IP_checksum_27_14_SPILL_256 <= (($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  )))<32'sd5) && (32'h1/*1:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  ))) && (32'h4/*4:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  ))) && (32'h2/*2:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  ))) && (32'h3/*3:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  )))? 64'h0: ((32'h4/*4:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  )))? (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4]<<32'sd48): (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                                  [64'd1]>>32'sd48)));

                                   T403_Emu_calc_IP_checksum_27_14_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                                  ));

                                   T403_Emu_calc_IP_checksum_27_14_V_12 <= hprpin501693x10;
                                   end 
                                   bevelab10 <= 32'h1b/*27:bevelab10*/;
                           T403_Emu_calc_IP_checksum_27_14_V_1 <= $unsigned((((32'h1/*1:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))<32'sd5) && (32'h2/*2:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h3/*3:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h4/*4:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))) || (32'h4/*4:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))? (($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))<32'sd5
                          ) && (32'h1/*1:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h4/*4:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h2/*2:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ))) && (32'h3/*3:USA68*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))? 64'h0: ((32'h4/*4:USA68*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          )))? (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4]<<32'sd48): (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                          [64'd1]>>32'sd48))): T403_Emu_calc_IP_checksum_27_14_SPILL_256));

                           end 
                          if (($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0)))>=32'sd5
                  ))  begin 
                           bevelab10 <= 32'h1d/*29:bevelab10*/;
                           Emu_chksumIP <= $unsigned(64'sh_ffff&-64'sh1^hprpin501693x10);
                           T403_Emu_calc_IP_checksum_27_14_V_12 <= 64'sh_ffff&-64'sh1^hprpin501693x10;
                           T403_Emu_calc_IP_checksum_27_14_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_27_14_V_0
                          ));

                           end 
                           end 
                  
              32'h1b/*27:bevelab10*/:  begin 
                   bevelab10 <= 32'h1c/*28:bevelab10*/;
                   T403_Emu_calc_IP_checksum_27_14_V_7 <= (64'sh_ffff&hprpin501683x10)+(hprpin501683x10>>32'sd16);
                   T403_Emu_calc_IP_checksum_27_14_V_6 <= (64'sh_ffff&hprpin501679x10)+(hprpin501679x10>>32'sd16);
                   end 
                  
              32'h1a/*26:bevelab10*/:  begin 
                   bevelab10 <= 32'h1b/*27:bevelab10*/;
                   T403_Emu_calc_IP_checksum_27_14_V_1 <= $unsigned((A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1]>>32'sd48));
                   T403_Emu_calc_IP_checksum_27_14_SPILL_256 <= (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1]>>32'sd48);
                   T403_Emu_calc_IP_checksum_27_14_V_0 <= 8'h1;
                   T403_Emu_calc_IP_checksum_27_14_V_12 <= 64'h0;
                   T403_Emu_calc_IP_checksum_27_14_V_7 <= 64'h0;
                   T403_Emu_calc_IP_checksum_27_14_V_6 <= 64'h0;
                   end 
                  
              32'h19/*25:bevelab10*/:  begin 
                   bevelab10 <= 32'h1a/*26:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3] <= Emu_tmp;
                   end 
                  
              32'h18/*24:bevelab10*/:  begin 
                   bevelab10 <= 32'h19/*25:bevelab10*/;
                   Emu_tmp <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3];
                   A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0] <= Emu_tmp5|(Emu_src_port<<32'sd24);
                   end 
                  
              32'h17/*23:bevelab10*/:  begin 
                  if ((Emu_start_parsing? !Emu_exist_rest: 1'd1))  begin 
                           bevelab10 <= 32'h18/*24:bevelab10*/;
                           Emu_tmp5 <= $unsigned(A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0]);
                           A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5] <= 64'sh380_0000_0000|Emu_tmp;
                           end 
                          if (Emu_start_parsing && Emu_exist_rest)  begin 
                           bevelab10 <= 32'h28/*40:bevelab10*/;
                           Emu_tmp <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd6];
                           end 
                           end 
                  
              32'h16/*22:bevelab10*/:  begin 
                   bevelab10 <= 32'h17/*23:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5] <= 64'sh80_0000_0000|Emu_tmp;
                   end 
                  
              32'h15/*21:bevelab10*/:  begin 
                  if (((Emu_tmp==Emu_tmp1)? (T403_Emu_DNS_logic_1_1_V_7<32'sd9): ($unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)>=32'sd7
                  )))  begin 
                          if ((Emu_tmp==Emu_tmp1) && (T403_Emu_DNS_logic_1_1_V_7<32'sd9))  begin 
                                   T403_Emu_DNS_logic_1_1_V_3 <= T403_Emu_DNS_logic_1_1_V_2;
                                   Emu_exist_rest <= (Emu_tmp2==Emu_tmp4);
                                   end 
                                  if ((Emu_tmp!=Emu_tmp1) && ($unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)>=32'sd7))  T403_Emu_DNS_logic_1_1_V_2
                               <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);

                               bevelab10 <= 32'h16/*22:bevelab10*/;
                           Emu_tmp <= -64'sh1_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd5];
                           T403_Emu_DNS_logic_1_1_V_8 <= rtl_unsigned_bitextract0(64'sh_ffff&A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0
                          [64'd0]);

                           end 
                          if ((Emu_tmp!=Emu_tmp1) && ($unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)<32'sd7))  begin 
                           Emu_tmp4 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd8]);
                           Emu_tmp3 <= $unsigned(A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )]);

                           Emu_tmp2 <= $unsigned(A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )]);

                           Emu_tmp1 <= $unsigned(A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )]);

                           T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                           end 
                          if ((Emu_tmp==Emu_tmp1) && (T403_Emu_DNS_logic_1_1_V_7>=32'sd9))  begin 
                           bevelab10 <= 32'h32/*50:bevelab10*/;
                           Emu_tmp5 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd9]);
                           end 
                           end 
                  
              32'h14/*20:bevelab10*/:  begin 
                   bevelab10 <= 32'h15/*21:bevelab10*/;
                   Emu_tmp4 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd8]);
                   Emu_tmp3 <= $unsigned(A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[32'h0]);
                   Emu_tmp2 <= $unsigned(A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[32'h0]);
                   Emu_tmp1 <= $unsigned(A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[32'h0]);
                   T403_Emu_DNS_logic_1_1_V_2 <= 32'h0;
                   T403_Emu_DNS_logic_1_1_V_3 <= 32'h7;
                   end 
                  
              32'h13/*19:bevelab10*/:  begin 
                   bevelab10 <= 32'h14/*20:bevelab10*/;
                   Emu_tmp <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd7]);
                   end 
                  
              32'h12/*18:bevelab10*/:  bevelab10 <= 32'h13/*19:bevelab10*/;

              32'h11/*17:bevelab10*/:  begin 
                   bevelab10 <= 32'h12/*18:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4] <= T403_Emu_swap_multiple_fields_9_10_V_0;
                   end 
                  
              32'h10/*16:bevelab10*/:  begin 
                  if ((T403_Emu_swap_multiple_fields_9_10_V_2? 1'd1: T403_Emu_swap_multiple_fields_9_10_V_1))  T403_Emu_swap_multiple_fields_9_10_V_0
                       <= (T403_Emu_swap_multiple_fields_9_10_V_2? -64'sh1_0000_0000_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4
                      ]|(Emu_src_ip>>32'sd16): -64'sh1_0000_0000_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4]|(Emu_src_ip>>
                      32'sd16)|(Emu_app_src_port<<32'sd32)|(Emu_app_dst_port<<32'sd16));

                       bevelab10 <= 32'h11/*17:bevelab10*/;
                   end 
                  
              32'hf/*15:bevelab10*/:  begin 
                   bevelab10 <= 32'h10/*16:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3] <= T403_Emu_swap_multiple_fields_9_10_V_0;
                   end 
                  
              32'he/*14:bevelab10*/:  begin 
                   bevelab10 <= 32'hf/*15:bevelab10*/;
                   T403_Emu_swap_multiple_fields_9_10_V_0 <= 64'sh_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd3]|(Emu_dst_ip
                  <<32'sd16)|(Emu_src_ip<<32'sd48);

                   end 
                  
              32'hd/*13:bevelab10*/:  begin 
                   bevelab10 <= 32'he/*14:bevelab10*/;
                   A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1] <= T403_Emu_swap_multiple_fields_9_10_V_0;
                   end 
                  
              32'hc/*12:bevelab10*/:  begin 
                   bevelab10 <= 32'hd/*13:bevelab10*/;
                   T403_Emu_swap_multiple_fields_9_10_V_0 <= -64'sh1_0000_0000&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1]|(Emu_dst_mac
                  >>32'sd16);

                   end 
                  
              32'hb/*11:bevelab10*/:  begin 
                   bevelab10 <= 32'h1/*1:bevelab10*/;
                   s_axis_tready <= 1'h1;
                   m_axis_tuser_low <= 64'h0;
                   m_axis_tuser_hi <= 64'h0;
                   m_axis_tvalid <= 1'h0;
                   m_axis_tlast <= 1'h0;
                   m_axis_tkeep <= 8'h0;
                   m_axis_tdata <= 64'h0;
                   Emu_exist_rest <= 1'h0;
                   T403_Emu_DNS_logic_1_1_V_7 <= 32'h0;
                   Emu_chksum_UDP <= 64'h0;
                   Emu_proto_ICMP <= 1'h0;
                   Emu_proto_UDP <= 1'h0;
                   Emu_IPv4 <= 1'h0;
                   Emu_start_parsing <= 1'h0;
                   Emu_std_query <= 1'h0;
                   Emu_one_question <= 1'h0;
                   end 
                  
              32'ha/*10:bevelab10*/: if ((T403_Emu_SendFrame_34_3_V_1<T403_Emu_SendFrame_34_3_V_0))  begin 
                       bevelab10 <= 32'hb/*11:bevelab10*/;
                       m_axis_tuser_low <= 64'h0;
                       m_axis_tuser_hi <= 64'h0;
                       m_axis_tkeep <= 8'h0;
                       m_axis_tdata <= 64'h0;
                       m_axis_tlast <= 1'h0;
                       m_axis_tvalid <= 1'h0;
                       end 
                       else if (m_axis_tready && (T403_Emu_SendFrame_34_3_V_1>=T403_Emu_SendFrame_34_3_V_0))  begin 
                           T403_Emu_SendFrame_34_3_V_0 <= $unsigned(32'd1+T403_Emu_SendFrame_34_3_V_0);
                           m_axis_tuser_low <= $unsigned(A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0]);
                           m_axis_tuser_hi <= 64'h0;
                           m_axis_tlast <= (T403_Emu_DNS_logic_1_1_V_7==T403_Emu_SendFrame_34_3_V_0);
                           m_axis_tkeep <= rtl_unsigned_bitextract4(A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_SendFrame_34_3_V_0
                          ]);

                           m_axis_tdata <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_SendFrame_34_3_V_0]);
                           end 
                          
              32'h9/*9:bevelab10*/: if ((T403_Emu_DNS_logic_1_1_V_7<32'h0))  begin 
                       bevelab10 <= 32'hb/*11:bevelab10*/;
                       m_axis_tuser_low <= 64'h0;
                       m_axis_tuser_hi <= 64'h0;
                       m_axis_tkeep <= 8'h0;
                       m_axis_tdata <= 64'h0;
                       m_axis_tlast <= 1'h0;
                       m_axis_tvalid <= 1'h0;
                       T403_Emu_SendFrame_34_3_V_1 <= T403_Emu_DNS_logic_1_1_V_7;
                       T403_Emu_SendFrame_34_3_V_0 <= 32'h0;
                       end 
                       else  begin 
                       bevelab10 <= 32'ha/*10:bevelab10*/;
                       T403_Emu_SendFrame_34_3_V_0 <= (m_axis_tready && (T403_Emu_DNS_logic_1_1_V_7>=32'h0)? 32'h1: 32'h0);
                       m_axis_tuser_low <= (m_axis_tready && (T403_Emu_DNS_logic_1_1_V_7>=32'h0)? $unsigned(A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0
                      [64'd0]): 64'h0);

                       m_axis_tuser_hi <= 64'h0;
                       m_axis_tlast <= m_axis_tready && (32'h0==T403_Emu_DNS_logic_1_1_V_7) && (T403_Emu_DNS_logic_1_1_V_7>=32'h0);
                       m_axis_tkeep <= (m_axis_tready && (T403_Emu_DNS_logic_1_1_V_7>=32'h0)? rtl_unsigned_bitextract4(A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0
                      [32'h0]): 8'h0);

                       m_axis_tdata <= (m_axis_tready && (T403_Emu_DNS_logic_1_1_V_7>=32'h0)? $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                      [32'h0]): 64'h0);

                       T403_Emu_SendFrame_34_3_V_1 <= T403_Emu_DNS_logic_1_1_V_7;
                       m_axis_tvalid <= 1'h1;
                       end 
                      
              32'h8/*8:bevelab10*/:  begin 
                  if (Emu_one_question && Emu_std_query && ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                  )))>=32'sd5) && (32'h0/*0:USA64*/==$unsigned(64'sh_ffff&-64'sh1^(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff
                  &T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7)+(T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7
                  >>32'sd16))+(T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7
                  )+(T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7>>32'sd16)>>32'sd16))))  begin 
                          if (Emu_one_question && Emu_std_query && ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))>=32'sd5) && (32'h0/*0:USA70*/==$unsigned(64'sh_ffff&-64'sh1^hprpin501517x10)))  bevelab10 <= 32'hc/*12:bevelab10*/;
                               T403_Emu_swap_multiple_fields_9_10_V_2 <= rtl_unsigned_bitextract7(T403_Emu_DNS_logic_1_1_V_11);
                           T403_Emu_swap_multiple_fields_9_10_V_1 <= rtl_unsigned_bitextract7(T403_Emu_DNS_logic_1_1_V_10);
                           Emu_exist_rest <= 1'h0;
                           Emu_chksumIP <= 64'h0;
                           Emu_chksum_UDP <= 64'h0;
                           T403_Emu_calc_IP_checksum_6_0_V_12 <= 64'sh_ffff&-64'sh1^hprpin501517x10;
                           T403_Emu_calc_IP_checksum_6_0_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ));

                           A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd0] <= Emu_src_mac|(Emu_dst_mac<<32'sd48);
                           end 
                          if ((32'h3/*3:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                  ))) || (32'h2/*2:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))) 
                   begin 
                          if ((32'h3/*3:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) || (32'h2/*2:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))))  begin 
                                   T403_Emu_calc_IP_checksum_6_0_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ));

                                   T403_Emu_calc_IP_checksum_6_0_V_12 <= hprpin501517x10;
                                   end 
                                   bevelab10 <= 32'h7/*7:bevelab10*/;
                           T403_Emu_calc_IP_checksum_6_0_V_1 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[((32'h3/*3:USA66*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0))) || (32'h2/*2:USA66*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))? rtl_unsigned_bitextract4(32'd1
                          +rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)): T403_Emu_calc_IP_checksum_6_0_V_0)]);

                           T403_Emu_calc_IP_checksum_6_0_SPILL_256 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[((32'h3/*3:USA66*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0))) || (32'h2/*2:USA66*/==
                          rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))? rtl_unsigned_bitextract4(32'd1
                          +rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)): T403_Emu_calc_IP_checksum_6_0_V_0)]);

                           end 
                          if (((32'h1/*1:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                  )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))<32'sd5
                  ) && (32'h2/*2:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0))) && 
                  (32'h3/*3:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0))) && (32'h4
                  /*4:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))) || (32'h4/*4:USA66*/==
                  rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0))))  begin 
                          if (((32'h1/*1:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))<
                          32'sd5) && (32'h2/*2:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h3/*3:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h4/*4:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))) || (32'h4/*4:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))))  begin 
                                   T403_Emu_calc_IP_checksum_6_0_SPILL_256 <= (($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  )))<32'sd5) && (32'h1/*1:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ))) && (32'h4/*4:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ))) && (32'h2/*2:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ))) && (32'h3/*3:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  )))? 64'h0: ((32'h4/*4:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  )))? (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4]<<32'sd48): (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                                  [64'd1]>>32'sd48)));

                                   T403_Emu_calc_IP_checksum_6_0_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ));

                                   T403_Emu_calc_IP_checksum_6_0_V_12 <= hprpin501517x10;
                                   end 
                                   bevelab10 <= 32'h7/*7:bevelab10*/;
                           T403_Emu_calc_IP_checksum_6_0_V_1 <= $unsigned((((32'h1/*1:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))? 1'd1: ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))<
                          32'sd5) && (32'h2/*2:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h3/*3:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h4/*4:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))) || (32'h4/*4:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))? (($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))<32'sd5
                          ) && (32'h1/*1:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h4/*4:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h2/*2:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          ))) && (32'h3/*3:USA66*/!=rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))? 64'h0: ((32'h4/*4:USA66*/==rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))? (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd4]<<32'sd48): (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                          [64'd1]>>32'sd48))): T403_Emu_calc_IP_checksum_6_0_SPILL_256));

                           end 
                          if (((32'h0/*0:USA64*/==$unsigned(64'sh_ffff&-64'sh1^(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff
                  &T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7)+(T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7
                  >>32'sd16))+(T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7
                  )+(T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7>>32'sd16)>>32'sd16)))? (Emu_one_question? !Emu_std_query
                  : 1'd1): 1'd1) && ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))>=
                  32'sd5))  begin 
                          if (((Emu_one_question? !Emu_std_query && (32'h0/*0:USA70*/==$unsigned(64'sh_ffff&-64'sh1^hprpin501517x10)): 1'd1
                          ) || (32'h0/*0:USA70*/!=$unsigned(64'sh_ffff&-64'sh1^hprpin501517x10))) && ($signed(rtl_unsigned_bitextract4(32'd1
                          +rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0)))>=32'sd5))  begin 
                                   Emu_chksumIP <= $unsigned(64'sh_ffff&-64'sh1^hprpin501517x10);
                                   T403_Emu_calc_IP_checksum_6_0_V_12 <= 64'sh_ffff&-64'sh1^hprpin501517x10;
                                   T403_Emu_calc_IP_checksum_6_0_V_0 <= rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                                  ));

                                   end 
                                  if (((32'h0/*0:USA70*/==$unsigned(64'sh_ffff&-64'sh1^hprpin501517x10))? (Emu_one_question? !Emu_std_query
                          : 1'd1): 1'd1) && ($signed(rtl_unsigned_bitextract4(32'd1+rtl_unsigned_extend6(T403_Emu_calc_IP_checksum_6_0_V_0
                          )))>=32'sd5))  bevelab10 <= 32'h9/*9:bevelab10*/;
                               end 
                           end 
                  
              32'h7/*7:bevelab10*/:  begin 
                   bevelab10 <= 32'h8/*8:bevelab10*/;
                   T403_Emu_calc_IP_checksum_6_0_V_7 <= (64'sh_ffff&hprpin501507x10)+(hprpin501507x10>>32'sd16);
                   T403_Emu_calc_IP_checksum_6_0_V_6 <= (64'sh_ffff&hprpin501503x10)+(hprpin501503x10>>32'sd16);
                   end 
                  
              32'h6/*6:bevelab10*/:  begin 
                  if (T403_Emu_DNS_logic_1_1_V_9 && T403_Emu_DNS_logic_1_1_V_10)  begin 
                           bevelab10 <= 32'h7/*7:bevelab10*/;
                           T403_Emu_calc_IP_checksum_6_0_V_1 <= $unsigned((A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1]>>32'sd48
                          ));

                           T403_Emu_calc_IP_checksum_6_0_SPILL_256 <= (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[64'd1]>>32'sd48);
                           T403_Emu_calc_IP_checksum_6_0_V_0 <= 8'h1;
                           T403_Emu_calc_IP_checksum_6_0_V_12 <= 64'h0;
                           T403_Emu_calc_IP_checksum_6_0_V_7 <= 64'h0;
                           T403_Emu_calc_IP_checksum_6_0_V_6 <= 64'h0;
                           end 
                          if ((T403_Emu_DNS_logic_1_1_V_9? !T403_Emu_DNS_logic_1_1_V_10: 1'd1))  bevelab10 <= 32'h9/*9:bevelab10*/;
                       end 
                  
              32'h5/*5:bevelab10*/:  begin 
                  if ((((32'h0/*0:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))? 1'd1: (32'h1/*1:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  )) && (32'h6/*6:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h5/*5:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  )) && (32'h4/*4:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h3/*3:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  )) && (32'h2/*2:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))) || (32'h6/*6:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  )) || (32'h5/*5:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h4/*4:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  )) || (32'h3/*3:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h2/*2:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                  ))) && (T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                          if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h4/*4:USA50*/==$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)))  begin 
                                   Emu_UDP_total_length <= 64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )]>>32'sd48);

                                   Emu_app_dst_port <= 64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )]>>32'sd32);

                                   Emu_app_src_port <= 64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )]>>32'sd16);

                                   end 
                                  if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h2/*2:USA50*/==
                          $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                                   Emu_IP_total_length <= 64'sh_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )];

                                   Emu_proto_UDP <= (32'h11/*17:USA58*/==(64'shff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                                  +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd56)));

                                   Emu_proto_ICMP <= (32'h1/*1:USA58*/==(64'shff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                                  +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd56)));

                                   end 
                                  if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h0/*0:USA50*/==
                          $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                                   Emu_src_port <= 64'shff&(A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0]>>32'sd16);
                                   Emu_src_mac <= 64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )]>>32'sd48);

                                   Emu_dst_mac <= 64'sh_ffff_ffff_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                                  )];

                                   end 
                                  if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h5/*5:USA50*/==
                          $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                                   Emu_std_query <= (32'h0/*0:USA56*/==(64'shf&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                                  +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd36)));

                                   Emu_one_question <= (32'h1/*1:USA54*/==(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                                  +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd56));

                                   end 
                                  if ((((32'h0/*0:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))? 1'd1: (32'h1/*1:USA50*/!=$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)) && (32'h6/*6:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h5/*5:USA50*/!=
                          $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h4/*4:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )) && (32'h3/*3:USA50*/!=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h2/*2:USA50*/!=$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2))) || (32'h6/*6:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h5
                          /*5:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h4/*4:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )) || (32'h3/*3:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h2/*2:USA50*/==$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2))) && (T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))) 
                           T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                              if (((32'h3/*3:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) || (32'h4/*4:USA50*/==$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2))) && (T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))) 
                           Emu_dst_ip <= ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h3/*3:USA50*/==
                              $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))? 64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                              +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd48): Emu_dst_ip|((64'sh_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                              [$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)])<<32'sd16));

                              if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h6/*6:USA50*/==$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)))  Emu_start_parsing <= (32'h_7703/*30467:USA52*/==(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                              [$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]>>32'sd48));

                              if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h3/*3:USA50*/==$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)))  Emu_src_ip <= 64'h_ffff_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                              +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd16);

                               end 
                          if ((T403_Emu_DNS_logic_1_1_V_7<$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)))  begin 
                           bevelab10 <= 32'h6/*6:bevelab10*/;
                           T403_Emu_DNS_logic_1_1_V_11 <= rtl_unsigned_bitextract7(Emu_proto_ICMP);
                           T403_Emu_DNS_logic_1_1_V_10 <= rtl_unsigned_bitextract7(Emu_proto_UDP);
                           T403_Emu_DNS_logic_1_1_V_9 <= rtl_unsigned_bitextract7(Emu_IPv4);
                           T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                           end 
                          if ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h1/*1:USA50*/==$unsigned(32'd1
                  +T403_Emu_DNS_logic_1_1_V_2)))  begin 
                           Emu_IPv4 <= rtl_unsigned_bitextract1(((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )) && (32'h1/*1:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2))? ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)) && (32'h1/*1:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h8/*8:USA60*/!=
                          (64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]>>32'sd32
                          )))? 1'd0: rtl_sign_extend2((32'h4/*4:USA62*/==(64'shf&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1
                          +T403_Emu_DNS_logic_1_1_V_2)]>>32'sd52))))): T403_Emu_Extract_headers_2_9_SPILL_256));

                           T403_Emu_Extract_headers_2_9_SPILL_256 <= ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )) && (32'h1/*1:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h8/*8:USA60*/!=(64'sh_ffff&(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                          [$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]>>32'sd32)))? 32'sd0: rtl_sign_extend2((32'h4/*4:USA62*/==(64'shf
                          &(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]>>32'sd52)))));

                           Emu_src_mac <= Emu_src_mac|((64'h_ffff_ffff&A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
                          )])<<32'sd16);

                           T403_Emu_DNS_logic_1_1_V_2 <= $unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2);
                           end 
                           end 
                  
              32'h4/*4:bevelab10*/: if ((T403_Emu_ReceiveFrame_1_1_V_1<32'h0))  begin 
                       bevelab10 <= 32'h6/*6:bevelab10*/;
                       T403_Emu_DNS_logic_1_1_V_11 <= rtl_unsigned_bitextract7(Emu_proto_ICMP);
                       T403_Emu_DNS_logic_1_1_V_10 <= rtl_unsigned_bitextract7(Emu_proto_UDP);
                       T403_Emu_DNS_logic_1_1_V_9 <= rtl_unsigned_bitextract7(Emu_IPv4);
                       T403_Emu_DNS_logic_1_1_V_2 <= 32'h0;
                       T403_Emu_DNS_logic_1_1_V_7 <= T403_Emu_ReceiveFrame_1_1_V_1;
                       T403_Emu_ReceiveFrame_1_1_V_0 <= 32'h0;
                       s_axis_tready <= 1'h0;
                       A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_1] <= T403_Emu_ReceiveFrame_1_1_V_6;
                       end 
                       else  begin 
                       bevelab10 <= 32'h5/*5:bevelab10*/;
                       Emu_src_port <= 64'shff&(A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[64'd0]>>32'sd16);
                       Emu_src_mac <= 64'sh_ffff&(((32'h0/*0:USA48*/==T403_Emu_ReceiveFrame_1_1_V_1)? T403_Emu_ReceiveFrame_1_1_V_6: A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
                      [32'h0])>>32'sd48);

                       Emu_dst_mac <= 64'sh_ffff_ffff_ffff&((32'h0/*0:USA48*/==T403_Emu_ReceiveFrame_1_1_V_1)? T403_Emu_ReceiveFrame_1_1_V_6
                      : A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[32'h0]);

                       T403_Emu_DNS_logic_1_1_V_2 <= 32'h0;
                       T403_Emu_DNS_logic_1_1_V_7 <= T403_Emu_ReceiveFrame_1_1_V_1;
                       T403_Emu_ReceiveFrame_1_1_V_0 <= 32'h0;
                       s_axis_tready <= 1'h0;
                       A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_1] <= T403_Emu_ReceiveFrame_1_1_V_6;
                       end 
                      
              32'h3/*3:bevelab10*/:  begin 
                  if (((32'sd2==T403_Emu_ReceiveFrame_1_1_V_7)? 1'd1: ((32'sd7==T403_Emu_ReceiveFrame_1_1_V_7)? (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7
                  ) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7): ((32'sd31==T403_Emu_ReceiveFrame_1_1_V_7)? 1'd1: ((32'sd127==T403_Emu_ReceiveFrame_1_1_V_7
                  )? 1'd1: (32'sd255!=T403_Emu_ReceiveFrame_1_1_V_7)) && (32'sd63!=T403_Emu_ReceiveFrame_1_1_V_7)) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7
                  ) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7))) || (32'sd255==T403_Emu_ReceiveFrame_1_1_V_7
                  ) || (32'sd63==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd15==T403_Emu_ReceiveFrame_1_1_V_7))  begin 
                          if (((32'sd7==T403_Emu_ReceiveFrame_1_1_V_7)? 1'd1: ((32'sd31==T403_Emu_ReceiveFrame_1_1_V_7)? (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7
                          ) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7): ((32'sd127==T403_Emu_ReceiveFrame_1_1_V_7)? 1'd1: (32'sd255!=T403_Emu_ReceiveFrame_1_1_V_7
                          )) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd63!=T403_Emu_ReceiveFrame_1_1_V_7
                          )) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7)) || (32'sd255==T403_Emu_ReceiveFrame_1_1_V_7
                          ) || (32'sd63==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd2==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd15==T403_Emu_ReceiveFrame_1_1_V_7
                          ))  T403_Emu_ReceiveFrame_1_1_V_6 <= ((32'sd7==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 64'shff_ffff&T403_Emu_ReceiveFrame_1_1_V_5
                              : ((32'sd15==T403_Emu_ReceiveFrame_1_1_V_7)? 64'h_ffff_ffff&T403_Emu_ReceiveFrame_1_1_V_5: ((32'sd7!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd31==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 64'shff_ffff_ffff
                              &T403_Emu_ReceiveFrame_1_1_V_5: ((32'sd63==T403_Emu_ReceiveFrame_1_1_V_7)? 64'sh_ffff_ffff_ffff&T403_Emu_ReceiveFrame_1_1_V_5
                              : ((32'sd7!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd31!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd63!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd127==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 64'shff_ffff_ffff_ffff
                              &T403_Emu_ReceiveFrame_1_1_V_5: ((32'sd255==T403_Emu_ReceiveFrame_1_1_V_7)? -64'sh1&T403_Emu_ReceiveFrame_1_1_V_5
                              : 64'h0))))));

                              if (((32'sd7==T403_Emu_ReceiveFrame_1_1_V_7)? 1'd1: ((32'sd31==T403_Emu_ReceiveFrame_1_1_V_7)? (32'sd3!=
                          T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7
                          ): (32'sd127==T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7
                          ) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd63!=T403_Emu_ReceiveFrame_1_1_V_7)) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7
                          )) || (32'sd255==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd63==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd15==T403_Emu_ReceiveFrame_1_1_V_7
                          ))  Emu_last_tkeep <= ((32'sd7==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7) && 
                              (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 8'h3: ((32'sd15==T403_Emu_ReceiveFrame_1_1_V_7
                              )? 8'h4: ((32'sd7!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd31
                              ==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 8'h5: ((32'sd63==T403_Emu_ReceiveFrame_1_1_V_7)? 8'h6: ((32'sd7
                              !=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd15!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd31!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd63!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd127==T403_Emu_ReceiveFrame_1_1_V_7) && (32'd1!=T403_Emu_ReceiveFrame_1_1_V_7
                              ) && (32'sd2!=T403_Emu_ReceiveFrame_1_1_V_7) && (32'sd3!=T403_Emu_ReceiveFrame_1_1_V_7)? 8'h7: 8'h8)))));

                               bevelab10 <= 32'h4/*4:bevelab10*/;
                           end 
                          if ((32'd1==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd3==T403_Emu_ReceiveFrame_1_1_V_7))  begin 
                          if ((32'd1==T403_Emu_ReceiveFrame_1_1_V_7) || (32'sd3==T403_Emu_ReceiveFrame_1_1_V_7))  begin 
                                   Emu_last_tkeep <= ((32'd1==T403_Emu_ReceiveFrame_1_1_V_7)? 8'h1: 8'h2);
                                   T403_Emu_ReceiveFrame_1_1_V_6 <= ((32'd1==T403_Emu_ReceiveFrame_1_1_V_7)? 64'shff&T403_Emu_ReceiveFrame_1_1_V_5
                                  : 64'sh_ffff&T403_Emu_ReceiveFrame_1_1_V_5);

                                   end 
                                   bevelab10 <= 32'h4/*4:bevelab10*/;
                           end 
                           end 
                  
              32'h2/*2:bevelab10*/:  begin 
                  if (s_axis_tvalid && T403_Emu_ReceiveFrame_1_1_V_3)  begin 
                           s_axis_tready <= rtl_unsigned_bitextract1((s_axis_tvalid && T403_Emu_ReceiveFrame_1_1_V_3? (s_axis_tvalid && 
                          !s_axis_tlast && T403_Emu_ReceiveFrame_1_1_V_3? 1'd1: 1'd0): T403_Emu_ReceiveFrame_1_1_SPILL_258));

                           T403_Emu_ReceiveFrame_1_1_SPILL_258 <= (s_axis_tvalid && !s_axis_tlast && T403_Emu_ReceiveFrame_1_1_V_3? 32'sd1
                          : 32'sd0);

                           T403_Emu_ReceiveFrame_1_1_V_3 <= rtl_unsigned_bitextract1((s_axis_tvalid && T403_Emu_ReceiveFrame_1_1_V_3? (s_axis_tvalid
                           && s_axis_tlast && T403_Emu_ReceiveFrame_1_1_V_3? 1'd0: s_axis_tvalid): T403_Emu_ReceiveFrame_1_1_SPILL_257
                          ));

                           T403_Emu_ReceiveFrame_1_1_SPILL_257 <= (s_axis_tvalid && s_axis_tlast && T403_Emu_ReceiveFrame_1_1_V_3? 32'sd0
                          : s_axis_tvalid);

                           T403_Emu_ReceiveFrame_1_1_V_1 <= T403_Emu_ReceiveFrame_1_1_V_0;
                           T403_Emu_ReceiveFrame_1_1_V_0 <= $unsigned(32'd1+T403_Emu_ReceiveFrame_1_1_V_0);
                           A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[T403_Emu_ReceiveFrame_1_1_V_0] <= s_axis_tuser_low;
                           A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_ReceiveFrame_1_1_V_0] <= rtl_unsigned_bitextract4(s_axis_tkeep
                          );

                           A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_0] <= s_axis_tdata;
                           end 
                          if (!T403_Emu_ReceiveFrame_1_1_V_3)  begin 
                           bevelab10 <= 32'h3/*3:bevelab10*/;
                           T403_Emu_ReceiveFrame_1_1_V_7 <= rtl_unsigned_bitextract4(A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[T403_Emu_ReceiveFrame_1_1_V_1
                          ]);

                           T403_Emu_ReceiveFrame_1_1_V_5 <= $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[T403_Emu_ReceiveFrame_1_1_V_1
                          ]);

                           end 
                           end 
                  
              32'h1/*1:bevelab10*/: if (s_axis_tvalid)  begin 
                       bevelab10 <= 32'h2/*2:bevelab10*/;
                       s_axis_tready <= rtl_unsigned_bitextract1((s_axis_tvalid? (s_axis_tvalid && !s_axis_tlast? 1'd1: 1'd0): T403_Emu_ReceiveFrame_1_1_SPILL_258
                      ));

                       T403_Emu_ReceiveFrame_1_1_SPILL_258 <= (s_axis_tvalid && !s_axis_tlast? 32'sd1: 32'sd0);
                       T403_Emu_ReceiveFrame_1_1_V_3 <= rtl_unsigned_bitextract1((s_axis_tvalid? (s_axis_tvalid && s_axis_tlast? 1'd0
                      : s_axis_tvalid): T403_Emu_ReceiveFrame_1_1_SPILL_257));

                       T403_Emu_ReceiveFrame_1_1_SPILL_257 <= (s_axis_tvalid && s_axis_tlast? 32'sd0: s_axis_tvalid);
                       T403_Emu_ReceiveFrame_1_1_V_1 <= 32'h0;
                       T403_Emu_ReceiveFrame_1_1_V_0 <= 32'h1;
                       T403_Emu_ReceiveFrame_1_1_V_7 <= 8'h0;
                       T403_Emu_ReceiveFrame_1_1_V_6 <= 64'h0;
                       T403_Emu_ReceiveFrame_1_1_V_5 <= 64'h0;
                       A_64_US_CC_tuser_low_tuser_low_SCALbx10_tuser_low_ARA0[32'h0] <= s_axis_tuser_low;
                       A_8_US_CC_tkeep_tkeep_SCALbx22_tkeep_ARA0[32'h0] <= rtl_unsigned_bitextract4(s_axis_tkeep);
                       A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[32'h0] <= s_axis_tdata;
                       end 
                       else  begin 
                       bevelab10 <= 32'h2/*2:bevelab10*/;
                       T403_Emu_ReceiveFrame_1_1_V_7 <= 8'h0;
                       T403_Emu_ReceiveFrame_1_1_V_6 <= 64'h0;
                       T403_Emu_ReceiveFrame_1_1_V_5 <= 64'h0;
                       T403_Emu_ReceiveFrame_1_1_V_3 <= 1'h1;
                       T403_Emu_ReceiveFrame_1_1_V_1 <= 32'h0;
                       T403_Emu_ReceiveFrame_1_1_V_0 <= 32'h0;
                       end 
                      
              32'h0/*0:bevelab10*/:  begin 
                   bevelab10 <= 32'h1/*1:bevelab10*/;
                   s_axis_tready <= 1'h1;
                   m_axis_tuser_low <= 64'h0;
                   m_axis_tuser_hi <= 64'h0;
                   m_axis_tvalid <= 1'h0;
                   m_axis_tlast <= 1'h0;
                   m_axis_tkeep <= 8'h0;
                   m_axis_tdata <= 64'h0;
                   T403_Emu_DNS_logic_1_1_V_11 <= 1'h0;
                   T403_Emu_DNS_logic_1_1_V_10 <= 1'h0;
                   T403_Emu_DNS_logic_1_1_V_9 <= 1'h0;
                   T403_Emu_DNS_logic_1_1_V_8 <= 32'h0;
                   T403_Emu_DNS_logic_1_1_V_7 <= 32'h0;
                   T403_Emu_DNS_logic_1_1_V_3 <= 32'h0;
                   T403_Emu_DNS_logic_1_1_V_2 <= 32'h0;
                   Emu_chksumIP <= 64'h0;
                   Emu_chksum_UDP <= 64'h0;
                   Emu_exist_rest <= 1'h0;
                   Emu_last_tkeep <= 8'h0;
                   Emu_proto_ICMP <= 1'h0;
                   Emu_proto_UDP <= 1'h0;
                   Emu_IPv4 <= 1'h0;
                   debug_reg <= 32'h0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd6] <= 32'sh600_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd5] <= 32'sh500_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd4] <= 32'sh400_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd3] <= 32'sh300_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd2] <= 32'sh200_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd1] <= 32'sh100_a8c0;
                   A_UINT_CC_IPs_IPs_SCALbx20_IPs_ARA0[32'd0] <= 32'd43200;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd6] <= 64'sh1_0000_6772_6f03;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd5] <= 64'd0;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd4] <= 64'sh1_0001_0000_6b75;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd3] <= 64'sh1_0000_6d6f_6303;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd2] <= 64'sh100_0100;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd1] <= 64'sh100_0100;
                   A_64_US_CC_DNS_part_2_DNS_part_2_SCALbx14_DNS_part_2_ARC0[64'd0] <= 64'sh100;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd6] <= 64'sh_6566_696c_646c_6977;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd5] <= 64'sh1_0001_0000;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd4] <= 64'sh26f_6302_6567_6469;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd3] <= 64'sh_6563_6976_7265_736e;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd2] <= 64'sh6b_7502_6361_026d;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd1] <= 64'sh6d_6f63_036b_6f6f;
                   A_64_US_CC_DNS_part_1_DNS_part_1_SCALbx16_DNS_part_1_ARD0[64'd0] <= 64'sh100_006d_6f63_0365;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd6] <= 64'sh_646c_726f_770d_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd5] <= 64'sh_7267_026e_6902_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd4] <= 64'sh_7262_6d61_6309_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd3] <= 64'sh_6f64_6e6f_6c0d_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd2] <= 64'sh_6163_036c_6302_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd1] <= 64'sh_6265_6361_6608_7777;
                   A_64_US_CC_DNS_part_0_DNS_part_0_SCALbx18_DNS_part_0_ARE0[64'd0] <= 64'sh_6c67_6f6f_6706_7777;
                   end 
                  endcase
      //End structure HPR anontop/1.0


       end 
      

assign hprpin501503x10 = (((64'shff&T403_Emu_calc_IP_checksum_6_0_V_1)<<32'sd8)|((64'sh_ff00&T403_Emu_calc_IP_checksum_6_0_V_1)>>32'sd8))+(((64'shff&(T403_Emu_calc_IP_checksum_6_0_V_1
>>32'sd16))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_6_0_V_1>>32'sd16))>>32'sd8));

assign hprpin501507x10 = (((64'shff&(T403_Emu_calc_IP_checksum_6_0_V_1>>32'sd32))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_6_0_V_1>>32'sd32))>>32'sd8))+
(((64'shff&(T403_Emu_calc_IP_checksum_6_0_V_1>>32'sd48))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_6_0_V_1>>32'sd48))>>32'sd8));

assign hprpin501517x10 = (64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7)+(T403_Emu_calc_IP_checksum_6_0_V_6
+T403_Emu_calc_IP_checksum_6_0_V_7>>32'sd16))+(T403_Emu_calc_IP_checksum_6_0_V_12+(64'sh_ffff&T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7
)+(T403_Emu_calc_IP_checksum_6_0_V_6+T403_Emu_calc_IP_checksum_6_0_V_7>>32'sd16)>>32'sd16);

assign hprpin501679x10 = (((64'shff&T403_Emu_calc_IP_checksum_27_14_V_1)<<32'sd8)|((64'sh_ff00&T403_Emu_calc_IP_checksum_27_14_V_1)>>32'sd8))+(((64'shff&(T403_Emu_calc_IP_checksum_27_14_V_1
>>32'sd16))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_27_14_V_1>>32'sd16))>>32'sd8));

assign hprpin501683x10 = (((64'shff&(T403_Emu_calc_IP_checksum_27_14_V_1>>32'sd32))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_27_14_V_1>>32'sd32))>>32'sd8
))+(((64'shff&(T403_Emu_calc_IP_checksum_27_14_V_1>>32'sd48))<<32'sd8)|((64'sh_ff00&(T403_Emu_calc_IP_checksum_27_14_V_1>>32'sd48))>>
32'sd8));

assign hprpin501693x10 = (64'sh_ffff&T403_Emu_calc_IP_checksum_27_14_V_12+(64'sh_ffff&T403_Emu_calc_IP_checksum_27_14_V_6+T403_Emu_calc_IP_checksum_27_14_V_7)+
(T403_Emu_calc_IP_checksum_27_14_V_6+T403_Emu_calc_IP_checksum_27_14_V_7>>32'sd16))+(T403_Emu_calc_IP_checksum_27_14_V_12+(64'sh_ffff
&T403_Emu_calc_IP_checksum_27_14_V_6+T403_Emu_calc_IP_checksum_27_14_V_7)+(T403_Emu_calc_IP_checksum_27_14_V_6+T403_Emu_calc_IP_checksum_27_14_V_7
>>32'sd16)>>32'sd16);

assign hprpin501747x10 = (((64'shff&Emu_tmp2)<<32'sd8)|((64'sh_ff00&Emu_tmp2)>>32'sd8))+(((64'shff&(Emu_tmp2>>32'sd16))<<32'sd8)|((64'sh_ff00&(Emu_tmp2>>32'sd16
))>>32'sd8));

assign hprpin501751x10 = (((64'shff&(Emu_tmp2>>32'sd32))<<32'sd8)|((64'sh_ff00&(Emu_tmp2>>32'sd32))>>32'sd8))+(((64'shff&(Emu_tmp2>>32'sd48))<<32'sd8)|((64'sh_ff00
&(Emu_tmp2>>32'sd48))>>32'sd8));

assign hprpin501761x10 = (64'sh_ffff&T403_Emu_calc_UDP_checksum_31_5_V_7+(64'sh_ffff&T403_Emu_calc_UDP_checksum_31_5_V_4+T403_Emu_calc_UDP_checksum_31_5_V_5)+
(T403_Emu_calc_UDP_checksum_31_5_V_4+T403_Emu_calc_UDP_checksum_31_5_V_5>>32'sd16))+(T403_Emu_calc_UDP_checksum_31_5_V_7+(64'sh_ffff&
T403_Emu_calc_UDP_checksum_31_5_V_4+T403_Emu_calc_UDP_checksum_31_5_V_5)+(T403_Emu_calc_UDP_checksum_31_5_V_4+T403_Emu_calc_UDP_checksum_31_5_V_5
>>32'sd16)>>32'sd16);

assign hprpin501768x10 = (((64'shff&Emu_tmp3)<<32'sd8)|((64'sh_ff00&Emu_tmp3)>>32'sd8))+(((64'shff&(Emu_tmp3>>32'sd16))<<32'sd8)|((64'sh_ff00&(Emu_tmp3>>32'sd16
))>>32'sd8));

assign hprpin501772x10 = (((64'shff&(Emu_tmp3>>32'sd32))<<32'sd8)|((64'sh_ff00&(Emu_tmp3>>32'sd32))>>32'sd8))+(((64'shff&(Emu_tmp3>>32'sd48))<<32'sd8)|((64'sh_ff00
&(Emu_tmp3>>32'sd48))>>32'sd8));

assign hprpin502226x10 = ((T403_Emu_DNS_logic_1_1_V_7>=$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)) && (32'h4/*4:USA50*/==$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2
))? (A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]>>32'sd16): $unsigned(A_64_US_CC_tdata_tdata_SCALbx12_tdata_ARB0
[$unsigned(32'd1+T403_Emu_DNS_logic_1_1_V_2)]));

// 1 vectors of width 6
// 13 vectors of width 1
// 4 vectors of width 8
// 40 vectors of width 64
// 8 vectors of width 32
// 80 array locations of width 8
// 7 array locations of width 32
// 181 array locations of width 64
// 96 bits in scalar variables
// Total state bits in module = 15411 bits.
// 768 continuously assigned (wire/non-state) bits 
// Total number of leaf cells = 0
endmodule

//  
// LCP delay estimations included: turn off with -vnl-lcp-delay-estimate=disable
//HPR L/S (orangepath) auxiliary reports.
//KiwiC compilation report
//Kiwi Scientific Acceleration (KiwiC .net/CIL/C# to Verilog/SystemC compiler): Version Alpha 0.3.1x : 11th-May-2017
//20/09/2018 09:52:57
//Cmd line args:  /root/kiwi/kiwipro/kiwic/distro/lib/kiwic.exe emu_DNS_server.dll -bevelab-default-pause-mode=hard -vnl-resets=synchronous -vnl-roundtrip=disable -res2-loadstore-port-count=0 -restructure2=disable -conerefine=enable -compose=disable -vnl emu_DNS_server.v


//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation @64 for prefix @/64
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation @8 for prefix @/8
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation TED1._SPILL for prefix T403/Emu/DNS_logic/1.1/_SPILL
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation TER1._SPILL for prefix T403/Emu/ReceiveFrame/1.1/_SPILL
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation TEE2._SPILL for prefix T403/Emu/Extract_headers/2.9/_SPILL
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation TEc6._SPILL for prefix T403/Emu/calc_IP_checksum/6.0/_SPILL
//

//----------------------------------------------------------

//Report from Abbreviation:::
//    setting up abbreviation TEc27_SPILL for prefix T403/Emu/calc_IP_checksum/27.14/_SPILL
//

//----------------------------------------------------------

//Report from KiwiC-fe.rpt:::
//KiwiC: front end input processing of class or method called KiwiSystem/Kiwi
//
//root_walk start thread at a static method (used as an entry point). Method name=.cctor uid=cctor10
//
//KiwiC start_thread (or entry point) id=cctor10
//
//Root method elaborated: specificf=S_kickoff_collate leftover=1+0
//
//KiwiC: front end input processing of class or method called System/BitConverter
//
//root_walk start thread at a static method (used as an entry point). Method name=.cctor uid=cctor12
//
//KiwiC start_thread (or entry point) id=cctor12
//
//Root method elaborated: specificf=S_kickoff_collate leftover=1+1
//
//KiwiC: front end input processing of class or method called Emu
//
//root_walk start thread at a static method (used as an entry point). Method name=.cctor uid=cctor14
//
//KiwiC start_thread (or entry point) id=cctor14
//
//Root method elaborated: specificf=S_kickoff_collate leftover=1+2
//
//KiwiC: front end input processing of class or method called Emu
//
//root_compiler: start elaborating class 'Emu'
//
//elaborating class 'Emu'
//
//compiling static method as entry point: style=Root idl=Emu/EntryPoint
//
//Performing root elaboration of method EntryPoint
//
//KiwiC start_thread (or entry point) id=EntryPoint10
//
//root_compiler class done: Emu
//
//Report of all settings used from the recipe or command line:
//
//   kiwife-directorate-ready-flag=absent
//
//   kiwife-directorate-endmode=auto-restart
//
//   kiwife-directorate-startmode=self-start
//
//   cil-uwind-budget=10000
//
//   kiwic-cil-dump=disable
//
//   kiwic-kcode-dump=disable
//
//   kiwic-register-colours=disable
//
//   array-4d-name=KIWIARRAY4D
//
//   array-3d-name=KIWIARRAY3D
//
//   array-2d-name=KIWIARRAY2D
//
//   kiwi-dll=Kiwi.dll
//
//   kiwic-dll=Kiwic.dll
//
//   kiwic-zerolength-arrays=disable
//
//   kiwifefpgaconsole-default=enable
//
//   kiwife-directorate-style=basic
//
//   postgen-optimise=enable
//
//   kiwife-cil-loglevel=20
//
//   kiwife-ataken-loglevel=20
//
//   kiwife-gtrace-loglevel=20
//
//   kiwife-firstpass-loglevel=20
//
//   kiwife-overloads-loglevel=20
//
//   root=$attributeroot
//
//   srcfile=emu_DNS_server.dll
//
//   kiwic-autodispose=disable
//
//END OF KIWIC REPORT FILE
//

//----------------------------------------------------------

//Report from verilog_render:::
//1 vectors of width 6
//
//13 vectors of width 1
//
//4 vectors of width 8
//
//40 vectors of width 64
//
//8 vectors of width 32
//
//80 array locations of width 8
//
//7 array locations of width 32
//
//181 array locations of width 64
//
//96 bits in scalar variables
//
//Total state bits in module = 15411 bits.
//
//768 continuously assigned (wire/non-state) bits 
//
//Total number of leaf cells = 0
//

//Major Statistics Report:
//Thread .cctor uid=cctor10 has 3 CIL instructions in 1 basic blocks
//Thread .cctor uid=cctor12 has 2 CIL instructions in 1 basic blocks
//Thread .cctor uid=cctor14 has 47 CIL instructions in 1 basic blocks
//Thread EntryPoint uid=EntryPoint10 has 526 CIL instructions in 118 basic blocks
//Thread mpc10 has 51 bevelab control states (pauses)
// eof (HPR L/S Verilog)
