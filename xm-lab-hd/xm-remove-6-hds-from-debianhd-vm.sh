#!/bin/bash

# Author: https://github.com/xonicman
# This scirpt is part of https://github.com/xonicman/vboxscripts

##############################################################################
# You need to run this script in the folder where you previously created     #
# 6 hds with xm-add-6-hds-to-debianhd-vm.sh script.                                   #
##############################################################################

VAGRANT_FILE_ID=".vagrant/machines/debianhd/virtualbox/id"

if [ ! -r $VAGRANT_FILE_ID ]; then
  echo It seems that vm does not exist. 
  exit 1
fi

#variables
VMID=$(cat $VAGRANT_FILE_ID)
NROFDISKS=6

vboxmanage showvminfo $VMID &> /dev/null || {
		echo "I cannot find VM with UUID: $1"
		echo
		echo "Please review VirtualBox vms UUIDs and next time use proper one:"
		vboxmanage list vms
		exit 2
}

for DISKNR in $(seq 2 $(($NROFDISKS+1))); do
	vboxmanage storageattach $VMID --storagectl "SATA Controller" --port $DISKNR --medium none && \
	vboxmanage closemedium vmhd0$DISKNR-$VMID.vdi && \
	rm -f vmhd0$DISKNR-$VMID.vdi 
done

