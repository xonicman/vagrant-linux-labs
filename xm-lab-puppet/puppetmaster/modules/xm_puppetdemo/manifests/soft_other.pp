#Install other soft based on agent hostname
class xm_puppetdemo::soft_other {

        if $hostname =~ /^agent\d{2}$/ {
                package { 'iotop': ensure => 'absent' }
                package { 'iftop': ensure => 'installed' }
        }

        if $hostname != 'agent02' {
                package { 'atop': ensure => 'installed' }
                package { 'hddtemp': ensure => 'installed' }
                package { 'hdparm': ensure => 'installed' }
        }
}


