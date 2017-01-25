class hostsfile {
  host { 'server': ip => '192.168.77.10', host_aliases => [ 'sshsrv', 'srv' ], }	
  host { 'client01': ip => '192.168.77.11', host_aliases => [ 'cli01', 'sshcli01' ], }	
  host { 'client02': ip => '192.168.77.12', host_aliases => [ 'cli02', 'sshcli02' ], }	
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
	package { "screen": ensure => installed, require => Exec["apt-get update"], }
	#package { "": ensure => installed, require => Exec["apt-get update"], }
}


node server {
	include baseconfig
}


node client01 {
	include baseconfig
	package { "xinetd": ensure => installed, require => Exec["apt-get update"], }
}

node client02 {
	include baseconfig
}
