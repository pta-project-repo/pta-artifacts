# PTA on Barefoot Tofino

## Prerequisites

You need to have access to Barefoot SDE and a Tofino switch using P4_14. 

## Setup

The setup includes three Barefoot Tofino switches and a manager (mgr) computer.
The manager is interfaced to the three switches through a standard ethernet network. Both local and remote connections are supported.
The three switches are directly connected through SFP+/QSFP+ cables, as shown in figure "DPV_3_Switches.png" in "docs" folder.
Each switch implements a different role: test packet generator (tpg), program under test (put) and output packet checker (opc).
Each device in the setup has a copy of the PTA repo.
All the operations run over SSH connection, through "tmux" sessions.
Each device must be able to connect to the others through SSH, without passwords. 

### Add the following lines to the ".profile" file of each device included in the setup (both switches and manager computer)

```
export DPV_NAME="ROLE: mgr/tpg/put/opc"
export DPV_USR="USERNAME"
export REPO="PATH_TO_PTA_FOLDER"
source $REPO/scripts/settings.sh
```

## Running a Test

### Step 1: Place the P4_14 annotated code to be tested in the "put" folder, on the manager computer

See "put_example_code" provided in the repo, which is already included in the "doc" folder.
The framework expects a single P4_14 file, annotated with P4v pragmas, a port configuration file for Barefoot Tofino and a python control plane script, that leverages ptf tests.

### Step 2: Run command "rt_dpv" on the manager computer

The command connects to the three switches, automatically generates the test code, based on P4v annotations, compiles the code, loads the programs on the switches, runs the test and prints the final results.

## Folder Stucture

1. docs - includes examples of setup files and an example code of pipeline under test

2. opc - ports configuration for PTA checker

3. p4v-to-dpv - p4v to PTA conversion environment, including scripts and templates

4. put - ports and tables configuration for the pipeline under test

5. scripts - PTA settings scripts

6. tpg - ports configuration for PTA generator
