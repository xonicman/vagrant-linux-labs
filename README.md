# vagrant-linux-labs
Set of Vagrant configuration for Linux Labs

## Vagrant configs

1. xm-lab-provisioned-by-puppet-1node - example of one Debian node provisioned by Puppet
2. xm-lab-provisioned-by-puppet-2nodes - example of two Debian nodes provisioned by Puppet
3. xm-lab-ssh - two nodes for client-server ssh connectivity & tests
4. xm-lab-firewall - five nodes with firewall in the middle for firewall lab, LAN schema at /lab.box/schema.txt on all machines
5. xm-lab-puppet - five nodes: puppetmaster, two Debian nodes, two CentOS nodes
6. xm-lab-twonodes - debian8 & centos7, without extra config, for variuous lab training
7. xm-lab-fileshare - demo for samba, ftp & nfs filesharing
8. xm-lab-mysql-cluster - demo for MySQL 5.5 cluster with Heartbeat, 4 nodes: puppetmaster, mysql01-02 & client

## Tested on Environments

1. ENV1
 * Vagrant 1.9.1
 * Oracle VirtualBox 5.1.12r112440
 * Arch Linux - 4.8.13-1-ARCH #1 SMP PREEMPT Fri Dec 9 07:24:34 CET 2016 x86_64 GNU/Linux

2. ENV2
 * Vagrant 1.9.1
 * Oracle VirtualBox 5.1.14r112924
 * Linux Mint 18 Sarah - 4.4.0-59-generic #80-Ubuntu SMP Fri Jan 6 17:47:47 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

3. ENV3
 * Vagrant 1.9.1
 * Oracle VirtualBox 5.1.14r112924
 * Arch Linux - 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET 2017 x86_64 GNU/Linux

## Test Results

1. xm-lab-provisioned-by-puppet-1node
 * ENV1 OK
 * ENV2 OK
2. xm-lab-provisioned-by-puppet-2nodes
 * ENV1 OK
 * ENV2 OK
3. xm-lab-ssh
 * EVN1 OK
 * ENV2 OK
4. xm-lab-firewall
 * ENV1 not tested
 * ENV2 OK
 * ENV3 OK
5. xm-lab-puppet
 * ENV1 not tested
 * ENV2 OK
 * ENV3 OK
6. xm-lab-twonodes
 * ENV1 not tested
 * ENV2 not tested
 * ENV3 OK
7. xm-lab-fileshare
 * ENV1 not tested
 * ENV2 not tested
 * ENV3 OK
8. xm-lab-mysql-cluster
 * ENV1 not tested
 * ENV2 not tested
 * ENV3 OK
