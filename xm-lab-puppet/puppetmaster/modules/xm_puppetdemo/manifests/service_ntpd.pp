#Enable nptd configuration 
# default values for service_ntpd class arguments are:
#  environment test
#  service should be running
#  first ntpd server for use should be 0.us.pool.ntp.org
class xm_puppetdemo::service_ntpd (
  $environment = 'test',
  $servicestatus = 'running',
  $ntpserver0 = '0.us.pool.ntp.org',
  ) {

    if $operatingsystem == 'CentOS' and $operatingsystemmajrelease == '7' {

      #Put some info on console while puppet agent will run:
      notify {'ntpd4centos':
        message => "LOOK: (${hostname}) from (${environment}) environment would like to have ntpd service ${servicestatus}",
      }

      #Make sure that service is in defined via $servicestatus variable state:
      service { 'ntpd':
        ensure  => $servicestatus,
        enable  => true,
        require => [ Package['ntp'], Notify['ntpd4centos'] ],
      }

      #Install package ntpdate (ntp server)
        package { 'ntp':
        ensure => 'installed',
      }

     file { '/etc/ntp.conf':
       mode    => '0644',
       owner   => 'root',
       group   => 'root',
       require => Package['ntp'],
       content => template("xm_puppetdemo/ntpd/${environment}/ntp.conf.erb"),
       #DEMO Every time /etc/ntp.conf change, the ntpd service will be notified to reload configuration:
       notify  => Service['ntpd'],
     }
   }
   else {
     #for other operating systems just place error on puppet agent
     fail('LAB ADMIN CUSTOM INFO: Your puppetmaster configuration is not ready to deal with ntpd service on your Linux Distribution.')
   }
}
