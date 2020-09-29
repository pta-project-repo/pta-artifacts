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

#define BRD 0b0101_0101

// Fake header
#define FAKE_SIZE 12
header Fake_h { 
    bit<48> field1;
    bit<48> field2;
}

// List of all recognized headers
struct Parsed_packet { 
    Fake_h fake; 
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

        // GENERATE FAKE HEADER
        p.fake.setValid();
        p.fake.field1 = 48w0xFF33DEAD55FF;
        p.fake.field2 = 48w0xFF77BEEF99FF;
        sume_metadata.pkt_len = sume_metadata.pkt_len + FAKE_SIZE;

        // BROADCAST FAKE PACKET
        sume_metadata.dst_port = BRD;

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

        b.emit(p.fake);

    }
}


// Instantiate the switch
SimpleSumeSwitch(TopParser(), TopPipe(), TopDeparser()) main;

