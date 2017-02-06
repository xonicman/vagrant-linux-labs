#Puppet configuration for Vagrant hosts

#define /etc/hosts for all machines
class hostsfile {
  host { 'master.lab.itmz.pl': ip => '192.168.14.100', host_aliases => [ 'master', 'server', 'puppetmaster' ], }
    host { 'agent01.lab.itmz.pl': ip => '192.168.14.101', host_aliases => 'agent01', }
    host { 'agent02.lab.itmz.pl': ip => '192.168.14.102', host_aliases => 'agent02', }
    host { 'agent03.lab.itmz.pl': ip => '192.168.14.103', host_aliases => 'agent03', }
    host { 'agent04.lab.itmz.pl': ip => '192.168.14.104', host_aliases => 'agent04', }
  #host { '': ip => '192.168.77.', host_aliases => [ 'client', 'cli' ], }	
}

#base configuration, can be used for all nodes
class baseconfig {
  include hostsfile
  
  $exec_update_command = $::operatingsystem ? {
    CentOS => '/bin/echo yum does not need to update',
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

  package { 'htop': ensure => installed, require => Exec['refresh-repository'], }
  package { $vim_package: ensure => installed, require => Exec['refresh-repository'], }
  package { 'tree': ensure => installed, require => Exec['refresh-repository'], }
  package { 'screen': ensure => installed, require => Exec['refresh-repository'], }
  #package { "": ensure => installed, require => Exec["refresh-repository"], }

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


#config for node where hostname=master
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
  file { '/usr/local/sbin/puppet.parser.validate.syntax.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet parser validate \$1\n",
  }
}

#config for all agentXX nodes
node /^agent\d+$/ {
  include baseconfig
  include puppetagent
}

#default config (hostnames not defined elsewhere)
node default {
  include baseconfig
}
