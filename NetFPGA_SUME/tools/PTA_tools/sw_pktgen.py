#!/usr/bin/env python

import os, sys, getopt
from scapy.all import *

print("\n--------------------------\nWORKING WITH PYTHON 3.7.3\n--------------------------\n")

############################
# Class: CustomProtocol
# BitField(<field_name>, <default_value>, <length_[bits]>),
############################  
class Custom1(Packet):
    fields_desc = [
                    XBitField("field1", None, (16*8)),
                    XBitField("field2", None, (16*8)),
                    XBitField("field3", None, (16*8)),
                    XBitField("field4", None, (16*8)),
                    XBitField("field5", None, (16*8)),
                  ]
 
############################
# Function: main
############################
# TODO:
# - write to PCAP file
# - arguments provided by user:
    # - packet size
    # - number of packets
    # - use default values
    # - send or write pcap, or both
    # - output file
    # - output interface

def main(argv):
   outputfile = 'pktgen.pcap'
   print ('Output file is: ', outputfile, '\n')
   
   # GENERATE PAYLOAD
   payload = "ABCDEFFEDCBA"
   
   # BUILD PACKET
   p = Ether() / Custom1() / bytes.fromhex(payload)
   
   # POPULATE HEADERS
   p[Custom1].field1 = 0xAA0033445566778899FFFF0033445566
   p[Custom1].field2 = 0xAA0033445566778899FFFF0033445566
   p[Custom1].field3 = 0xAA0033445566778899FFFF0033445566
   p[Custom1].field4 = 0xAA0033445566778899FFFF0033445566
   p[Custom1].field5 = 0xAA0033445566778899FFFF0033445566
   
   # SHOW PACKET
   # ls(p)
   p.show()
   
   # WRITE PCAP
   # queue = []
   # queue.append(p)
   # scapy.wrpcap(outputfile, queue)
   
   # SEND PACKET 
   sendp(p,iface='bridge0')

if __name__ == "__main__":
   main(sys.argv[1:])
