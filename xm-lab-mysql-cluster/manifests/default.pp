#Puppet configuration for Vagrant hosts

#define /etc/hosts for all machines
class hostsfile {
  host { 'master.lab.itmz.pl': ip => '192.168.17.100', host_aliases => [ 'master', 'puppetmaster', 'puppet', ], }
  host { 'mysql01.lab.itmz.pl': ip => '192.168.17.101', host_aliases => [ 'mysql01', 'm1', ], }
  host { 'mysql02.lab.itmz.pl': ip => '192.168.17.102', host_aliases => [ 'mysql02', 'm2', ], }
  host { 'mysqlcluster.lab.itmz.pl': ip => '192.168.17.107', host_aliases => [ 'mysqlcluster', 'mysql', ], }
  host { 'client.lab.itmz.pl': ip => '192.168.17.111', host_aliases => [ 'client', 'c', ], }
}

#base configuration, can be used for all nodes
class baseconfig {
  include hostsfile
  
  $exec_update_command = $::operatingsystem ? {
    CentOS => '/bin/echo yum does automatic update almost every time',
    Debian => '/usr/bin/apt-get update',
    defaut => '/usr/bin/apt-get update',
  }
  
  exec { 'refresh-repository':
    command  => $exec_update_command,
  }

  file { 'lab':
    path   => '/lab',
    ensure => directory,
  }

  #packages to install:
  $vim_package = $::operatingsystem ? {
    CentOS => 'vim-enhanced',
    Debian => 'vim',
    defaut => 'vim',
  }

  package { $vim_package: ensure => installed, require => Exec['refresh-repository'], }
  package { 'htop': ensure => installed, require => Exec['refresh-repository'], }
  package { 'tree': ensure => installed, require => Exec['refresh-repository'], }
  package { 'screen': ensure => installed, require => Exec['refresh-repository'], }
  package { 'git': ensure => installed, require => Exec['refresh-repository'], }
  package { 'etckeeper': ensure => installed, require => Exec['refresh-repository'], }

  service { "puppet":
        ensure => stopped,
        enable => false,
  }
}

#config for every puppet agent
class puppetagent {
  file { '/usr/local/sbin/puppet.run.once.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet agent --no-daemonize --onetime --verbose ${1}\n",
  }

  exec { 'config_puppet_server_to_master.lab.itmz.pl':
    command => 'echo "[agent]" >> /etc/puppet/puppet.conf; echo "server=master.lab.itmz.pl" >> /etc/puppet/puppet.conf',
    unless  => 'grep "^server=master.lab.itmz.pl$" /etc/puppet/puppet.conf 2> /dev/null',
    path    => [ '/bin/', '/sbin/' ],
 }
}


node master {
  include baseconfig
  package { 'puppetmaster': ensure => installed, require => Exec['refresh-repository'], }
  package { 'puppet-lint': ensure => installed, require => Exec['refresh-repository'], }
  package { 'mc': ensure => installed, require => Exec['refresh-repository'], }
  exec { 'install_puppet_module_stdlib':
    command => '/usr/bin/puppet module install puppetlabs-stdlib',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/stdlib',
  }
  exec { 'install_puppet_module_inifile':
    command => '/usr/bin/puppet module install puppetlabs-inifile',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/inifile',
  }
  exec { 'install_puppet_module_mysql':
    command => '/usr/bin/puppet module install puppetlabs-mysql --version 3.10.0',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/mysql',
  }
  file { '/usr/local/sbin/puppet.parser.validate.syntax.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet parser validate \$1\n",
  }
}

#config for all other nodes
node default {
  include baseconfig
  include puppetagent
}

