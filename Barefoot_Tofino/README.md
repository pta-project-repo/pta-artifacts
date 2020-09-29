# PTA

### Architecture

The setup includes three Barefoot Tofino switches and a manager (mgr) computer.
The manager is interfaced to the three switches through a standard ethernet network. Both local and remote connections are supported.
The three switches are directly connected through SFP+/QSFP+ cables, as shown in figure "DPV_3_Switches.png" in "docs" folder.
Each switch implements a different role: test packet generator (tpg), program under test (put) and output packet checker (opc).
Each device in the setup has a copy of the PTA repo.
All the operations run over SSH connection, through "tmux" sessions.
Each device must be able to connect to the others through SSH, without passwords. 

### Add the following lines to the ".profile" file of each device included in the setup (both switches and manager computer)

export DPV_NAME="ROLE: mgr/tpg/put/opc"
export DPV_USR="USERNAME"
export REPO="PATH_TO_PTA_FOLDER"
source $REPO/scripts/settings.sh

### Place the P4_14 annotated code to be tested in the "put" folder, on the manager computer

See the example code provided in the repo, which is already included in the "put" folder.
The framework expects a single P4_14 file, annotated with P4v pragmas, a port configuration file for Barefoot Tofino and a python control plane script, that leverages ptf tests.

### Run command "rt_dpv" on the manager computer

The command connects to the three switches, automatically generates the test code, based on P4v annotations, compiles the code, loads the programs on the switches, runs the test and prints the final results.