node 'default' {

#  file { '/tmp/puppetized-default-node':
#    ensure => 'directory',
#    owner  => 'root',
#    group  => 'puppet',
#    mode   => '0755',
#  }

}

#Debian node:
node 'agent01' {

#  package { 'lynx': ensure => present, }

#  file { '/tmp/puppetized-node-agent01':
#    ensure => 'present',
#    owner  => 'puppet',
#    group  => 'puppet',
#    mode   => '0644',
#  }
  
#  #module:
#  include xm_basenode

#  #classess within module:
#  include xm_puppetdemo::del_file
#  include xm_puppetdemo::local_hosts
#  include xm_puppetdemo::change_line_config_disable_root_sshd
#  include xm_puppetdemo::service_install_and_run_mysqld
#  include xm_puppetdemo::inline_change_mysqld_config
#  include xm_puppetdemo::cron_report_date
#  include xm_puppetdemo::local_users
#  include xm_puppetdemo::soft_install_basic_tools
#  include xm_puppetdemo::restart_mysql_once
#  include xm_puppetdemo::execute_script_once
#  #include xm_puppetdemo::service_ntpd

}

#Debian node:
#node 'agent02' {
#
#  include xm_basenode
#  include xm_puppetdemo
#
#}

#CentOS node:
#node 'agent03' {
#
#  include xm_basenode
#
#  ##class with default parameters:
#  #include xm_puppetdemo::service_ntpd
#
#  ##OR class with custom parameters:
#  class {'xm_puppetdemo::service_ntpd': environment => 'test', ntpserver0 => '0.pl.pool.ntp.org' }
#
#}

##CentOS node:
#node 'agent04' {
#  include xm_basenode
#  class {'xm_puppetdemo::service_ntpd': environment => 'prod', ntpserver0 => '1.pl.pool.ntp.org' }
#}


if versioncmp($::puppetversion,'3.6.1') >= 0 {
  # Based on
  # https://ask.puppet.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

