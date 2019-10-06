# vagrant-linux-labs
Set of Vagrant configuration for Linux Labs.

You need to install Vagrant and Oracle VirtualBox (tested on Vagrant 1.9.1 and Oracle Virtual Box 5.1..14r112924).

Then:  
  
git clone https://github.com/xonicman/vagrant-linux-labs.git  
cd vagrant-linux-labs/NAME_OF_LAB  
vagrant up  
vagrant status  
vagrant ssh NAME_OF_MACHINE  

## Vagrant configs

01. xm-lab-provisioned-by-puppet-1node - example of one Debian node provisioned by Puppet
02. xm-lab-provisioned-by-puppet-2nodes - example of two Debian nodes provisioned by Puppet
03. xm-lab-ssh - two nodes for client-server ssh connectivity & tests
04. xm-lab-firewall - five nodes with firewall in the middle for firewall lab
05. xm-lab-puppet - five nodes: puppetmaster, two Debian nodes, two CentOS nodes
06. xm-lab-twonodes - debian8 & centos7, without extra config, for variuous lab training
07. xm-lab-fileshare - demo for samba, ftp & nfs filesharing
08. xm-lab-mysql-cluster - demo for MySQL 5.5 cluster with Heartbeat, 4 nodes: puppetmaster, mysql01-02 & client
09. xm-lab-4nodes - Debian8 x2, Centos7 x2demo, 4 extra interfaces for each node, can be used for network tools testing
10. xm-lab-openvpn - 6 hosts (puppetmaster for initial config, vpnclient, vpnserver and 4 hosts to simulate site-to-site vpn)
11. xm-lab-bacula - 4 hosts (puppetmaster for initial config, bacula server with all components, client01 and client02)
12. xm-lab-hd - 1 node Debian8
13. xm-lab-smtp - five Debian nodes with LAN, DMZ, Internet zones and Firewall in the middle to test any SMTP server

## Imporatant notice - ulimit

Please keep in mind that some of the labs have many virtual machines. To run such, you need to set a higher value for the limit of open files on a host system. The author of this readme had problems with running xm-lab-openvpn with ulimit set to 1024 files. After changing that to 8196 value, the problem disappeared.
