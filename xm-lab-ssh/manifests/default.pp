class hostsfile {
  host { 'sshsrv': ip => '192.168.77.11', host_aliases => [ 'server', 'srv' ], }	
  host { 'sshcli': ip => '192.168.77.12', host_aliases => [ 'client', 'cli' ], }	
#  host { '': ip => '192.168.77.', host_aliases => [ 'client', 'cli' ], }	
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
	package { "iotop": ensure => installed, require => Exec["apt-get update"], }
	package { "nmap": ensure => installed, require => Exec["apt-get update"], }
	#package { "": ensure => installed, require => Exec["apt-get update"], }

}


node sshsrv {
	include baseconfig
}


node sshcli {
	include baseconfig
}

