***
# Finding Hard-to-Find Data Plane Bugs with a PTA: Reproduction Environment

This repository provides a reproduction environment for the paper "Finding Hard-to-Find Data Plane Bugs with a PTA" (CoNEXT 2020).

When citing this work, please use the following citation information:
Finding Hard-to-Find Data Plane Bugs with a PTA, In ACM CoNEXT.
Authors: Pietro Bressana, Noa Zilberman and Robert Soule.

# Paper

[CoNEXT Paper](https://www.cs.yale.edu/homes/soule/pubs/conext2020-bressana.pdf)

# Paper Abstract
Bugs in network hardware can cause tremendous problems. However, programmable devices have the potential to provide greater visibility into the internal behavior of devices, allowing us to more quickly find and identify problems. In this paper, we provide a taxonomy of data plane bugs, and use the taxonomy to derive a Portable Test Architecture (PTA) which offers essential abstractions for testing on a variety of hardware devices. PTA is implemented with a novel data plane design that (i) separates target-specific from target- independent components, allowing for portability, and (ii) allows users to write a test program once at compile time, but dynamically alter the behavior via runtime configuration. We report 12 diverse bugs on different hardware targets, and their associated software, exposed using PTA.

# Repository Structure
This repository includes the two artifacts introduced in the paper:

1. An implementation of PTA on NetFPGA SUME, using SDNet 2018.2 and P4_16.

2. An implementation of PTA on Barefoot Tofino, using P4_14.

Each artifact's folder includes a README.md file with detailed setup instructions.

## Example Test Program
We expand the discussion about P4v-to-PTA, that we presented in the paper, by describing an [example test program](Barefoot_Tofino/docs/README.md).