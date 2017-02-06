#RunRestart mysql once
class xm_puppetdemo::restart_mysql_once {
  $servicename = $::operatingsystem ? {
    Debian  => 'mysql',
    default => 'mysqld',
  }

  file { 'myslq_server_restarted':
    path    => '/var/local/mysql_restarted.tag',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => "restart number 003\n", #change this to restart service
    notify  => Service[$servicename],
  }
}
