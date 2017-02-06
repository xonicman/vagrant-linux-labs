# Install dns utils based on OS
class xm_puppetdemo::soft_dns_utils {
        if $operatingsystem == 'CentOS' {
                package { 'bind-utils': ensure => 'installed' }
        }
        else {
                package { 'dnsutils': ensure => 'installed' } #works on Debian
        }
}

