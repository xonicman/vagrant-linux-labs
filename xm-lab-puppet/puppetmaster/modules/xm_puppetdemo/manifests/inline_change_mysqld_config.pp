#change mysqld config
class xm_puppetdemo::inline_change_mysqld_config {
  #make sure that you have installed module inifile on puppetmaster
  #ls /etc/puppet/modules
  #puppet module install puppetlabs-inifile

        
  ini_setting {'query_cache_limit set':
    path    => '/etc/mysql/my.cnf',
    section => 'mysqld',
    setting => 'query_cache_limit',
    value   => '2M',
    #notify => Service ['mysql'], #risky -> will restart service
    #ensure => absent,
  }

}
