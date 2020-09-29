//
// Copyright (c) 2019 -
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

#include <core.p4>
#include <sume_switch.p4>

// USEFUL DEFINITIONS
#define IPV4_TYPE 0x0800
#define PORT_SIZE 8
#define PORTS_SIZE 16

// SUME PORTS
#define NF0 0b0000_0001
#define NF1 0b0000_0100
#define NF2 0b0001_0000
#define NF3 0b0100_0000
#define DRP 0b0000_0000
#define BRD 0b0101_0101
#define BRD_0 0b0101_0100
#define BRD_1 0b0101_0001
#define BRD_2 0b0100_0101
#define BRD_3 0b0001_0101
#define UNK 0b1111_1111

// EXTERN RWI OPs
#define READ    8w0
#define WRITE   8w1
#define INC     8w2
#define ADV     8w3

// COUNTER
#define COUNT_INDEX_WIDTH 1

// EXTERNS
#define INDEX_WIDTH 1
#define BUS_WIDTH 32

// PSEUDORANDOM
#define RND_WIDTH 48

////////////////////////////////////////////////////////////////////////////////
///                        STANDARD HEADERs
////////////////////////////////////////////////////////////////////////////////

// --------------------------
//          ETHERNET
// --------------------------
#define ETHERNET_SIZEB 14
#define ETHERNET_SIZEb (ETHERNET_SIZEB*8)

header Ethernet_h {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

// --------------------------
//          IPV4
// --------------------------
#define IPV4_SIZEB 20
#define IPV4_SIZEb (INT_SIZEB*8)

// IPv4 header without options
header IPv4_h {
    bit<4> version;
    bit<4> ihl;
    bit<8> diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3> flags;
    bit<13> fragOffset;
    bit<8> ttl;
    bit<8> protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}
////////////////////////////////////////////////////////////////////////////////
///                        RECOGNIZED HEADERS
////////////////////////////////////////////////////////////////////////////////

struct Parsed_packet {
    Ethernet_h ethernet;
    IPv4_h ipv4;
}

////////////////////////////////////////////////////////////////////////////////
///                        METADATA
////////////////////////////////////////////////////////////////////////////////

// digest data to be sent to CPU if desired. MUST be 80 bits!
struct digest_data_t {
    bit<80>  unused;
}

// user defined metadata: can be used to shared information between
// TopParser, TopPipe, and TopDeparser
struct user_metadata_t {
    bit<8>  unused;
}

////////////////////////////////////////////////////////////////////////////////
///                             PARSER
////////////////////////////////////////////////////////////////////////////////

// Parser Implementation
@Xilinx_MaxPacketRegion(16384)
parser TopParser_dbg(packet_in b,
                 out Parsed_packet p,
                 out user_metadata_t user_metadata,
                 out digest_data_t digest_data,
                 inout sume_metadata_t sume_metadata) {

    state start {
        transition accept;
    }

}

////////////////////////////////////////////////////////////////////////////////
///                        MATCH-ACTION PIPELINE
////////////////////////////////////////////////////////////////////////////////

// match-action pipeline
control TopPipe_dbg(inout Parsed_packet p,
                inout user_metadata_t user_metadata,
                inout digest_data_t digest_data,
                inout sume_metadata_t sume_metadata) {

  	// COUNTER
  	bit<BUS_WIDTH> count_in;
  	bit<BUS_WIDTH> count_out;

    //************************************************
    // TABLE: DONOTHING
    //************************************************
    table donothing {
        key = {sume_metadata.meta_0: exact;}

        actions = {
            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // @@@        MATCH / ACTION FLOW
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    apply {

        //+++++++++++++++++
        //+  USELESS TABLE
        //+++++++++++++++++
        donothing.apply();

        //+++++++++++++++++
        //+  SET ETHERNET
        //+++++++++++++++++
        p.ethernet.setValid();
        p.ethernet.etherType = IPV4_TYPE;
        p.ethernet.srcAddr = 48w0xAAAAAAAAAAAA;
        p.ethernet.dstAddr = 48w0xBBBBBBBBBBBB;

        //+++++++++++++++++
        //+  SET IPV4
        //+++++++++++++++++
        p.ipv4.setValid();
        p.ipv4.version = 4w4;
        p.ipv4.ihl = 4w5;
        p.ipv4.diffserv = 8w0;
        p.ipv4.totalLen = (sume_metadata.pkt_len + IPV4_SIZEB);
        p.ipv4.identification = 16w1;
        p.ipv4.flags = 3w0;
        p.ipv4.fragOffset = 13w0;
        p.ipv4.ttl = 8w64;
        p.ipv4.protocol = 8w0xAA;
        p.ipv4.hdrChecksum = 16w0xDEAD;
        p.ipv4.srcAddr = 32w0xA0AAAA0A;
        p.ipv4.dstAddr = 32w0xB0BBBB0B;

        sume_metadata.pkt_len = sume_metadata.pkt_len + ETHERNET_SIZEB + IPV4_SIZEB;

        //+++++++++++++++++
        //+   SET PORTS
        //+++++++++++++++++
        sume_metadata.src_port = NF3;
        sume_metadata.dst_port = NF2;

    } // apply

}// control

////////////////////////////////////////////////////////////////////////////////
///                             DEPARSER
////////////////////////////////////////////////////////////////////////////////

// Deparser Implementation
@Xilinx_MaxPacketRegion(16384)
control TopDeparser_dbg(packet_out b,
                    in Parsed_packet p,
                    in user_metadata_t user_metadata,
                    inout digest_data_t digest_data,
                    inout sume_metadata_t sume_metadata) {
    apply {

        b.emit(p.ethernet);
        b.emit(p.ipv4);

    } // apply

} // control

////////////////////////////////////////////////////////////////////////////////
///                        SWITCH INSTANCE
////////////////////////////////////////////////////////////////////////////////

// Instantiate the switch
SimpleSumeSwitch(TopParser_dbg(), TopPipe_dbg(), TopDeparser_dbg()) main;
