#!/bin/bash

# DATAPLANE
rm -f ${VERSRC}/dataplane/pipe.p4
rm -f ${VERSRC}/dataplane/meta_assign.txt
cp ${VERSRC}/templates/pipe_code.txt ${VERSRC}/dataplane/pipe.p4
cp ${VERSRC}/templates/meta_assign.txt ${VERSRC}/dataplane/meta_assign.txt

# CONTROLPLANE
rm -rf ${VERSRC}/controlplane
mkdir -pv ${VERSRC}/controlplane

# EXTERNS
rm -f ${VERSRC}/dataplane/externs.p4
cp ${VERSRC}/templates/externs_code.txt ${VERSRC}/dataplane/externs.p4

echo " "
echo " "
echo "CODE HAS BEEN RESET!!!"
echo " "
echo " "

exit 0
