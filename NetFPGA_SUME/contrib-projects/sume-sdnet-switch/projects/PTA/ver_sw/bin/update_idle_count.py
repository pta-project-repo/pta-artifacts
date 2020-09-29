#!/usr/bin/env python

import sys, os, argparse


def update_idle_count(filename):
    try:
        content = open(filename).read()
    except IOError as e:
        print >> sys.stderr, "ERROR: could not open SDNet testbench file"
        sys.exit(1)

    newContent = content.replace('idleCount == 1000', 'idleCount == 2000')
    newContent = newContent.replace('stopping simulation after 1000 idle cycles', 'stopping simulation after 2000 idle cycles')

    with open(filename, 'w') as f:
        f.write(newContent)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('testbench_file', type=str, help="SDNet testbench file")
    args = parser.parse_args()

    update_idle_count(args.testbench_file)


if __name__ == '__main__':
    main()

