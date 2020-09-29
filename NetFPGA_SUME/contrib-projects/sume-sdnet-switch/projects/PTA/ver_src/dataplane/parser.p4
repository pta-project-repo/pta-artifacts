#ifndef PARSER_H
#define PARSER_H

////////////////////////////////////////////////////////////////////////////////
///                        PARSER IMPLEMENTATION
////////////////////////////////////////////////////////////////////////////////

// Parser Implementation
@Xilinx_MaxPacketRegion(16384)
parser TopParser(packet_in b,
                 out Parsed_packet p,
                 out user_metadata_t user_metadata,
                 out digest_data_t digest_data,
                 inout sume_metadata_t sume_metadata) {

    state start {
        b.extract(p.hdr);
        transition accept;
    }

}

#endif
