#include "./include/headers.p4"
#include <tofino/intrinsic_metadata.p4>
#include <tofino/constants.p4>

// PORTS
#define CPU_PORT 192
#define SW_PORT 28 // PORT 20
#define DEFAULT_PORT SW_PORT

parser start {
  extract(h);
  return ingress;
}

// @DPV put setdstport begin
//  *** SET DESTINATION PORT
action set_dstport(dstport) {
    modify_field(ig_intr_md_for_tm.ucast_egress_port, dstport);
}
table tbl_dstport {
    actions {
        set_dstport;
    }
    default_action: set_dstport(DEFAULT_PORT);
    size : 1;
}
// @DPV put setdstport end


action nop() { }

action a1() {
    subtract_from_field(h.s, 3);
    subtract_from_field(h.s2, h.s3);
    subtract_from_field(h.s4, 18);
    add_to_field(h.s5, 18);
    add_to_field(h.s6, h.s7);
}

table t1 {
  reads { h.s : exact; }
  actions {
    a1;
  }
  default_action : a1;
}

control ingress {
  @pragma assume(h.s == 2)
  @pragma assume(h.s2 == 4 && h.s2 >= h.s3)
  @pragma assume(h.s5 == 3)
  @pragma assume(h.s6 == 3)
  @pragma assume(h.s6 <= h.s7)
  apply(t1);
  @pragma assert(h.s == 0b111)
  @pragma assert(h.s2 <= 4)
  @pragma assert(h.s4 == 0b100)
  @pragma assert(h.s5 >= 3)
  @pragma assert(h.s6 >= 3)

  // @DPV put app_dstport begin
  apply(tbl_dstport);
  // @DPV put app_dstport end
}
