node default {

  host { 'debian8.lab.itmz.pl': ip => '192.168.102.8', host_aliases => [ 'debian8', 'debian', 'd', ], }
  host { 'centos7.lab.itmz.pl': ip => '192.168.102.7', host_aliases => [ 'centos7', 'centos', 'c', ], }

  service { "puppet":
	ensure => stopped,
	enable => false,
  }

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

  exec { 'custom_PS1_for_root':
    command => 'echo "PS1=\"\[\e[1;34m\][\u@\h \W]\$\[\e[m\] \"" >> /root/.bashrc; touch /root/.custom.ps1.done',
    creates => '/root/.custom.ps1.done',
    path    => [ '/bin/', '/sbin/', '/usr/bin', ],
  }

  exec { 'custom_PS1_for_vagrant':
    command => 'echo "PS1=\"\[\e[1;36m\][\u@\h \W]\$\[\e[m\] \"" >> /home/vagrant/.bashrc; touch /home/vagrant/.custom.ps1.done',
    creates => '/home/vagrant/.custom.ps1.done',
    path    => [ '/bin/', '/sbin/', '/usr/bin', ],
  }

}
