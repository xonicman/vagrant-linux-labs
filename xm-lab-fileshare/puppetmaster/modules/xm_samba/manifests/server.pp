#lab for Samba Service
class xm_samba::server {

  package { 'samba': ensure => installed, }

  service { 'smbd':
    ensure  => running,
    enable  => true,
    require => [ Package['samba'], File['smb.conf'], ],
  }

  service { 'nmbd':
    ensure  => running,
    enable  => true,
    require => Package['samba'],
  }

  file { 'smb.conf':
    path    => '/etc/samba/smb.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file ('xm_samba/smb.conf'),
    require => Package['samba'],
    notify  => [ Service['smbd'], Service['nmbd'], ],
  }

  file { '/home/samba':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'smbpublicrw',
    mode    => '0775',
    require => Group['smbpublicrw'],
  }

  group { 'smbpublicrw':
    ensure => 'present',
  }

  ## to use pw_hash password hash you need to install on master:
  ## puppet module install puppetlabs-stdlib  
  user { 'kasia':
    ensure     => 'present',
    comment    => 'User for Samba Demo',
    groups     => [ 'smbpublicrw' ],
    shell      => '/bin/bash',
    managehome => true,
    password   => pw_hash('kasia1', 'SHA-512', 'saltisgood'),
    require    => Group['smbpublicrw'],
  }

  file { 'kasiapass':
    path    => '/home/kasia/.kasiapass',
    ensure  => 'file',
    owner   => 'kasia',
    group   => 'kasia',
    mode    => '0400',
    content => file ('xm_samba/kasiapassdemo'),
    require => User['kasia'],
  }

  $tag_smbpasscreated = '/home/kasia/.smbpasscreated'

  exec { 'create_smb_pass_for_kasia':
    command => "/usr/bin/smbpasswd -a kasia < /home/kasia/.kasiapass && touch ${tag_smbpasscreated}",
    creates => $tag_smbpasscreated,
    require => [ File['kasiapass'], Package['samba'], ],
  }

}
