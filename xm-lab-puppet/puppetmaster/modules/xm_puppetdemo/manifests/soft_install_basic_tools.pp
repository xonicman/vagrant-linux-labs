# Install basic tools on node
class xm_puppetdemo::soft_install_basic_tools {
  package { 'mutt': ensure => 'installed' }
  package { 'wget': ensure => 'installed' }
  package { 'screen': ensure => 'installed' }
  package { 'htop': ensure => 'installed' }
  package { 'mc': ensure => 'installed' }
  package { 'nmap': ensure => 'absent' }
  package { 'rsync': ensure => 'installed' }

  include soft_dns_utils
  include soft_netcat
  include soft_other
}
