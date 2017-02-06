# install and start mysqld service
class xm_puppetdemo::service_install_and_run_mysqld {
  package { 'mysql-server': ensure => installed }
  service { 'mysql':
    ensure  => 'running',
    enable  => true,
    require => Package['mysql-server'],
  }

}
