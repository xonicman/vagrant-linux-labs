# demo hosts entries
class xm_puppetdemo::local_hosts {
  host { 'splunk.lab.itmz.pl':
    ip => '10.7.254.37',
  }

  host { 'db.lab.itmz.pl':
    ip           => '10.7.254.17',
    host_aliases => [ 'database', 'db' ],
    #ensure => 'absent',
  }
}

