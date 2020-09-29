#ifndef DEPARSER_H
#define DEPARSER_H

////////////////////////////////////////////////////////////////////////////////
///                        DEPARSER IMPLEMENTATION
////////////////////////////////////////////////////////////////////////////////

// Deparser Implementation
@Xilinx_MaxPacketRegion(16384)
control TopDeparser(packet_out b,
                    in Parsed_packet p,
                    in user_metadata_t user_metadata,
                    inout digest_data_t digest_data,
                    inout sume_metadata_t sume_metadata) {
    apply {

        b.emit(p.hdr);

    }

}

#endif
