#Puppet configuration for Vagrant hosts

class hostsfile {
	#this class provides proper /etc/hosts for all machines
	#no DNS server needed ;-)

	host { 'dmzserver': ip => '192.168.33.31',}	
  	host { 'lanserver': ip => '192.168.44.41',}	
  	host { 'lanclient': ip => '192.168.44.42',}	
  	host { 'internetclient': ip => '192.168.99.99',}
  	
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
	#package { "": ensure => installed, require => Exec["apt-get update"], }

}


class lanzonesettings {
	host { 'firewall': ip => '192.168.44.111',}	
  	exec { 'route_192':
    		command => 'ip route add 192.168.0.0/16 via 192.168.44.111',
		unless 	=> 'ip route show | grep "192.168.0.0/16" 2> /dev/null',
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
	package { "iptables-persistent": ensure => installed, require => Exec["apt-get update"], }
}


node dmzserver {
	include baseconfig
	host { 'firewall': ip => '192.168.33.111',}	
  	exec { 'route_192':
    		command => 'ip route add 192.168.0.0/16 via 192.168.33.111',
		unless 	=> 'ip route show | grep "192.168.0.0/16" 2> /dev/null',
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

node internetclient {
	include baseconfig
	host { 'firewall': ip => '192.168.99.111',}
  	exec { 'route_192':
    		command => 'ip route add 192.168.0.0/16 via 192.168.99.111',
		unless 	=> 'ip route show | grep "192.168.0.0/16" 2> /dev/null',
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
+vbox NAT network 10.0.x.x                                                                           |
+-------+---------------------------------+--------------------------------+-----------+---------+---+
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                |           |         |
        |                                 |                                +           |         |
        |                                 |                               eth0         |         |
        |                                 |                            +-----------+   |         |
        |                                 |                            | lanserver |   |         |
        +                                 +                            |           |   |         |
       eth0                              eth0                  +--+eth1|  IP:41    |   |         |
+----------------+                   +----------+              |       |           |   |         |
| internetclient |                   | firewall |              |       +-----------+   |         |
|                |  192.168.99.x/24  |          |              |                       |         |
|     IP:99      |eth3+--------+eth3 |  IP:111  |eth1+---------+-------+               +         |
|                |                   |          |      192.167.44.x/24 |              eth0       |
+----------------+                   +----------+                      |      +-----------+      |
                                         eth2                          |      | lanclient |      |
                                          +                            |      |           |      |
                                          |                            +-+eth1|  IP:42    |      |
                                          |192.167.33.x/24                    |           |      |
                                          |                                   +-----------+      |
                                          +                                                      |
                                         eth2                                                    |
                                     +-----------+                                               |
 github.com/                         | dmzserver |                                               |
   xonicman/vagrant-linux-labs       |           |                                               |
   /xm-lab-firewall                  |   IP:31   |eth0+------------------------------------------+
                                     |           |
 Created with asciiflow.com          |           |
                                     +-----------+
", ],
	}
}
