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

// FAKE PPL FOR DISTINGUISH BETWEEN SDNET PIPELINES & HDL/HLS PIPELINES

#include <core.p4>
#include <sume_switch.p4>

#define IPV4_TYPE 0x0800
#define NF0 0b0000_0001

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

// List of all recognized headers
struct Parsed_packet {
    Ethernet_h ethernet;
    IPv4_h ip;
}

// user defined metadata: can be used to shared information between
// TopParser, TopPipe, and TopDeparser
struct user_metadata_t {
    bit<8>  unused;
}

// digest data to send to cpu if desired. MUST be 80 bits!
struct digest_data_t {
    bit<80>  unused;
}

// Parser Implementation
@Xilinx_MaxPacketRegion(8192)
parser TopParser(packet_in b,
                 out Parsed_packet p,
                 out user_metadata_t user_metadata,
                 out digest_data_t digest_data,
                 inout sume_metadata_t sume_metadata) {

    state start {
        b.extract(p.ethernet);
        b.extract(p.ip);
        transition accept;
    }

}

// match-action pipeline
control TopPipe(inout Parsed_packet p,
                inout user_metadata_t user_metadata,
                inout digest_data_t digest_data,
                inout sume_metadata_t sume_metadata) {

    // TABLE: DONOTHING
    table donothing {
        key = {sume_metadata.meta_0: exact;}

        actions = {
            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    apply {

        // apply table
        donothing.apply();

        // CHECK PKT SIZE & DST IP ADDR
        if ((sume_metadata.pkt_len >= 128) && (p.ip.dstAddr == 32w0xB0BBBB0B)){

          // SET OUTPUT PORT
          sume_metadata.dst_port = NF0;

        }

    } // apply

} // control

// Deparser Implementation
@Xilinx_MaxPacketRegion(8192)
control TopDeparser(packet_out b,
                    in Parsed_packet p,
                    in user_metadata_t user_metadata,
                    inout digest_data_t digest_data,
                    inout sume_metadata_t sume_metadata) {
    apply {

        b.emit(p.ethernet);
        b.emit(p.ip);

    }
}

// Instantiate the switch
SimpleSumeSwitch(TopParser(), TopPipe(), TopDeparser()) main;
