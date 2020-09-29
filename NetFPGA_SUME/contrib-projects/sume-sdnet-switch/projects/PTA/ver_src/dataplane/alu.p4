#ifndef ALU_H
#define ALU_H

////////////////////////////////////////////////////////////////////////////////
///                        ALU
////////////////////////////////////////////////////////////////////////////////

control Alu(inout Parsed_packet p,
            inout sume_metadata_t sume_metadata,
            inout user_metadata_t user_metadata,
            inout bit<8> keyopa,
            inout bit<8> keyopb,
            inout bit<4> keyoper,
            inout bit<8> memopa,
            inout bit<8> memopb,
            inout bit<8> memoper,
            inout bit<4> index) {

    //************************************************
    // OPERAND A
    //************************************************

    // ACTIONs
    action opahf0() {memopa = p.hdr.hf_0;}
    action opahf1() {memopa = p.hdr.hf_1;}
    action opahf2() {memopa = p.hdr.hf_2;}
    action opahf3() {memopa = p.hdr.hf_3;}
    action opahf4() {memopa = p.hdr.hf_4;}
    action opahf5() {memopa = p.hdr.hf_5;}
    action opahf6() {memopa = p.hdr.hf_6;}
    action opahf7() {memopa = p.hdr.hf_7;}
    action opahf8() {memopa = p.hdr.hf_8;}
    action opahf9() {memopa = p.hdr.hf_9;}
    action opahf10() {memopa = p.hdr.hf_10;}
    action opahf11() {memopa = p.hdr.hf_11;}
    action opahf12() {memopa = p.hdr.hf_12;}
    action opahf13() {memopa = p.hdr.hf_13;}
    action opahf14() {memopa = p.hdr.hf_14;}
    action opahf15() {memopa = p.hdr.hf_15;}
    action opahf16() {memopa = p.hdr.hf_16;}
    action opahf17() {memopa = p.hdr.hf_17;}
    action opahf18() {memopa = p.hdr.hf_18;}
    action opahf19() {memopa = p.hdr.hf_19;}
    action opahf20() {memopa = p.hdr.hf_20;}
    action opahf21() {memopa = p.hdr.hf_21;}
    action opahf22() {memopa = p.hdr.hf_22;}
    action opahf23() {memopa = p.hdr.hf_23;}
    action opahf24() {memopa = p.hdr.hf_24;}
    action opahf25() {memopa = p.hdr.hf_25;}
    action opahf26() {memopa = p.hdr.hf_26;}
    action opahf27() {memopa = p.hdr.hf_27;}
    action opahf28() {memopa = p.hdr.hf_28;}
    action opahf29() {memopa = p.hdr.hf_29;}
    action opahf30() {memopa = p.hdr.hf_30;}
    action opahf31() {memopa = p.hdr.hf_31;}
    action opahf32() {memopa = p.hdr.hf_32;}
    action opahf33() {memopa = p.hdr.hf_33;}
    action opahf34() {memopa = p.hdr.hf_34;}
    action opahf35() {memopa = p.hdr.hf_35;}
    action opahf36() {memopa = p.hdr.hf_36;}
    action opahf37() {memopa = p.hdr.hf_37;}
    action opahf38() {memopa = p.hdr.hf_38;}
    action opahf39() {memopa = p.hdr.hf_39;}
    action opahf40() {memopa = p.hdr.hf_40;}
    action opahf41() {memopa = p.hdr.hf_41;}
    action opahf42() {memopa = p.hdr.hf_42;}
    action opahf43() {memopa = p.hdr.hf_43;}
    action opahf44() {memopa = p.hdr.hf_44;}
    action opahf45() {memopa = p.hdr.hf_45;}
    action opahf46() {memopa = p.hdr.hf_46;}
    action opahf47() {memopa = p.hdr.hf_47;}
    action opahf48() {memopa = p.hdr.hf_48;}
    action opahf49() {memopa = p.hdr.hf_49;}
    action opahf50() {memopa = p.hdr.hf_50;}
    action opahf51() {memopa = p.hdr.hf_51;}
    action opahf52() {memopa = p.hdr.hf_52;}
    action opahf53() {memopa = p.hdr.hf_53;}
    action opahf54() {memopa = p.hdr.hf_54;}
    action opahf55() {memopa = p.hdr.hf_55;}
    action opahf56() {memopa = p.hdr.hf_56;}
    action opahf57() {memopa = p.hdr.hf_57;}
    action opahf58() {memopa = p.hdr.hf_58;}
    action opahf59() {memopa = p.hdr.hf_59;}
    action opahf60() {memopa = p.hdr.hf_60;}
    action opahf61() {memopa = p.hdr.hf_61;}
    action opahf62() {memopa = p.hdr.hf_62;}
    action opahf63() {memopa = p.hdr.hf_63;}

    action opauf0() {memopa = user_metadata.um_0;}
    action opauf1() {memopa = user_metadata.um_1;}
    action opauf2() {memopa = user_metadata.um_2;}
    action opauf3() {memopa = user_metadata.um_3;}
    action opauf4() {memopa = user_metadata.um_4;}
    action opauf5() {memopa = user_metadata.um_5;}
    action opauf6() {memopa = user_metadata.um_6;}
    action opauf7() {memopa = user_metadata.um_7;}
    action opauf8() {memopa = user_metadata.um_8;}
    action opauf9() {memopa = user_metadata.um_9;}
    action opauf10() {memopa = user_metadata.um_10;}
    action opauf11() {memopa = user_metadata.um_11;}
    action opauf12() {memopa = user_metadata.um_12;}
    action opauf13() {memopa = user_metadata.um_13;}
    action opauf14() {memopa = user_metadata.um_14;}
    action opauf15() {memopa = user_metadata.um_15;}
    action opauf16() {memopa = user_metadata.um_16;}
    action opauf17() {memopa = user_metadata.um_17;}
    action opauf18() {memopa = user_metadata.um_18;}
    action opauf19() {memopa = user_metadata.um_19;}
    action opauf20() {memopa = user_metadata.um_20;}
    action opauf21() {memopa = user_metadata.um_21;}
    action opauf22() {memopa = user_metadata.um_22;}
    action opauf23() {memopa = user_metadata.um_23;}

    action opamdrop() {memopa = sume_metadata.drop;}
    action opamdstprt() {memopa = sume_metadata.dst_port;}
    action opamsrcprt() {memopa = sume_metadata.src_port;}
    action opampktlen() {memopa = sume_metadata.pkt_len[7:0];}
    action opamf0() {memopa = sume_metadata.meta_0;}
    action opamf1() {memopa = sume_metadata.meta_1;}
    action opamf2() {memopa = sume_metadata.meta_2;}
    action opamf3() {memopa = sume_metadata.meta_3;}
    action opamf4() {memopa = sume_metadata.meta_4;}
    action opamf5() {memopa = sume_metadata.meta_5;}
    action opamf6() {memopa = sume_metadata.meta_6;}
    action opamf7() {memopa = sume_metadata.meta_7;}
    action opamf8() {memopa = sume_metadata.meta_8;}
    action opamf9() {memopa = sume_metadata.meta_9;}
    action opamf10() {memopa = sume_metadata.meta_10;}
    action opamf11() {memopa = sume_metadata.meta_11;}
    action opamf12() {memopa = sume_metadata.meta_12;}
    action opamf13() {memopa = sume_metadata.meta_13;}
    action opamf14() {memopa = sume_metadata.meta_14;}
    action opamf15() {memopa = sume_metadata.meta_15;}

    // OPA
    table opa {
        key = {keyopa: exact;}

        actions = {
            opahf0;
            opahf1;
            opahf2;
            opahf3;
            opahf4;
            opahf5;
            opahf6;
            opahf7;
            opahf8;
            opahf9;
            opahf10;
            opahf11;
            opahf12;
            opahf13;
            opahf14;
            opahf15;
            opahf16;
            opahf17;
            opahf18;
            opahf19;
            opahf20;
            opahf21;
            opahf22;
            opahf23;
            opahf24;
            opahf25;
            opahf26;
            opahf27;
            opahf28;
            opahf29;
            opahf30;
            opahf31;
            opahf32;
            opahf33;
            opahf34;
            opahf35;
            opahf36;
            opahf37;
            opahf38;
            opahf39;
            opahf40;
            opahf41;
            opahf42;
            opahf43;
            opahf44;
            opahf45;
            opahf46;
            opahf47;
            opahf48;
            opahf49;
            opahf50;
            opahf51;
            opahf52;
            opahf53;
            opahf54;
            opahf55;
            opahf56;
            opahf57;
            opahf58;
            opahf59;
            opahf60;
            opahf61;
            opahf62;
            opahf63;

            opauf0;
            opauf1;
            opauf2;
            opauf3;
            opauf4;
            opauf5;
            opauf6;
            opauf7;
            opauf8;
            opauf9;
            opauf10;
            opauf11;
            opauf12;
            opauf13;
            opauf14;
            opauf15;
            opauf16;
            opauf17;
            opauf18;
            opauf19;
            opauf20;
            opauf21;
            opauf22;
            opauf23;

            opamdrop;
            opamdstprt;
            opamsrcprt;
            opampktlen;
            opamf0;
            opamf1;
            opamf2;
            opamf3;
            opamf4;
            opamf5;
            opamf6;
            opamf7;
            opamf8;
            opamf9;
            opamf10;
            opamf11;
            opamf12;
            opamf13;
            opamf14;
            opamf15;

            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    // ACTIONs
    action opbhf0() {memopb = p.hdr.hf_0;}
    action opbhf1() {memopb = p.hdr.hf_1;}
    action opbhf2() {memopb = p.hdr.hf_2;}
    action opbhf3() {memopb = p.hdr.hf_3;}
    action opbhf4() {memopb = p.hdr.hf_4;}
    action opbhf5() {memopb = p.hdr.hf_5;}
    action opbhf6() {memopb = p.hdr.hf_6;}
    action opbhf7() {memopb = p.hdr.hf_7;}
    action opbhf8() {memopb = p.hdr.hf_8;}
    action opbhf9() {memopb = p.hdr.hf_9;}
    action opbhf10() {memopb = p.hdr.hf_10;}
    action opbhf11() {memopb = p.hdr.hf_11;}
    action opbhf12() {memopb = p.hdr.hf_12;}
    action opbhf13() {memopb = p.hdr.hf_13;}
    action opbhf14() {memopb = p.hdr.hf_14;}
    action opbhf15() {memopb = p.hdr.hf_15;}
    action opbhf16() {memopb = p.hdr.hf_16;}
    action opbhf17() {memopb = p.hdr.hf_17;}
    action opbhf18() {memopb = p.hdr.hf_18;}
    action opbhf19() {memopb = p.hdr.hf_19;}
    action opbhf20() {memopb = p.hdr.hf_20;}
    action opbhf21() {memopb = p.hdr.hf_21;}
    action opbhf22() {memopb = p.hdr.hf_22;}
    action opbhf23() {memopb = p.hdr.hf_23;}
    action opbhf24() {memopb = p.hdr.hf_24;}
    action opbhf25() {memopb = p.hdr.hf_25;}
    action opbhf26() {memopb = p.hdr.hf_26;}
    action opbhf27() {memopb = p.hdr.hf_27;}
    action opbhf28() {memopb = p.hdr.hf_28;}
    action opbhf29() {memopb = p.hdr.hf_29;}
    action opbhf30() {memopb = p.hdr.hf_30;}
    action opbhf31() {memopb = p.hdr.hf_31;}
    action opbhf32() {memopb = p.hdr.hf_32;}
    action opbhf33() {memopb = p.hdr.hf_33;}
    action opbhf34() {memopb = p.hdr.hf_34;}
    action opbhf35() {memopb = p.hdr.hf_35;}
    action opbhf36() {memopb = p.hdr.hf_36;}
    action opbhf37() {memopb = p.hdr.hf_37;}
    action opbhf38() {memopb = p.hdr.hf_38;}
    action opbhf39() {memopb = p.hdr.hf_39;}
    action opbhf40() {memopb = p.hdr.hf_40;}
    action opbhf41() {memopb = p.hdr.hf_41;}
    action opbhf42() {memopb = p.hdr.hf_42;}
    action opbhf43() {memopb = p.hdr.hf_43;}
    action opbhf44() {memopb = p.hdr.hf_44;}
    action opbhf45() {memopb = p.hdr.hf_45;}
    action opbhf46() {memopb = p.hdr.hf_46;}
    action opbhf47() {memopb = p.hdr.hf_47;}
    action opbhf48() {memopb = p.hdr.hf_48;}
    action opbhf49() {memopb = p.hdr.hf_49;}
    action opbhf50() {memopb = p.hdr.hf_50;}
    action opbhf51() {memopb = p.hdr.hf_51;}
    action opbhf52() {memopb = p.hdr.hf_52;}
    action opbhf53() {memopb = p.hdr.hf_53;}
    action opbhf54() {memopb = p.hdr.hf_54;}
    action opbhf55() {memopb = p.hdr.hf_55;}
    action opbhf56() {memopb = p.hdr.hf_56;}
    action opbhf57() {memopb = p.hdr.hf_57;}
    action opbhf58() {memopb = p.hdr.hf_58;}
    action opbhf59() {memopb = p.hdr.hf_59;}
    action opbhf60() {memopb = p.hdr.hf_60;}
    action opbhf61() {memopb = p.hdr.hf_61;}
    action opbhf62() {memopb = p.hdr.hf_62;}
    action opbhf63() {memopb = p.hdr.hf_63;}

    action opbuf0() {memopb = user_metadata.um_0;}
    action opbuf1() {memopb = user_metadata.um_1;}
    action opbuf2() {memopb = user_metadata.um_2;}
    action opbuf3() {memopb = user_metadata.um_3;}
    action opbuf4() {memopb = user_metadata.um_4;}
    action opbuf5() {memopb = user_metadata.um_5;}
    action opbuf6() {memopb = user_metadata.um_6;}
    action opbuf7() {memopb = user_metadata.um_7;}
    action opbuf8() {memopb = user_metadata.um_8;}
    action opbuf9() {memopb = user_metadata.um_9;}
    action opbuf10() {memopb = user_metadata.um_10;}
    action opbuf11() {memopb = user_metadata.um_11;}
    action opbuf12() {memopb = user_metadata.um_12;}
    action opbuf13() {memopb = user_metadata.um_13;}
    action opbuf14() {memopb = user_metadata.um_14;}
    action opbuf15() {memopb = user_metadata.um_15;}
    action opbuf16() {memopb = user_metadata.um_16;}
    action opbuf17() {memopb = user_metadata.um_17;}
    action opbuf18() {memopb = user_metadata.um_18;}
    action opbuf19() {memopb = user_metadata.um_19;}
    action opbuf20() {memopb = user_metadata.um_20;}
    action opbuf21() {memopb = user_metadata.um_21;}
    action opbuf22() {memopb = user_metadata.um_22;}
    action opbuf23() {memopb = user_metadata.um_23;}

    action opbmdrop() {memopb = sume_metadata.drop;}
    action opbmdstprt() {memopb = sume_metadata.dst_port;}
    action opbmsrcprt() {memopb = sume_metadata.src_port;}
    action opbmpktlen() {memopb = sume_metadata.pkt_len[7:0];}
    action opbmf0() {memopb = sume_metadata.meta_0;}
    action opbmf1() {memopb = sume_metadata.meta_1;}
    action opbmf2() {memopb = sume_metadata.meta_2;}
    action opbmf3() {memopb = sume_metadata.meta_3;}
    action opbmf4() {memopb = sume_metadata.meta_4;}
    action opbmf5() {memopb = sume_metadata.meta_5;}
    action opbmf6() {memopb = sume_metadata.meta_6;}
    action opbmf7() {memopb = sume_metadata.meta_7;}
    action opbmf8() {memopb = sume_metadata.meta_8;}
    action opbmf9() {memopb = sume_metadata.meta_9;}
    action opbmf10() {memopb = sume_metadata.meta_10;}
    action opbmf11() {memopb = sume_metadata.meta_11;}
    action opbmf12() {memopb = sume_metadata.meta_12;}
    action opbmf13() {memopb = sume_metadata.meta_13;}
    action opbmf14() {memopb = sume_metadata.meta_14;}
    action opbmf15() {memopb = sume_metadata.meta_15;}

    // OPB
    table opb {
        key = {keyopb: exact;}

        actions = {
            opbhf0;
            opbhf1;
            opbhf2;
            opbhf3;
            opbhf4;
            opbhf5;
            opbhf6;
            opbhf7;
            opbhf8;
            opbhf9;
            opbhf10;
            opbhf11;
            opbhf12;
            opbhf13;
            opbhf14;
            opbhf15;
            opbhf16;
            opbhf17;
            opbhf18;
            opbhf19;
            opbhf20;
            opbhf21;
            opbhf22;
            opbhf23;
            opbhf24;
            opbhf25;
            opbhf26;
            opbhf27;
            opbhf28;
            opbhf29;
            opbhf30;
            opbhf31;
            opbhf32;
            opbhf33;
            opbhf34;
            opbhf35;
            opbhf36;
            opbhf37;
            opbhf38;
            opbhf39;
            opbhf40;
            opbhf41;
            opbhf42;
            opbhf43;
            opbhf44;
            opbhf45;
            opbhf46;
            opbhf47;
            opbhf48;
            opbhf49;
            opbhf50;
            opbhf51;
            opbhf52;
            opbhf53;
            opbhf54;
            opbhf55;
            opbhf56;
            opbhf57;
            opbhf58;
            opbhf59;
            opbhf60;
            opbhf61;
            opbhf62;
            opbhf63;

            opbuf0;
            opbuf1;
            opbuf2;
            opbuf3;
            opbuf4;
            opbuf5;
            opbuf6;
            opbuf7;
            opbuf8;
            opbuf9;
            opbuf10;
            opbuf11;
            opbuf12;
            opbuf13;
            opbuf14;
            opbuf15;
            opbuf16;
            opbuf17;
            opbuf18;
            opbuf19;
            opbuf20;
            opbuf21;
            opbuf22;
            opbuf23;

            opbmdrop;
            opbmdstprt;
            opbmsrcprt;
            opbmpktlen;
            opbmf0;
            opbmf1;
            opbmf2;
            opbmf3;
            opbmf4;
            opbmf5;
            opbmf6;
            opbmf7;
            opbmf8;
            opbmf9;
            opbmf10;
            opbmf11;
            opbmf12;
            opbmf13;
            opbmf14;
            opbmf15;

            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    //************************************************
    // OPER
    //************************************************

    // ACTIONs
    action aEQb() {memoper = (7w0) ++ (bit<1>)(memopa == memopb); index=4w0;}
    action aNEQb() {memoper = (7w0) ++ (bit<1>)(memopa != memopb); index=4w1;}
    action aGTb() {memoper = (7w0) ++ (bit<1>)(memopa > memopb); index=4w2;}
    action aGTEb() {memoper = (7w0) ++ (bit<1>)(memopa >= memopb); index=4w3;}
    action aLTb() {memoper = (7w0) ++ (bit<1>)(memopa < memopb); index=4w4;}
    action aLTEb() {memoper = (7w0) ++ (bit<1>)(memopa <= memopb); index=4w5;}
    action aSUMb() {memoper = memopa + memopb; index=4w6;}
    action aSUBb() {memoper = memopa - memopb; index=4w7;}
    action aANDb() {memoper = memopa & memopb; index=4w8;}
    action aORb() {memoper = memopa | memopb; index=4w9;}
    action aXORb() {memoper = memopa ^ memopb; index=4w10;}

    // OPER
    table oper {
        key = {keyoper: exact;}

        actions = {
            aEQb;
            aNEQb;
            aGTb;
            aGTEb;
            aLTb;
            aLTEb;
            aSUMb;
            aSUBb;
            aANDb;
            aORb;
            aXORb;
            NoAction;
        }

        size = 64;
        default_action = NoAction;
    }

    //************************************************
    // MATCH / ACTION FLOW
    //************************************************
    apply {

        // OPA
        opa.apply();

        // OPB
        opb.apply();

        // OPER
        oper.apply();

    } // apply

} // control

#endif
