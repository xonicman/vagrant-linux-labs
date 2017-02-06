# Install Netcat tool based on operating system
class xm_puppetdemo::soft_netcat {
  $pkgname = $::operatingsystem ? {
    CentOS   => 'nc',
    Debian   => 'netcat',
    default => 'netcat-tool',
  }

  package { $pkgname: ensure => 'installed' }
}
