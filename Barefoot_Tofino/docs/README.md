***
# Example Test Program

We explain the operations of the P4v-to-PTA translator through an example test program, which is similar to the one described in our paper.

## Test Program

The [example test program](put_example_code/data-plane/put.p4) implements a simple P4 pipeline with [one table](put_example_code/data-plane/put.p4#L46) and [one action](put_example_code/data-plane/put.p4#L38), besides [the table-action couple](put_example_code/data-plane/put.p4#L22-32) that sets the destination port to a hard-coded value.
[The parser](put_example_code/data-plane/put.p4#L16-19) extracts the only [header](put_example_code/data-plane/include/headers.p4) known by the program, which includes seven 8b-wide fields.
[The control section](put_example_code/data-plane/put.p4#L54) of the pipeline applies the two tables defined in the program [to process the header fields](put_example_code/data-plane/put.p4#L60) [and to set the destination port](put_example_code/data-plane/put.p4#L68) in the metadata.

We annotated the example test program with P4v assumptions and assertions in the control section.
[Assumptions](put_example_code/data-plane/put.p4#L55-59) provide P4v-to-PTA the input values for the test, i.e. the values used to generate the input test packets. As shown in the example test program, P4v-to-PTA supports both constant values and basic operators to constraint the values assigned to the header fields.
[Assertions](put_example_code/data-plane/put.p4#L61-65) specify the value each header field is expected to have after the completion of the test.

## P4v-to-PTA Architecture

P4v-to-PTA abstracts the target hardware architecture in way which makes it usable at a higher level both to implement and to run test configurations.
The hardware abstraction includes both hardware components, i.e. the metadata bus, and scripts that automate the usage of such components, i.e. accessing registers.
Beside the layout of the metadata bus, [the Barefoot Tofino hardware abstraction](../p4v-to-dpv/templates) covers both test packet generation ("tpg") and output packet check ("opc").
The tpg architecture includes both [a blank packet generator](../p4v-to-dpv/templates/tpg_pktgen.py.tpt), in the form of a python script that operates the packet generator engine of the Tofino switch, and [a test header generation P4 pipeline](../p4v-to-dpv/templates/tpg.p4.tpt). The opg architecture is based on a [packet check P4 pipeline](../p4v-to-dpv/templates/opc.p4.tpt) that leverages ALU-register couples to run basic operations and store their results using single pipeline stages.

## User-facing Abstractions

[User-facing Abstractions](../scripts/settings.sh)

## Test Generation

For non-constant values, P4v-to-PTA takes care of populating the header fields by meeting all the constraints specified through the assumptions.

## Test Execution