#Puppet configuration for Vagrant hosts

$subnet=101

class hostsfile {
	#this class provides proper /etc/hosts for all machines
	#no DNS server needed ;-)
   
  	host { 'lanserver': ip => "10.$subnet.33.31",}	
  	host { 'lanclient': ip => "10.$subnet.33.32",}	
	host { 'dmzserver': ip => "10.$subnet.66.61",}	
  	host { 'internet': ip  => "10.$subnet.99.99",}
  	
}

class baseconfig {
	include hostsfile

	exec { "apt-get update":
		command	=> "/usr/bin/apt-get update",
	}

	file { "lab.box":
		path	=> "/lab.box",
		ensure	=> directory,
	}
	
	include schemafile

	#packages to install:
	package { "htop": ensure => installed, require => Exec["apt-get update"], }
	package { "vim": ensure => installed, require => Exec["apt-get update"], }
	package { "tree": ensure => installed, require => Exec["apt-get update"], }
	package { "screen": ensure => installed, require => Exec["apt-get update"], }
	package { "netcat": ensure => installed, require => Exec["apt-get update"], }
	package { "tcpdump": ensure => installed, require => Exec["apt-get update"], }
	package { "nmap": ensure => installed, require => Exec["apt-get update"], }

}

class lanzonesettings {
	host { 'firewall': ip => "10.$subnet.33.111",}	
  	exec { "route_$subnet":
    		command => "ip route add 10.$subnet.0.0/16 via 10.$subnet.33.111",
		unless 	=> "ip route show | grep 10.$subnet.0.0/16 2> /dev/null",
    		path    => [ '/sbin/', '/bin/' ], 
  	}

}

class enable_ip_forwarding {
  	exec { 'enable_ip_forwarding':
    		command => 'echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf; sysctl -p /etc/sysctl.conf',
		unless 	=> 'grep 1 /proc/sys/net/ipv4/ip_forward 2> /dev/null',
    		path    => [ '/sbin/', '/bin/' ], 
  	}
}


####### NODES DEFINITION #############

node firewall {
	include baseconfig
	include enable_ip_forwarding
	include defaultfirewallfile
	package { "iptables-persistent": ensure => installed, require => Exec["apt-get update"], }
}

node dmzserver {
	include baseconfig
	host { 'firewall': ip => "10.$subnet.66.111",}	
  	exec { "route_$subnet":
    		command => "ip route add 10.$subnet.0.0/16 via 10.$subnet.66.111",
		unless 	=> "ip route show | grep 10.$subnet.0.0 2> /dev/null",
    		path    => [ '/sbin/', '/bin/' ], 
  	}
}

node lanserver {
	include baseconfig
	include lanzonesettings
}

node lanclient {
	include baseconfig
	include lanzonesettings
}

node internet {
	include baseconfig
	host { 'firewall': ip => "10.$subnet.99.111",}
  	exec { "route_$subnet":
    		command => "ip route add 10.$subnet.0.0/16 via 10.$subnet.99.111",
		unless 	=> "ip route show | grep 10.$subnet.0.0/16 2> /dev/null",
    		path    => [ '/sbin/', '/bin/' ], 
  	}
}

class schemafile {
	file { "schema.txt":
		require	=> File["lab.box"],
		path	=> "/lab.box/schema.txt",
		ensure 	=> "present",
		content	=> [ 
"+----------------------------------------------------------------------------------------------------+
|                                                                                                    |
|                                   Vagrant / VirtualBox Hypervisor                                  |
| vbox NAT network 10.0.x.0/24                                                                       |
+-------+---------------------------------+--------------------------------+-----------+---------+---+
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                +           |         |
        |                                 |                               eth0         |         |
        |                                 |                            +-----------+   |         |
        |                                 |                            | lanserver |   |         |
        +                                 +                            |           |   |         |
       eth0                              eth0                  +--+eth1|  IP:31    |   |         |
+----------------+                   +----------+              |       |           |   |         |
|    internet    |                   | firewall |              |       +-----------+   |         |
|                |   10.$subnet.99.x/24  |          |              |                       |         |
|     IP:99      |eth3+--------+eth3 |  IP:111  |eth1+---------+-------+               +         |
|                |                   |          |      10.$subnet.33.x/24  |              eth0       |
+----------------+                   +----------+                      |      +-----------+      |
                                         eth2                          |      | lanclient |      |
                                          +                            |      |           |      |
                                          |                            +-+eth1|  IP:32    |      |
                                          |10.$subnet.66.x/24                     |           |      |
                                          |                                   +-----------+      |
                                          +                                                      |
                                         eth2                                                    |
                                     +-----------+                                               |
 github.com/                         | dmzserver |                                               |
   xonicman/vagrant-linux-labs       |           |                                               |
   /xm-lab-firewall                  |   IP:61   |eth0+------------------------------------------+
                                     |           |
 Created with asciiflow.com          |           |
                                     +-----------+
", ],
	}
}

class defaultfirewallfile {
	file { "default-fw-rules":
		require	=> File["lab.box"],
		path	=> "/lab.box/default-fw-rules",
		ensure	=> "present",
		content	=> [
"# Generated by iptables-save v1.4.21 on Thu Feb  2 00:40:48 2017
*filter
:INPUT ACCEPT [1201:108272]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [792:95030]
COMMIT
# Completed on Thu Feb  2 00:40:48 2017
", ],
	}
}
