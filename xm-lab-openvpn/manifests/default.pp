#Puppet configuration for Vagrant hosts

#define /etc/hosts for all machines
class hostsfile {
    host { 'master.lab.itmz.pl': ip => '192.168.21.253', host_aliases => [ 'master', 'puppetmaster', 'puppet' ], }
    host { 'va.lab.itmz.pl': ip => '192.168.21.100', host_aliases => 'va', }
    host { 'vb.lab.itmz.pl': ip => '192.168.21.200', host_aliases => 'vb', }
    host { 'n1a.lab.itmz.pl': ip => '192.168.21.11', host_aliases => 'n1a', }
    host { 'n1b.lab.itmz.pl': ip => '192.168.21.12', host_aliases => 'n1b', }
    host { 'n2a.lab.itmz.pl': ip => '192.168.21.21', host_aliases => 'n2a', }
    host { 'n2b.lab.itmz.pl': ip => '192.168.21.22', host_aliases => 'n2b', }
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
  package { 'tcpdump': ensure => installed, require => Exec['refresh-repository'], }

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

  exec { 'puppet_agent_enable':
    command => 'puppet agent --enable; /usr/local/sbin/puppet.run.once.sh; touch /etc/puppet/.agent.started.first.time',
    creates => '/etc/puppet/.agent.started.first.time',
    path    => [ '/bin/', '/sbin/', '/usr/bin', ],
    require => File['/usr/local/sbin/puppet.run.once.sh'],
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
  exec { 'install_puppet_module_network':
    command => '/usr/bin/puppet module install example42-network --version 3.3.5',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/network',
  }
  file { '/usr/local/sbin/puppet.parser.validate.syntax.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet parser validate \$1\n",
  }
}

node va, vb {
  include baseconfig
  include puppetagent
  package { 'openvpn': ensure => installed, require => Exec['refresh-repository'], }
}

#default config (hostnames not defined elsewhere)
node default {
  include baseconfig
  include puppetagent
}
