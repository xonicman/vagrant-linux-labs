#Puppet configuration for Vagrant hosts


class hostsfile {
	#this class provides proper /etc/hosts for all machines
	#no DNS server needed ;-)

	host { 'host01': ip => '192.168.77.201', host_aliases => [ 'server', 'srv' ], }	
  	host { 'host02': ip => '192.168.77.202', host_aliases => [ 'client', 'cli' ], }	
  	
	#this is only example that you can add external IPs to /etc/hosts
	host { 'googledns': ip => '8.8.8.8', host_aliases => [ 'g1', 'google1' ], }

	# ;-)
	host { 'www.onet.pl': ip => '127.0.0.1', host_aliases => [ 'onet.pl', 'onet' ], }	

	#below line is only for fast copying
	#host { '': ip => '192.168.77.', host_aliases => [ 'client', 'cli' ], }	
}

class baseconfig {
	include hostsfile

	exec { "apt-get update":
		command	=> "/usr/bin/apt-get update",
	}

	file { "xonicman.box":
		path	=> "/usr/local/lib/xonicman.box",
		ensure	=> directory,
	}

	#packages to install:
	package { "htop": ensure => installed, require => Exec["apt-get update"], }
	package { "vim": ensure => installed, require => Exec["apt-get update"], }
	package { "tree": ensure => installed, require => Exec["apt-get update"], }
	#package { "": ensure => installed, require => Exec["apt-get update"], }

}


node host01 {
	include baseconfig
	package { "iotop": ensure => installed, require => Exec["apt-get update"], }
}


node host02 {
	include baseconfig
	package { "nmap": ensure => installed, require => Exec["apt-get update"], }
}

