import pd_base_tests
from ptf import config
from ptf.testutils import *
from ptf.thriftutils import *
from res_pd_rpc.ttypes import *
from put.p4_pd_rpc.ttypes import *

class wr_tables(pd_base_tests.ThriftInterfaceDataPlane):
    def __init__(self):
        pd_base_tests.ThriftInterfaceDataPlane.__init__(self, ["put"])

    def setUp(self):
        pd_base_tests.ThriftInterfaceDataPlane.setUp(self)

        self.sess_hdl = self.conn_mgr.client_init()
        self.dev      = 0
        self.dev_tgt  = DevTarget_t(self.dev, hex_to_i16(0xFFFF))

        print("\nConnected to Device %d, Session %d" % (
            self.dev, self.sess_hdl))

    def runTest(self):

        # Test Parameters
        cpu_port  = 192
        sw_port  = 28
        mac_a       = "AA:AA:AA:AA:AA:AA"
        mac_b       = "BB:BB:BB:BB:BB:BB"

        print("Populating table entries")

        # self.entries dictionary will contain all installed entry handles
        self.entries={}

        # table names
        self.entries["forward"] = []

        # *** FORWARD TABLE:

        # add one line
        self.entries["forward"].append(
            self.client.forward_table_add_with_set_egr(
                self.sess_hdl, self.dev_tgt,
                put_forward_match_spec_t(
                    ethernet_dstAddr=macAddr_to_string(mac_a)),
                put_set_egr_action_spec_t(
                    action_egress_spec=cpu_port)))

        # add one line
        self.entries["forward"].append(
            self.client.forward_table_add_with_set_egr(
                self.sess_hdl, self.dev_tgt,
                put_forward_match_spec_t(
                    ethernet_dstAddr=macAddr_to_string(mac_b)),
                put_set_egr_action_spec_t(
                    action_egress_spec=sw_port)))

        # print written lines
        print("Table forward: %s => set_egr(%d)" % (mac_a, cpu_port))
        print("Table forward: %s => set_egr(%d)" % (mac_b, sw_port))

        # complete operations
        self.conn_mgr.complete_operations(self.sess_hdl)

    # Use this method to return the DUT to the initial state by cleaning
    # all the configuration and clearing up the connection
    def tearDown(self):
        try:
            print("Clearing table entries")
            for table in self.entries.keys():
                delete_func = "self.client." + table + "_table_delete"
                for entry in self.entries[table]:
                    print("")
                    # exec delete_func + "(self.sess_hdl, self.dev, entry)"
        except:
            print("Error while cleaning up. ")
            print("You might need to restart the driver")
        finally:
            self.conn_mgr.complete_operations(self.sess_hdl)
            self.conn_mgr.client_cleanup(self.sess_hdl)
            print("Closed Session %d" % self.sess_hdl)
            pd_base_tests.ThriftInterfaceDataPlane.tearDown(self)
