#report date to file in cron
class xm_puppetdemo::cron_report_date {

  cron { 'report_date_cron_entry':
    #ensure => 'absent',
    command => '/usr/local/bin/report_date.sh',
    user    => 'reportuser',
    minute  => '*/1',
    require => [
      File['report_date_script'],
      User ['reportuser'],
    ],
  }

  file { 'report_date_script':
    path    => '/usr/local/bin/report_date.sh',
    owner   => 'root',
    group   => 'reportgroup',
    mode    => '0750',
    content => file ('xm_puppetdemo/usr/local/bin/report_date.sh'),
    require => [
      Group['reportgroup'],
      File['report_date_script_log'],
    ],
  }

  #report_date.sh script will be executed via reportuser, so account should exist on system:
  user { 'reportuser':
    ensure     => 'present',
    comment    => 'User for reporting date',
    uid        => '5001',
    groups     => [ 'reportgroup' ],
    shell      => '/bin/false',
    managehome => true,
    require    => Group['reportgroup'],
  }

  group { 'reportgroup':
    ensure => 'present',
    gid    => '5001',
  }

  #report_date.sh script executed via cron by reportuser will add lines to /var/log/dates.log
  #below resource will set require permissions for reportuser:
  
  file { 'report_date_script_log':
    ensure  => 'file',
    path    => '/var/log/dates.log',
    owner   => 'root',
    group   => 'reportgroup',
    mode    => '0660',
    require => Group['reportgroup'],
  }
}
