file { "lab.box":
	path	=> "/lab.box",
	ensure	=> directory,
}

$exec_update_command = $::operatingsystem ? {
  CentOS => '/bin/echo yum does not need to update',
  Debian => '/usr/bin/apt-get update',
  defaut => '/usr/bin/apt-get update',
}

exec { 'refresh-repository':
  command  => $exec_update_command,
}

#packages to install:
$vim_package = $::operatingsystem ? {
  CentOS => 'vim-enhanced',
  Debian => 'vim',
  defaut => 'vim',
}


package { 'htop': ensure => installed, require => Exec['refresh-repository'], }
package { $vim_package: ensure => installed, require => Exec['refresh-repository'], }
package { 'tree': ensure => installed, require => Exec['refresh-repository'], }
package { 'screen': ensure => installed, require => Exec['refresh-repository'], }
