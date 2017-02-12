#lab for Samba Service - client packages
class xm_samba::client {

  package { "smbclient": ensure => installed, }
  package { "cifs-utils": ensure => installed, }

}
