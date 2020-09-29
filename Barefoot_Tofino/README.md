# PTA

### Setup the NetFPGA SUME Framework

https://github.com/NetFPGA/NetFPGA-SUME-public/wiki

### Setup P4->NetFPGA

https://github.com/NetFPGA/P4-NetFPGA-public/wiki

### Software requirements

OS: Ubuntu 16.04.5 LTS

Compiler: Xilinx Vivado 2018.2

Compiler: Xilinx SDNet 2018.2

### Configuring PTA

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

### Edit framework

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

### Edit test script

```
$P4_PROJECT_DIR/tests/test_gen.py
```

### Compiling PTA

Compile library:

```
cd $SUME_FOLDER
make
```

Compile P4 IP cores:

```
cd $P4_PROJECT_DIR
make
```

Compile FPGA project:

```
cd simple_sume_switch
make
```

### Running PTA

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
