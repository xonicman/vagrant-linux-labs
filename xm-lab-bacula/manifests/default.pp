#Puppet configuration for Vagrant hosts

#define /etc/hosts for all machines
class hostsfile {
    host { 'master.lab.itmz.pl': ip => '192.168.55.253', host_aliases => [ 'master', 'puppetmaster', 'puppet' ], }
    host { 'bacula.lab.itmz.pl': ip => '192.168.55.11', host_aliases => ['bacula', 'b', ],  }
    host { 'client01.lab.itmz.pl': ip => '192.168.55.12', host_aliases => ['client01', 'c1', 'centos7', 'centos' ],  }
    host { 'client02.lab.itmz.pl': ip => '192.168.55.13', host_aliases => ['client02', 'c2', 'debian8', 'debian' ],  }
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
  exec { 'install_puppet_module_mysql':
    command => '/usr/bin/puppet module install puppetlabs-mysql --version 3.10.0',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/mysql',
  }
  exec { 'install_puppet_module_alternatives':
    command => '/usr/bin/puppet module install adrien-alternatives --version 0.3.0',
    require => Package['puppetmaster'],
    creates => '/etc/puppet/modules/alternatives',
  }
  file { '/usr/local/sbin/puppet.parser.validate.syntax.sh':
    owner   => root,
    group   => root,
    mode    => '0750',
    content => "#!/bin/sh\n#puppetfile\npuppet parser validate \$1\n",
  }
}

#default config (hostnames not defined elsewhere)
node default {
  include baseconfig
  include puppetagent
}

