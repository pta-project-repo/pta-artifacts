#!/bin/bash
##
##
## Copyright (c) 2018 -
## All rights reserved.
##
## @NETFPGA_LICENSE_HEADER_START@
##
## Licensed to NetFPGA C.I.C. (NetFPGA) under one or more contributor
## license agreements.  See the NOTICE file distributed with this work for
## additional information regarding copyright ownership.  NetFPGA licenses this
## file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
## "License"); you may not use this file except in compliance with the
## License.  You may obtain a copy of the License at:
##
##   http://www.netfpga-cic.org
##
## Unless required by applicable law or agreed to in writing, Work distributed
## under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
## CONDITIONS OF ANY KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations under the License.
##
## @NETFPGA_LICENSE_HEADER_END@
##

##################### TOOLS
TOOLS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RWAXI=${SUME_FOLDER}/lib/sw/std/apps/sume_riffa_v1_0_0

##################### ADDRESSES
BA=0x440900
BURST=24
GAP=28
SIZE=20
KEEP=2C
TRIGGER=1C
FLAGS=30
META1=34
META2=38
META3=3C
META4=40
META5=44
META6=48
META7=4C
META8=50
META9=54
META10=58
META11=5C
META12=60
META13=64
META14=68
META15=6C

##################### DEFAULT VALUES
BURSTLEN=1000
GAPLEN=D-100
PKTSIZE=256
HDRSIZE=34 # eth + ip
VALFLAGS=0
declare -a META=("I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0" "I-0")
declare -a VALMETA=("0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0")

###############################################################
###			CHECKING FOR HELP PARAMETER
###############################################################

if [[ "$1" == "-h" || "$1" == "--h" || "$1" == "-help" || "$1" == "--help" ]]; then
  echo "Usage: `basename $0`:"
  echo ""
  echo "(-h), (--h), (-help), (--help) print usage info"
  echo ""
  echo "(-b) burst length [# of packets] (DEFAULT: 1000)"
  echo "(-f) flags [8b value]: |na|-|na|-|na|-|na|-|na|-|na|-|na|-|na| ==> MORE INFO: (--hf)"
  echo "(-g) gap limit type (Whole Design [D] or Pipeline Under Test [P]) & gap length [# of cycles], separated by a dash (DEFAULT: D-100)"
  echo "(-p) packet size [# of bytes] (DEFAULT: 256, min: 64, MAX: 1514)"
  echo "(-s) header size(P4 module) [# of bytes] (DEFAULT: 34)"
  echo "(--m1~15) data type (Int [I], Bin[B] or Hex[H]) & metada [8b value], separated by a dash (DEFAULT: I-0)"
  echo ""
  echo "EXAMPLE USAGE: genpkts -b 100 -g D-100 -p 64 -s 34"
  echo ""
  exit 0
fi

###############################################################
###			GETTING INPUT PARAMETERS
###############################################################

while true; do
  case "$1" in
    -b) BURSTLEN="$2"; shift; shift ;;
    -f) VALFLAGS="$2"; shift; shift ;;
    -g) GAPLEN="$2"; shift; shift ;;
    -p) PKTSIZE="$2"; shift; shift ;;
    -s) HDRSIZE="$2"; shift; shift ;;
    --m1) META[1]="$2"; shift; shift ;;
    --m2) META[2]="$2"; shift; shift ;;
    --m3) META[3]="$2"; shift; shift ;;
    --m4) META[4]="$2"; shift; shift ;;
    --m5) META[5]="$2"; shift; shift ;;
    --m6) META[6]="$2"; shift; shift ;;
    --m7) META[7]="$2"; shift; shift ;;
    --m8) META[8]="$2"; shift; shift ;;
    --m9) META[9]="$2"; shift; shift ;;
    --m10) META[10]="$2"; shift; shift ;;
    --m11) META[11]="$2"; shift; shift ;;
    --m12) META[12]="$2"; shift; shift ;;
    --m13) META[13]="$2"; shift; shift ;;
    --m14) META[14]="$2"; shift; shift ;;
    --m15) META[15]="$2"; shift; shift ;;
    --hf) echo "";
      echo "MORE INFO ABOUT FLAGS:";
      echo "";
      echo "|x|x|x|x|x|x|x|x| (DEFAULT: 00000000)";
      echo " 7 6 5 4 3 2 1 0";
      echo "";
      echo "[0:0] --> not assigned";
      echo "[1:1] --> not assigned";
      echo "[2:2] --> not assigned";
      echo "[3:3] --> not assigned";
      echo "[4:4] --> not assigned";
      echo "[5:5] --> not assigned";
      echo "[6:6] --> not assigned";
      echo "[7:7] --> not assigned";
      echo "";
      shift; shift; exit 0 ;;
    * ) break ;;
  esac
done

###############################################################
###               SET FLAGS
### TODO: reserve M1 & M2 to metadata src & dst ports
### user specifies ports as: NF0, NF3, BRA, BR0, BR3, DMA, ...
###############################################################

cd ${TOOLS_DIR}

echo > flags.txt

# Compute FLAGS, passing VALFLAGS to a python script
python ${TOOLS_DIR}/set_flags.py ${VALFLAGS}

SETFLAGS=( $(<flags.txt) )

# DEBUG
# echo ""
# echo ""
# echo '@@@@@@@@@ FLAGS @@@@@@@@@@'
# echo ${VALFLAGS}
# echo ${SETFLAGS}
# exit 1

echo ""
echo ""

cd ${RWAXI}

###############################################################
###     	COMPUTE IPGGAP

### TODO: make it flexible, being able to generate specific
### throughput by changing the gap while generating a sequence
### of packets

### TODO: make it flexible, being able to avoid buffer
### saturation in the output queues, depending on the length
### of the test sequence and on the size of the packets
###############################################################

# PAYLOAD SIZE
PAYSIZE=$((PKTSIZE - HDRSIZE))

# ---------------------------
#    CYCLES FOR IPG MODULE
# ---------------------------

# IPG: NUMBER OF 256b CHUNKS
IPGPKTCYC=$((PAYSIZE / 32 ))

# IPG: REMAINDER
TEMPMOD=$((PAYSIZE % 32 ))

# IPG: ONE ADDITIONAL CYCLE IF REMAINDER IS NOT NULL
if [ "$TEMPMOD" != "0" ]; then
IPGPKTCYC=$((IPGPKTCYC + 1))
fi

# ---------------------------
#    CYCLES FOR DBG MODULE
# ---------------------------

# DBG: NUMBER OF 256b CHUNKS
DBGPKTCYC=$((PKTSIZE / 32 ))

# DBG: REMAINDER
TEMPMOD=$((PKTSIZE % 32 ))

# DBG: ONE ADDITIONAL CYCLE IF REMAINDER IS NOT NULL
if [ "$TEMPMOD" != "0" ]; then
DBGPKTCYC=$((DBGPKTCYC + 1))
fi

# ---------------------------------
#  MIN GAP FOR WHOLE DESIGN
# ---------------------------------

TMP=$((PKTSIZE + 20))
TEMPMOD=$((TMP % 25))
DESGAPMIN=$((TMP / 25))

if [ "$TEMPMOD" != "0" ]; then
DESGAPMIN=$((DESGAPMIN + 1))
fi

TMP=$((DESGAPMIN - IPGPKTCYC))
DESGAPMIN=${TMP}

# ---------------------------------
#  MIN GAP FOR PIPELINE UNDER TEST
# ---------------------------------

PIPGAPMIN=$((DBGPKTCYC - IPGPKTCYC))

# ---------------------------
#    PARSE REQUESTED GAP
# ---------------------------

REQGAPTYPE=$(echo $GAPLEN | cut -f1 -d-)
REQGAPLEN=$(echo $GAPLEN | cut -f2 -d-)

# CHOOSE GAP TYPE & CHECK MINIMUM GAP
if [[ "$REQGAPTYPE" == "D" || "$REQGAPTYPE" == "d" ]]; then

  if [[ "$REQGAPLEN" -lt "$DESGAPMIN" ]]; then
    echo "ERROR: REQUESTED GAP LENGTH IS BELOW MINIMUM!!!"
    echo "REVERTING TO MINIMUM"
    IPGGAP=${DESGAPMIN}
  else
    IPGGAP=${REQGAPLEN}
  fi

elif [[ "$REQGAPTYPE" == "P" || "$REQGAPTYPE" == "p" ]]; then

  if [[ "$REQGAPLEN" -lt "$PIPGAPMIN" ]]; then
    echo "ERROR: REQUESTED GAP LENGTH IS BELOW MINIMUM!!!"
    echo "REVERTING TO MINIMUM"
    IPGGAP=${PIPGAPMIN}
  else
    IPGGAP=${REQGAPLEN}
  fi

else

  echo "ERROR: REQUESTED GAP TYPE NOT SUPPORTED!!!"
  echo "TERMINATING PACKET GENERATION"
  exit 1

fi

# DEBUG
# echo "REQGAPTYPE: " ${REQGAPTYPE}
# echo "REQGAPLEN: " ${REQGAPLEN}
# echo "DESGAPMIN: " ${DESGAPMIN}
# echo "PIPGAPMIN: " ${PIPGAPMIN}
# echo "IPGGAP: " ${IPGGAP}
# echo ""

###############################################################
###       COMPUTE METADATA FIELDS
###############################################################

for (( index=1; index<16; index++ ));
do

    # PARSE REQUESTED METADATA
    REQMETATYPE=$(echo ${META[index]} | cut -f1 -d-)
    REQMETAVAL=$(echo ${META[index]} | cut -f2 -d-)

    # DEBUG
    # echo "index: " ${index}
    # echo "META[index]"${META[index]}
    # echo "REQMETATYPE: " ${REQMETATYPE}
    # echo "REQMETAVAL: " ${REQMETAVAL}
    # echo ""

  # CHOOSE META TYPE & CONVERT VALUE
  if [[ "$REQMETATYPE" == "I" || "$REQMETATYPE" == "i" ]]; then

    # VALUE ASSIGNED AS IT IS
    VALMETA[$index]=$REQMETAVAL

  elif [[ "$REQMETATYPE" == "B" || "$REQMETATYPE" == "b" ]]; then

    # VALUE CONVERTED TO INT
    VALMETA[$index]=$(echo "ibase=2; ${REQMETAVAL}" | bc)

  elif [[ "$REQMETATYPE" == "H" || "$REQMETATYPE" == "h" ]]; then

    # 0x PREFIX ATTACHED TO VALUE
    VALMETA[$index]=\0\x$REQMETAVAL

  else

    echo "ERROR: REQUESTED METADATA TYPE NOT SUPPORTED!!!"
    echo "TERMINATING PACKET GENERATION"
    exit 1

  fi

done # for loop

###############################################################

###############################################################
###     COMPUTE SIZEINFO
###############################################################

cd ${TOOLS_DIR}

PAYSIZE=$((PKTSIZE - HDRSIZE))

echo > tkeep.txt
echo > sizeinfo.txt

# Compute SIZEINFO & TKEEP, passing PAYSIZE to a python script
python ${TOOLS_DIR}/compute_params.py ${PAYSIZE}

TKEEP=( $(<tkeep.txt) )
SIZEINFO=( $(<sizeinfo.txt) )

# DEBUG
# echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
# echo ${TKEEP}
# echo ${SIZEINFO}
# exit 1

# DEBUG
# echo '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
# echo ${VALMETA[1]}
# echo ${VALMETA[2]}
# echo ${VALMETA[3]}
# echo ${VALMETA[4]}
# echo ${VALMETA[5]}
# echo ${VALMETA[6]}
# echo ${VALMETA[7]}
# echo ${VALMETA[8]}
# echo ${VALMETA[9]}
# echo ${VALMETA[10]}
# echo ${VALMETA[11]}
# echo ${VALMETA[12]}
# echo ${VALMETA[13]}
# echo ${VALMETA[14]}
# echo ${VALMETA[15]}
# exit 1

echo ""
echo ""

###############################################################
###			WRITE REPORT
###############################################################

echo "--------------------------------------------------"
echo "  WRITING REPORT "
echo "--------------------------------------------------"
echo ""
echo ""

cd ${TOOLS_DIR}

echo "BURST" ${BURSTLEN} >> gen_report.txt
echo "GAP" ${IPGGAP} >> gen_report.txt
echo "SIZEINFO" ${SIZEINFO} >> gen_report.txt
echo "TKEEP" ${TKEEP} >> gen_report.txt
echo "-----------------------" >> gen_report.txt

###############################################################
###     WRITE COMMANDS TO IPG
###############################################################

echo "--------------------------------------------------"
echo "  GENERATING PACKETS "
echo "--------------------------------------------------"
echo ""
echo ""

cd ${RWAXI}

echo "******************************"
echo "NUMBER OF PKTS IN A BURST:"
echo ""
./rwaxi -a ${BA}${BURST} -w ${BURSTLEN}

echo "******************************"
echo "GAP BETWEEN PACKETS [CYCLES]:"
echo ""
./rwaxi -a ${BA}${GAP} -w ${IPGGAP}

echo "******************************"
echo "SIZEINFO (CYCLES | SIZE [B]):"
echo ""
./rwaxi -a ${BA}${SIZE} -w ${SIZEINFO}

echo "******************************"
echo "TKEEP SIGNAL [ONE-HOT]:"
echo ""
./rwaxi -a ${BA}${KEEP} -w ${TKEEP}

echo ""
echo ""

echo "******************************"
echo "FLAGS [8b value]:"
echo ""
./rwaxi -a ${BA}${FLAGS} -w ${SETFLAGS}

echo "******************************"
echo "METADATA FIELD 1 [8b value]:"
echo ""
./rwaxi -a ${BA}${META1} -w ${VALMETA[1]}

echo "******************************"
echo "METADATA FIELD 2 [8b value]:"
echo ""
./rwaxi -a ${BA}${META2} -w ${VALMETA[2]}

echo "******************************"
echo "METADATA FIELD 3 [8b value]:"
echo ""
./rwaxi -a ${BA}${META3} -w ${VALMETA[3]}

echo "******************************"
echo "METADATA FIELD 4 [8b value]:"
echo ""
./rwaxi -a ${BA}${META4} -w ${VALMETA[4]}

echo "******************************"
echo "METADATA FIELD 5 [8b value]:"
echo ""
./rwaxi -a ${BA}${META5} -w ${VALMETA[5]}

echo "******************************"
echo "METADATA FIELD 6 [8b value]:"
echo ""
./rwaxi -a ${BA}${META6} -w ${VALMETA[6]}

echo "******************************"
echo "METADATA FIELD 7 [8b value]:"
echo ""
./rwaxi -a ${BA}${META7} -w ${VALMETA[7]}

echo "******************************"
echo "METADATA FIELD 8 [8b value]:"
echo ""
./rwaxi -a ${BA}${META8} -w ${VALMETA[8]}

echo "******************************"
echo "METADATA FIELD 9 [8b value]:"
echo ""
./rwaxi -a ${BA}${META9} -w ${VALMETA[9]}

echo "******************************"
echo "METADATA FIELD 10 [8b value]:"
echo ""
./rwaxi -a ${BA}${META10} -w ${VALMETA[10]}

echo "******************************"
echo "METADATA FIELD 11 [8b value]:"
echo ""
./rwaxi -a ${BA}${META11} -w ${VALMETA[11]}

echo "******************************"
echo "METADATA FIELD 12 [8b value]:"
echo ""
./rwaxi -a ${BA}${META12} -w ${VALMETA[12]}

echo "******************************"
echo "METADATA FIELD 13 [8b value]:"
echo ""
./rwaxi -a ${BA}${META13} -w ${VALMETA[13]}

echo "******************************"
echo "METADATA FIELD 14 [8b value]:"
echo ""
./rwaxi -a ${BA}${META14} -w ${VALMETA[14]}

echo "******************************"
echo "METADATA FIELD 15 [8b value]:"
echo ""
./rwaxi -a ${BA}${META15} -w ${VALMETA[15]}

echo ""
echo ""

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "TRIGGER PACKET GENERATION [0 / 1]:"
echo ""
./rwaxi -a ${BA}${TRIGGER} -w 1

###############################################################

cd ${SUME_FOLDER}

echo ""
echo ""

echo "--------------------------------------------------"
echo "	PACKET GENERATION COMPLETE"
echo "--------------------------------------------------"
echo ""

exit 0
