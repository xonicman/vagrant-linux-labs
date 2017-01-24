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


node host01 {
	package { "iotop": ensure => installed, require => Exec["apt-get update"], }
}

node host02 {
	package { "nmap": ensure => installed, require => Exec["apt-get update"], }
}
