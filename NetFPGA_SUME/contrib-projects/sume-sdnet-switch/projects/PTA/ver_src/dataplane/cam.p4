#ifndef CAM_H
#define CAM_H

////////////////////////////////////////////////////////////////////////////////
///                        CAM
////////////////////////////////////////////////////////////////////////////////

control Cam(inout Parsed_packet p,
            inout sume_metadata_t sume_metadata,
            inout user_metadata_t user_metadata,
            inout bit<8> keycam,
            inout bit<8> mc,
            inout bit<11> index) {

    //************************************************
    // KEYTAB
    //************************************************

    // ACTIONs
    action mchf0() {mc = p.hdr.hf_0;}
    action mchf1() {mc = p.hdr.hf_1;}
    action mchf2() {mc = p.hdr.hf_2;}
    action mchf3() {mc = p.hdr.hf_3;}
    action mchf4() {mc = p.hdr.hf_4;}
    action mchf5() {mc = p.hdr.hf_5;}
    action mchf6() {mc = p.hdr.hf_6;}
    action mchf7() {mc = p.hdr.hf_7;}
    action mchf8() {mc = p.hdr.hf_8;}
    action mchf9() {mc = p.hdr.hf_9;}
    action mchf10() {mc = p.hdr.hf_10;}
    action mchf11() {mc = p.hdr.hf_11;}
    action mchf12() {mc = p.hdr.hf_12;}
    action mchf13() {mc = p.hdr.hf_13;}
    action mchf14() {mc = p.hdr.hf_14;}
    action mchf15() {mc = p.hdr.hf_15;}
    action mchf16() {mc = p.hdr.hf_16;}
    action mchf17() {mc = p.hdr.hf_17;}
    action mchf18() {mc = p.hdr.hf_18;}
    action mchf19() {mc = p.hdr.hf_19;}
    action mchf20() {mc = p.hdr.hf_20;}
    action mchf21() {mc = p.hdr.hf_21;}
    action mchf22() {mc = p.hdr.hf_22;}
    action mchf23() {mc = p.hdr.hf_23;}
    action mchf24() {mc = p.hdr.hf_24;}
    action mchf25() {mc = p.hdr.hf_25;}
    action mchf26() {mc = p.hdr.hf_26;}
    action mchf27() {mc = p.hdr.hf_27;}
    action mchf28() {mc = p.hdr.hf_28;}
    action mchf29() {mc = p.hdr.hf_29;}
    action mchf30() {mc = p.hdr.hf_30;}
    action mchf31() {mc = p.hdr.hf_31;}
    action mchf32() {mc = p.hdr.hf_32;}
    action mchf33() {mc = p.hdr.hf_33;}
    action mchf34() {mc = p.hdr.hf_34;}
    action mchf35() {mc = p.hdr.hf_35;}
    action mchf36() {mc = p.hdr.hf_36;}
    action mchf37() {mc = p.hdr.hf_37;}
    action mchf38() {mc = p.hdr.hf_38;}
    action mchf39() {mc = p.hdr.hf_39;}
    action mchf40() {mc = p.hdr.hf_40;}
    action mchf41() {mc = p.hdr.hf_41;}
    action mchf42() {mc = p.hdr.hf_42;}
    action mchf43() {mc = p.hdr.hf_43;}
    action mchf44() {mc = p.hdr.hf_44;}
    action mchf45() {mc = p.hdr.hf_45;}
    action mchf46() {mc = p.hdr.hf_46;}
    action mchf47() {mc = p.hdr.hf_47;}
    action mchf48() {mc = p.hdr.hf_48;}
    action mchf49() {mc = p.hdr.hf_49;}
    action mchf50() {mc = p.hdr.hf_50;}
    action mchf51() {mc = p.hdr.hf_51;}
    action mchf52() {mc = p.hdr.hf_52;}
    action mchf53() {mc = p.hdr.hf_53;}
    action mchf54() {mc = p.hdr.hf_54;}
    action mchf55() {mc = p.hdr.hf_55;}
    action mchf56() {mc = p.hdr.hf_56;}
    action mchf57() {mc = p.hdr.hf_57;}
    action mchf58() {mc = p.hdr.hf_58;}
    action mchf59() {mc = p.hdr.hf_59;}
    action mchf60() {mc = p.hdr.hf_60;}
    action mchf61() {mc = p.hdr.hf_61;}
    action mchf62() {mc = p.hdr.hf_62;}
    action mchf63() {mc = p.hdr.hf_63;}

    action mcuf0() {mc = user_metadata.um_0;}
    action mcuf1() {mc = user_metadata.um_1;}
    action mcuf2() {mc = user_metadata.um_2;}
    action mcuf3() {mc = user_metadata.um_3;}
    action mcuf4() {mc = user_metadata.um_4;}
    action mcuf5() {mc = user_metadata.um_5;}
    action mcuf6() {mc = user_metadata.um_6;}
    action mcuf7() {mc = user_metadata.um_7;}
    action mcuf8() {mc = user_metadata.um_8;}
    action mcuf9() {mc = user_metadata.um_9;}
    action mcuf10() {mc = user_metadata.um_10;}
    action mcuf11() {mc = user_metadata.um_11;}
    action mcuf12() {mc = user_metadata.um_12;}
    action mcuf13() {mc = user_metadata.um_13;}
    action mcuf14() {mc = user_metadata.um_14;}
    action mcuf15() {mc = user_metadata.um_15;}
    action mcuf16() {mc = user_metadata.um_16;}
    action mcuf17() {mc = user_metadata.um_17;}
    action mcuf18() {mc = user_metadata.um_18;}
    action mcuf19() {mc = user_metadata.um_19;}
    action mcuf20() {mc = user_metadata.um_20;}
    action mcuf21() {mc = user_metadata.um_21;}
    action mcuf22() {mc = user_metadata.um_22;}
    action mcuf23() {mc = user_metadata.um_23;}

    action mcmdrop() {mc = sume_metadata.drop;}
    action mcmdstprt() {mc = sume_metadata.dst_port;}
    action mcmsrcprt() {mc = sume_metadata.src_port;}
    action mcmpktlen() {mc = sume_metadata.pkt_len[7:0];}
    action mcmf0() {mc = sume_metadata.meta_0;}
    action mcmf1() {mc = sume_metadata.meta_1;}
    action mcmf2() {mc = sume_metadata.meta_2;}
    action mcmf3() {mc = sume_metadata.meta_3;}
    action mcmf4() {mc = sume_metadata.meta_4;}
    action mcmf5() {mc = sume_metadata.meta_5;}
    action mcmf6() {mc = sume_metadata.meta_6;}
    action mcmf7() {mc = sume_metadata.meta_7;}
    action mcmf8() {mc = sume_metadata.meta_8;}
    action mcmf9() {mc = sume_metadata.meta_9;}
    action mcmf10() {mc = sume_metadata.meta_10;}
    action mcmf11() {mc = sume_metadata.meta_11;}
    action mcmf12() {mc = sume_metadata.meta_12;}
    action mcmf13() {mc = sume_metadata.meta_13;}
    action mcmf14() {mc = sume_metadata.meta_14;}
    action mcmf15() {mc = sume_metadata.meta_15;}

    // KEYTAB
    table keytab {
        key = {keycam: exact;}

        actions = {
            mchf0;
            mchf1;
            mchf2;
            mchf3;
            mchf4;
            mchf5;
            mchf6;
            mchf7;
            mchf8;
            mchf9;
            mchf10;
            mchf11;
            mchf12;
            mchf13;
            mchf14;
            mchf15;
            mchf16;
            mchf17;
            mchf18;
            mchf19;
            mchf20;
            mchf21;
            mchf22;
            mchf23;
            mchf24;
            mchf25;
            mchf26;
            mchf27;
            mchf28;
            mchf29;
            mchf30;
            mchf31;
            mchf32;
            mchf33;
            mchf34;
            mchf35;
            mchf36;
            mchf37;
            mchf38;
            mchf39;
            mchf40;
            mchf41;
            mchf42;
            mchf43;
            mchf44;
            mchf45;
            mchf46;
            mchf47;
            mchf48;
            mchf49;
            mchf50;
            mchf51;
            mchf52;
            mchf53;
            mchf54;
            mchf55;
            mchf56;
            mchf57;
            mchf58;
            mchf59;
            mchf60;
            mchf61;
            mchf62;
            mchf63;

            mcuf0;
            mcuf1;
            mcuf2;
            mcuf3;
            mcuf4;
            mcuf5;
            mcuf6;
            mcuf7;
            mcuf8;
            mcuf9;
            mcuf10;
            mcuf11;
            mcuf12;
            mcuf13;
            mcuf14;
            mcuf15;
            mcuf16;
            mcuf17;
            mcuf18;
            mcuf19;
            mcuf20;
            mcuf21;
            mcuf22;
            mcuf23;

            mcmdrop;
            mcmdstprt;
            mcmsrcprt;
            mcmpktlen;
            mcmf0;
            mcmf1;
            mcmf2;
            mcmf3;
            mcmf4;
            mcmf5;
            mcmf6;
            mcmf7;
            mcmf8;
            mcmf9;
            mcmf10;
            mcmf11;
            mcmf12;
            mcmf13;
            mcmf14;
            mcmf15;

            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    //************************************************
    // CAMTAB
    //************************************************

    // ACTIONs
    action setidx(bit<11> idx) {index=idx;}

    // CAMTAB
    table camtab {
        key = {mc: exact;}

        actions = {
            setidx;
            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    //************************************************
    // MATCH / ACTION FLOW
    //************************************************
    apply {

        // KEY
        keytab.apply();

        // CAM
        camtab.apply();

    } // apply

} // control

#endif
