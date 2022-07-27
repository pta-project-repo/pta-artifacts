***
# Example Test Program

We explain the operations of the P4v-to-PTA translator through an example test program, which is similar to the one described in our paper.

## Test Program

The [example test program](put_example_code/data-plane/put.p4) implements a simple P4 pipeline with [one table](put_example_code/data-plane/put.p4#L46) and [one action](put_example_code/data-plane/put.p4#L38), besides [the table-action couple](put_example_code/data-plane/put.p4#L22-L32) that sets the destination port to a hard-coded value.
[The parser](put_example_code/data-plane/put.p4#L16-L19) extracts the only [header](put_example_code/data-plane/include/headers.p4) known by the program, which includes seven 8b-wide fields.
[The control section](put_example_code/data-plane/put.p4#L54) of the pipeline applies the two tables defined in the program [to process the header fields](put_example_code/data-plane/put.p4#L60) [and to set the destination port](put_example_code/data-plane/put.p4#L68) in the metadata.

We annotated the example test program with P4v assumptions and assertions in the control section.
[Assumptions](put_example_code/data-plane/put.p4#L55-L59) provide P4v-to-PTA the input values for the test, i.e. the values used to generate the input test packets. As shown in the example test program, P4v-to-PTA supports both constant values and basic operators to constraint the values assigned to the header fields.
[Assertions](put_example_code/data-plane/put.p4#L61-L65) specify the value each header field is expected to have after the completion of the test.

## Back-end Abstractions

P4v-to-PTA abstracts the target hardware architecture in way which makes it usable at a higher level both to implement and to run test configurations.
The hardware abstraction includes both hardware components, i.e. the metadata bus, and scripts that automate the usage of such components, i.e. accessing registers.
Beside the layout of the metadata bus, [the Barefoot Tofino hardware abstraction](../p4v-to-dpv/templates) covers both test packet generation ("tpg") and output packet check ("opc").
The tpg architecture includes both [a blank packet generator](../p4v-to-dpv/templates/tpg_pktgen.py.tpt), in the form of a python script that operates the packet generator engine of the Tofino switch, and [a test header generation P4 pipeline](../p4v-to-dpv/templates/tpg.p4.tpt). The opg architecture is based on a [packet check P4 pipeline](../p4v-to-dpv/templates/opc.p4.tpt) that leverages ALU-register couples to run basic operations and store their results using single pipeline stages.

## User-facing Abstractions

User-facing abstractions for the Tofino architecture are included in a [script](../scripts/settings.sh) that allows P4v-to-PTA to use the abstractions as they were bash commands. Each abstraction runs a dedicated script that leverages Tofino's primitives to implement the desired functionality.
For example, to load a program image to a switch, P4v-to-PTA uses [the "Load_Image"](../scripts/settings.sh#L15-L16) abstraction which, in turn, runs the "run_switchd.sh" script provided by Barefoot with the Tofino switch.

## Test Generation

Given both a test program and the target abstractions, P4v-to-PTA automatically implements a test-specific, target-specific hardware/software configuration as the results of [a sequence of operations](../p4v-to-dpv/scripts/p4v-to-dpv.py), including code analysis, test data generation and hardware configuration.

#### Code Analysis

P4v-to-PTA parses the test program code and [extracts](../p4v-to-dpv/scripts/library.py#L48) all the P4v annotations (both assumptions and assertions).
It also [comments-out](../p4v-to-dpv/scripts/p4v-to-dpv.py#L23) all the annotations, thus making the code compliant with the target-specific compiler.

#### Test Data Generation

P4v-to-PTA reads [the header file](put_example_code/data-plane/include/headers.p4) included in the test program, creates blank test headers with the fields specified in the header file and [populates all the fields](../p4v-to-dpv/scripts/library.py#L337) with the values specified in the assumptions.
Since the assumptions might include additional constraints on header/fields, P4v-to-PTA runs [an additional iteration](../p4v-to-dpv/scripts/library.py#L437) over the test header fields to adjust their values, based on the constraints.
On the other hand, very little processing is required to translate assertions to checks.

#### Hardware Configuration

Leveraging the back-end abstractions, P4v-to-PTA [converts the test data to a hardware configuration](../p4v-to-dpv/scripts/library.py#L1013) that includes both the test packet generator and the output packet checker. It also implements both the [infrastructure to read/write registers](../p4v-to-dpv/scripts/library.py#L1053) and the [configuration of the blank packet generator](../p4v-to-dpv/scripts/library.py#L541).

## Test Execution

P4v-to-PTA tests are managed by a [Python script](../p4v-to-dpv/scripts/run_test.py) that coordinates all the test operations, leveraging the user-facing abstractions.
Before loading the three main components of the system (test packet generator, test program, output packet checker), P4v-to-PTA resets both the [hardware](../p4v-to-dpv/scripts/run_test.py#L86) and the [software](../p4v-to-dpv/scripts/run_test.py#L99) environment of the target switches.
Then, it [configures](../p4v-to-dpv/scripts/run_test.py#L138) the targets with the generated test data and it [compiles](../p4v-to-dpv/scripts/run_test.py#L156) the P4 code directly in the switches.
Once done, P4v-to-PTA [loads](../p4v-to-dpv/scripts/run_test.py#L206) the compiled P4 programs and [configures](../p4v-to-dpv/scripts/run_test.py#L237) all the ports and the registers.
Finally, it triggers the [packet generation](../p4v-to-dpv/scripts/run_test.py#L244) and [collects the results](../p4v-to-dpv/scripts/run_test.py#L250) of the test from the output packet checker.
Results are then printed on screen, highlighting all the violated assertions.