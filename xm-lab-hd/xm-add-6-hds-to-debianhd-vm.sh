#!/bin/bash

# Author: https://github.com/xonicman
# This scirpt is part of https://github.com/xonicman/vboxscripts

#################################################################################
# You need to run this script in the folder where you want to create vmhd files.#
#################################################################################

VAGRANT_FILE_ID=".vagrant/machines/debianhd/virtualbox/id"

if [ ! -r $VAGRANT_FILE_ID ]; then
  echo You need to run this command inside xm-lab-hd folder
  echo If you did an still get this message please do first:
  echo 'vagrant up && vagrant halt'
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

if [ -e vmhd02-$VMID.vdi ]; then
	echo There is already vmhd02-$VMID.vdi on this folder. 
	echo Clear old hds first, also from VirtualBox!
	echo Consider using xm-remove-6-hds-from-debianhd-vm.sh
	exit 3
fi

vboxmanage storagectl $VMID --name "SATA Controller" --add sata --controller IntelAhci --portcount 10
#hds are indexed from 2:
for DISKNR in $(seq 2 $(($NROFDISKS+1))); do
	vboxmanage createmedium disk --size 1000 --filename vmhd0$DISKNR-$VMID.vdi
	vboxmanage storageattach $VMID --storagectl "SATA Controller" --port $DISKNR \
		--type hdd --hotpluggable on --medium vmhd0$DISKNR-$VMID.vdi
done

