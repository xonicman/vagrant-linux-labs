# vagrant-linux-labs
Set of Vagrant configuration for Linux Labs

## Vagrant configs

1. xm-lab-provisioned-by-puppet-1node - example of one Debian node provisioned by Puppet
2. xm-lab-provisioned-by-puppet-2nodes - example of two Debian nodes provisioned by Puppet
3. xm-lab-ssh - [in progress] two nodes for client-server ssh connectivity & tests

## Tested on Environments

1. ENV1
 * Vagrant 1.9.1
 * Oracle VirtualBox 5.1.12r112440
 * Arch Linux - 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016 x86_64 GNU/Linux

2. ENV2
 * Vagrant 1.9.1
 * Oracle VirtualBox 5.1.14r112924
 * Linux Mint 18 Sarah - 4.4.0-59-generic #80-Ubuntu SMP Fri Jan 6 17:47:47 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

## Test Results

VagrantDirConfig; 			ENV1 Result; 	ENV2 Result;

1. xm-lab-provisioned-by-puppet-1node
 * ENV1 OK
 * ENV2 OK
2. xm-lab-provisioned-by-puppet-2nodes
 * ENV1 OK
 * ENV2 OK
3. xm-lab-ssh
 * EVN1 OK
 * ENV2 OK

