#ifndef META_H
#define META_H

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
    bit<8>  um_0;
    bit<8>  um_1;
    bit<8>  um_2;
    bit<8>  um_3;
    bit<8>  um_4;
    bit<8>  um_5;
    bit<8>  um_6;
    bit<8>  um_7;
    bit<8>  um_8;
    bit<8>  um_9;
    bit<8>  um_10;
    bit<8>  um_11;
    bit<8>  um_12;
    bit<8>  um_13;
    bit<8>  um_14;
    bit<8>  um_15;
    bit<8>  um_16;
    bit<8>  um_17;
    bit<8>  um_18;
    bit<8>  um_19;
    bit<8>  um_20;
    bit<8>  um_21;
    bit<8>  um_22;
    bit<8>  um_23;
}

#endif
