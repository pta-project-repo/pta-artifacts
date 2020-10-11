# PTA on NetFPGA SUME

## Software requirements

1. OS: Ubuntu 16.04.5 LTS

2. Compiler: Xilinx Vivado 2018.2

3. Compiler: Xilinx SDNet 2018.2

## Installation Prerequisites 

### Setup the NetFPGA SUME Framework

https://github.com/NetFPGA/NetFPGA-SUME-public/wiki

### Setup P4->NetFPGA

https://github.com/NetFPGA/P4-NetFPGA-public/wiki



## Configuring PTA - First Time Only

Locate file "sume_switch.p4" inside SDNet's install dir, e.g.:

```
/opt/Xilinx/SDNet/2018.2/data/p4include/sume_switch.p4
```

Replace:

```
/* standard sume switch metadata */
/*struct sume_metadata_t {
    bit<16> dma_q_size; // measured in 32-byte words
    bit<16> nf3_q_size; // measured in 32-byte words
    bit<16> nf2_q_size; // measured in 32-byte words
    bit<16> nf1_q_size; // measured in 32-byte words
    bit<16> nf0_q_size; // measured in 32-byte words
    bit<8> send_dig_to_cpu; // send digest_data to CPU
    bit<8> drop;
    port_t dst_port; // one-hot encoded: {DMA, NF3, DMA, NF2, DMA, NF1, DMA, NF0}
    port_t src_port; // one-hot encoded: {DMA, NF3, DMA, NF2, DMA, NF1, DMA, NF0}
    bit<16> pkt_len; // unsigned int
}*/
```

With:

```
/* EXTENDED sume switch metadata [256b] */
struct sume_metadata_t {
    bit<16> dma_q_size; // measured in 32-byte words
    bit<16> nf3_q_size; // measured in 32-byte words
    bit<16> nf2_q_size; // measured in 32-byte words
    bit<16> nf1_q_size; // measured in 32-byte words
    bit<16> nf0_q_size; // measured in 32-byte words
    bit<8> send_dig_to_cpu; // send digest_data to CPU
    bit<8> drop;
    port_t dst_port; // one-hot encoded: {DMA, NF3, DMA, NF2, DMA, NF1, DMA, NF0}
    port_t src_port; // one-hot encoded: {DMA, NF3, DMA, NF2, DMA, NF1, DMA, NF0}
    bit<16> pkt_len; // unsigned int
    bit<8> meta_0;
    bit<8> meta_1;
    bit<8> meta_2;
    bit<8> meta_3;
    bit<8> meta_4;
    bit<8> meta_5;
    bit<8> meta_6;
    bit<8> meta_7;
    bit<8> meta_8;
    bit<8> meta_9;
    bit<8> meta_10;
    bit<8> meta_11;
    bit<8> meta_12;
    bit<8> meta_13;
    bit<8> meta_14;
    bit<8> meta_15;
}
```

Locate file "PTA.sh" inside the repository's tools folder:

```
<PATH TO PTA REPO>/tools/PTA_tools/PTA.sh
```

Edit the file, by changing line 43:

```
export SUME_FOLDER=<PATH TO PTA REPO>
```

source "PTA.sh"

## Create, Edit and Run a Test 

### step 1: Edit Framework

The following are the hardware components of the framework. They don't need to be modified for reproducibility purposes, but one may wish to modify them for different designs.

Tested program (data plane, table entries):

```
$P4_PROJECT_DIR/ppl_src/ppl_p4.p4
$P4_PROJECT_DIR/ppl_src/cmds.txt
```

Packet generator (data plane, table entries):

```
$P4_PROJECT_DIR/dbg_src/ppl_p4.p4
$P4_PROJECT_DIR/dbg_src/cmds.txt
```

Packet checker (data plane, table entries):

```
$P4_PROJECT_DIR/ver_src/ppl_p4.p4
$P4_PROJECT_DIR/ver_src/cmds.txt
```

### Step 2: Edit test script

The following is the test script of the framework. It doesn't need to be modified for reproducibility purposes, but one may wish to modify it for different tests.

```
$P4_PROJECT_DIR/tests/test_gen.py
```

### Step 3: Compile PTA

Compile library (needs to be compiled only when first installed):

```
cd $SUME_FOLDER
make
```

Compile P4 IP cores (needs to be compiled only when P4 source code is modified and when first installed):

```
cd $P4_PROJECT_DIR
make
```

Compile FPGA project (needs to be compiled only when P4 source code is modified and when first installed):

```
cd simple_sume_switch
make
```

### Step 4: Run PTA

Program switch and tables. Run command:

```
progswitch
```

Run test:

```
python $P4_PROJECT_DIR/tests/test_gen.py
```

Command for generating test packets in hardware:

```
genpkts --help
```

## Folder stucture

1. contrib-projects/sume-sdnet-switch - P4-NetFPGA source coude

2. examples - An example of PTA test script

3. lib - NetFPGA libraries created, modified or tested by PTA

4. test_results - Examples of test results logs from several test cases

5. tools - PTA software tools and related NetFPGA scripts
