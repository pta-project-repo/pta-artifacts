#include <core.p4>
#include <sume_switch.p4>

#include "dataplane/externs.p4"
#include "dataplane/header.p4"
#include "dataplane/metadata.p4"
#include "dataplane/parser.p4"
#include "dataplane/alu.p4"
#include "dataplane/cam.p4"
#include "dataplane/tcam.p4"
#include "dataplane/pipe.p4"
#include "dataplane/deparser.p4"

////////////////////////////////////////////////////////////////////////////////
///                        SWITCH INSTANCE
////////////////////////////////////////////////////////////////////////////////

SimpleSumeSwitch(

        TopParser(),
        TopPipe(),
        TopDeparser()

    ) main;
